import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nadek/data/model/Challenger.dart';
import 'package:nadek/data/model/livechannel_token.dart';
import 'package:nadek/presentation/screen/virtualTournments/components/challengers_menu.dart';
import 'package:nadek/presentation/screen/virtualTournments/components/custom_button.dart';
import 'package:nadek/presentation/screen/virtualTournments/components/custom_text_field.dart';
import 'package:nadek/presentation/screen/virtualTournments/components/paragraph.dart';
import 'package:nadek/presentation/screen/virtualTournments/virtual_methods.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/constante/agora_config.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:permission_handler/permission_handler.dart';

class LivePage extends StatefulWidget {
  const LivePage(this.channelName, this.isBroadCaster, this.isOwner,
      {super.key});
  final String channelName;
  final bool isBroadCaster;
  final bool isOwner;

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final RtcEngine _engine;
  StreamSubscription? _stream;
  bool showChallengers = false;
  bool isJoined = false, switchCamera = true;
  List<int> remoteUid = [];
  List<Challenger> challengers = [];
  bool _isOwner = false;
  final authorizaitontoken = CacheHelper.getString('tokens');
  final userId = CacheHelper.getString('Id');
  final username = CacheHelper.getString('username');
  String decodedChannelName = '';
  late Dio dio;
  bool _isBroadCaster = true;

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(
      baseUrl: 'https://calmaapp.com/api/',
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    ));

    _isBroadCaster = widget.isBroadCaster;
    _isOwner = widget.isOwner;
    decodedChannelName = stringToBase64.decode(widget.channelName);
    _initEngine();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();

    if (_stream != null) {
      _stream!.cancel();
    }
    _leaveChannel();

    super.dispose();
  }

  Future<void> _initEngine() async {
    _engine =
        await RtcEngine.createWithContext(RtcEngineContext(AgoraConfig.appID));
    _addListeners();

    await _engine.enableVideo();
    await _engine.enableLocalAudio(true);

    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    _isBroadCaster
        ? await _engine.setClientRole(ClientRole.Broadcaster)
        : await _engine.setClientRole(ClientRole.Audience);
    await _joinChannel();

    if (_isBroadCaster) {
      _stream = FirebaseFirestore.instance
          .collection('livestream')
          .doc(widget.channelName)
          .collection('Challengers')
          .snapshots()
          .listen((event) {
        challengers.clear();
        for (var element in event.docs) {
          setState(() {
            challengers.add(Challenger.fromMap(element.data()));
          });
        }
      });
    } else {
      _stream = FirebaseFirestore.instance
          .collection('livestream')
          .doc(widget.channelName)
          .collection('AcceptedChallengers')
          .snapshots()
          .listen((event) {
        for (var element in event.docs) {
          if (element.data().containsValue(userId)) {
            _toBraodCaster();
          }
        }
      });
    }
  }

  void _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      warning: (warningCode) {
        //
      },
      error: (errorCode) {},
      joinChannelSuccess: (channel, uid, elapsed) {
        printWarning('Joined Channel Success');
        if (mounted) {
          setState(() {
            isJoined = true;
          });
        }
      },
      userJoined: (uid, elapsed) {
        printError('userJOined $uid');
        if (mounted) {
          setState(() {
            remoteUid.add(uid);
          });
        }
      },
      userOffline: (uid, reason) async {
        printError('userOffline $uid $reason');
        if (mounted) {
          setState(() {
            remoteUid.removeWhere((element) => element == uid);
          });
        }
      },
    ));
  }

  Future<LiveChannelToken> getRTCToken(String token, String channelName) async {
    dio.options.headers['Authorization'] = ' Bearer$token';

    FormData data = FormData.fromMap({
      'channelName': channelName,
    });

    Response response = await dio.post('agora', data: data);
    print(response.data);
    return LiveChannelToken.fromMap(response.data);
  }

  Future<void> _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    final token = await getRTCToken(authorizaitontoken!, widget.channelName);

    if (token.token.isNotEmpty) {
      final connectionState = await _engine.getConnectionState();

      if (connectionState != ConnectionStateType.Connected) {
        await _engine.leaveChannel();
        await _engine.joinChannel(
            token.token, widget.channelName, null, token.user_id);
        printWarning(
            '-----------------------Joined Channel *---------------------');
      }
    }
  }

  Future<void> _leaveChannel() async {
    remoteUid.clear();
    await _engine.leaveChannel();
  }

  void _toggleChallengers() {
    setState(() {
      showChallengers = !showChallengers;
    });
  }

  void _toBraodCaster() async {
    // await _leaveChannel();

    await _engine.setClientRole(ClientRole.Broadcaster);
    setState(() {
      _isBroadCaster = true;
    });

    // await Future.delayed(const Duration(milliseconds: 250));
    // await _joinChannel();

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (showChallengers) {
          _toggleChallengers();
          return Future.value(false);
        }
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: ColorApp.selver,
        appBar: AppBar(
          backgroundColor: ColorApp.selver,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isOwner)
                  CustomButton(
                    fontsize: 14.0,
                    label: 'انهاء التحدى',
                    width: 120,
                    onTap: () async {
                      await _leaveChannel();
                      await endChallenge(widget.channelName);
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                const SizedBox(width: 8),
                if (_isOwner)
                  CustomButton(
                      fontsize: 14.0,
                      label: 'عرض قائمة الصعود',
                      width: 140,
                      onTap: _toggleChallengers),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Text(
                      decodedChannelName.substring(
                          0,
                          decodedChannelName.length > 12
                              ? 12
                              : decodedChannelName.length),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                children: [
                  if (_isBroadCaster && remoteUid.isEmpty)
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.5,
                      child: const rtc_local_view.SurfaceView(
                        zOrderMediaOverlay: true,
                        zOrderOnTop: true,
                      ),
                    ),
                  if (_isBroadCaster && remoteUid.isNotEmpty) ...[
                    SizedBox(
                      width: size.width * 0.5,
                      height: size.height * 0.5,
                      child: const rtc_local_view.SurfaceView(
                        zOrderMediaOverlay: true,
                        zOrderOnTop: true,
                      ),
                    ),
                    ...List.of(
                      remoteUid.map(
                        (uid) => SizedBox(
                          width: size.width * 0.49,
                          height: size.height * 0.5,
                          child: rtc_remote_view.SurfaceView(
                            channelId: widget.channelName,
                            uid: uid,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (!_isBroadCaster && remoteUid.length == 1)
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.5,
                      child: rtc_remote_view.SurfaceView(
                        channelId: widget.channelName,
                        uid: remoteUid.first,
                      ),
                    ),
                  if (!_isBroadCaster && remoteUid.length > 1)
                    ...List.of(
                      remoteUid.map(
                        (uid) => SizedBox(
                          width: size.width * 0.5,
                          height: size.height * 0.5,
                          child: rtc_remote_view.SurfaceView(
                            channelId: widget.channelName,
                            uid: uid,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: size.width - 48,
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 92, right: 32, left: 32, top: 32),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('livestream')
                                .doc(widget.channelName)
                                .collection('Chat')
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }

                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final data = snapshot.requireData
                                  as QuerySnapshot<Map<String, dynamic>>;

                              return ListView.separated(
                                reverse: false,
                                shrinkWrap: true,
                                itemCount: data.size,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    color: Colors.white,
                                    height: 1,
                                    thickness: 1,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(
                                      data.docs[index]['name'],
                                      textDirection: TextDirection.rtl,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      data.docs[index]['text'],
                                      textDirection: TextDirection.rtl,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 34,
                          right: 34,
                        ),
                        child: Container(
                          width: size.width - 68,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 8),
                                    if (!_isBroadCaster)
                                      CustomButton(
                                        label: 'صعود للتحدى',
                                        width: 80,
                                        fontsize: 10,
                                        onTap: () async {
                                          sendChallenge(
                                              channelName: widget.channelName,
                                              challenger: Challenger(
                                                challengerID: userId!,
                                                challenger: username!,
                                              ));
                                        },
                                      ),
                                    const SizedBox(width: 8),
                                    CustomButton(
                                      label: 'اضافة تعليق',
                                      width: 80,
                                      fontsize: 10,
                                      backgroundColor: Colors.black,
                                      onTap: () async {
                                        if (_chatController.text.isEmpty) {
                                          return;
                                        }
                                        await addChannelMessage(
                                            _chatController.text,
                                            widget.channelName);
                                        _chatController.clear();
                                      },
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: _chatController,
                                    onSubmitted: (value) async {
                                      if (_chatController.text.isEmpty) {
                                        return;
                                      }
                                      await addChannelMessage(
                                          _chatController.text,
                                          widget.channelName);
                                      _chatController.clear();
                                    },
                                    textDirection: TextDirection.rtl,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: 'هنا يمكنك اضافة تعليق',
                                      hintTextDirection: TextDirection.rtl,
                                      hintStyle: TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_isOwner && showChallengers)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ChallengersMenu(
                          challengers: challengers,
                          onAccept: (challenger) async {
                            await acceptChallenge(
                                channelName: widget.channelName,
                                challenger: challenger);
                            _toggleChallengers();
                          },
                          onClose: () => _toggleChallengers(),
                        ),
                      ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('livestream')
                    .doc(widget.channelName)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.requireData;

                  if (data.exists) {
                    // Document exists
                    printWarning('Document Exist');
                  } else {
                    // Document does not exist
                    printError('Document Does not Exist');
                    myCallback(() {
                      if (!_isOwner) {
                        // await _leaveChannel();
                        Navigator.pop(context);
                      }
                    });
                  }

                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
