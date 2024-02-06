import '../../../core/utils/app_colors.dart';
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:nadek/sheard/component/MessageLine.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/constante/string.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

final _firestore = FirebaseFirestore.instance;

class LiveForUser extends StatefulWidget {
  const LiveForUser({super.key});

  @override
  State<LiveForUser> createState() => _LiveForUserState();
}

class _LiveForUserState extends State<LiveForUser> with WidgetsBindingObserver {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  late String textUuid;
  late DocumentReference reference;
  late Future<DocumentSnapshot> snap;
  late String name;
  late String photo;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  int counter = 30;

  bool addUser = false;

  bool enableLocalAudio = true;
  bool enableLocalVideo = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    name = CacheHelper.getString('username')!;
    photo = CacheHelper.getString('photo')!;
    var uuid = Uuid(options: {
      'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
      'clockSeq': 0x1234,
      'mSecs': new DateTime.now(),
      'nSecs': 5678
    });
    textUuid = uuid.v1();
    addUserToLive();
    addViews();
    addLive();
    initAgora();
  }

  void addUserToLive() {
    _firestore.collection('UserToLive').doc(textUuid).collection(textUuid).add({
      'addUser': false,
      'msgAdd': false,
      'total': 0,
      'name': 'non',
      'userId': -1,
      'declinedToLive': false,
      'time': FieldValue.serverTimestamp(),
    });
  }

  void addLive() {
    _firestore
        .collection('StreamLive')
        .doc("Live")
        .collection("ChannelsId")
        .add({
      'channels': textUuid,
      'title': name,
      'imageUrl': photo,
      'time': FieldValue.serverTimestamp(),
    });
  }

  void addViews() {
    _firestore
        .collection('ViewInLive')
        .doc(textUuid)
        .collection(textUuid!)
        .add({
      'view': 0,
      'time': FieldValue.serverTimestamp(),
    });
  }

  void addUidForLive(int uId) {
    _firestore.collection('StreamLive').doc("Uid").collection(textUuid).add({
      'channels': textUuid,
      'Uid': uId,
      'time': FieldValue.serverTimestamp(),
    });
  }

  void deleteUidForLive() {
    _firestore
        .collection('StreamLive')
        .doc("Uid")
        .collection(textUuid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('StreamLive')
            .doc("Uid")
            .collection(textUuid)
            .doc(element.id)
            .delete();
      });
    });
  }

  void Delete() async {
    var c = FirebaseFirestore.instance
        .collection('StreamLive')
        .doc("Live")
        .collection("ChannelsId");
    var shot = c.get().then((value) {
      value.docs.forEach((element) {
        print(element.data()["channels"] + '==' + textUuid);
        if (element.data()["channels"] == textUuid) {
          FirebaseFirestore.instance
              .collection('StreamLive')
              .doc("Live")
              .collection("ChannelsId")
              .doc(element.id)
              .delete();
          deleteViews();
          deleteUserToLive();
          deleteUidForLive();
        }
      });
    });
  }

  void deleteViews() async {
    var c = FirebaseFirestore.instance
        .collection('ViewInLive')
        .doc(textUuid)
        .collection(textUuid!);
    var shot = c.get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('ViewInLive')
            .doc(textUuid)
            .collection(textUuid!)
            .doc(element.id)
            .delete();
      });
    });
  }

  void deleteUserToLive() async {
    var c = FirebaseFirestore.instance
        .collection('UserToLive')
        .doc(textUuid)
        .collection(textUuid);
    var shot = c.get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('UserToLive')
            .doc(textUuid)
            .collection(textUuid!)
            .doc(element.id)
            .delete();
      });
    });
  }

  void declinedToLive() {
    var c = FirebaseFirestore.instance
        .collection('UserToLive')
        .doc(textUuid)
        .collection(textUuid);
    var shot = c.get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('UserToLive')
            .doc(textUuid)
            .collection(textUuid)
            .doc(element.id)
            .update({
              'addUser': false,
              'msgAdd': false,
              'total': 0,
              'name': 'non',
              'declinedToLive': true,
            })
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      });
    });
  }

  void acceptToLive() {
    var c = FirebaseFirestore.instance
        .collection('UserToLive')
        .doc(textUuid)
        .collection(textUuid);
    var shot = c.get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('UserToLive')
            .doc(textUuid)
            .collection(textUuid)
            .doc(element.id)
            .update({
          'addUser': true,
          'msgAdd': false,
          'total': 1,
        }).then((value) {
          print("User Updated");
        }).catchError((error) => print("Failed to update user: $error"));
      });
    });
  }

  void exclusionToLive() {
    var c = FirebaseFirestore.instance
        .collection('UserToLive')
        .doc(textUuid)
        .collection(textUuid!);
    var shot = c.get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('UserToLive')
            .doc(textUuid)
            .collection(textUuid!)
            .doc(element.id)
            .update({
              'addUser': false,
              'msgAdd': false,
              'total': 0,
              'declinedToLive': false,
            })
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      });
    });
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(string_app.appId);
    await _engine.enableVideo();
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (true) {
      await _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine.setClientRole(ClientRole.Audience);
    }
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          addUidForLive(uid);
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(null, textUuid, null, 0);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext contex) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorApp.back1,
      appBar: AppBar(
        backgroundColor: ColorApp.back1,
        toolbarHeight: 0,
        title: const Text('Live'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('UserToLive')
              .doc(textUuid)
              .collection(textUuid)
              .snapshots(),
          builder: (conte, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(color: AppColors.mainColor);
            }

            if (snapshot.data!.docs[0].get("msgAdd")) {
              // _showDialog(snapshot.data!.docs[0].get("name"),contex);
              showInSnackBar(snapshot.data!.docs[0].get("name"));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: 350,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          snapshot.data!.docs[0].get("addUser")
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: _remoteVideo(),
                                    ),
                                    Expanded(child: _localVideo()),
                                  ],
                                )
                              : _localVideo(),
                          Container(
                              height: 50,
                              width: double.infinity,
                              color: Colors.black54,
                              child: BOx())
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: 330,
                    decoration: BoxDecoration(
                        color: ColorApp.black_400,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: _engine.switchCamera,
                            icon: const Icon(
                              Icons.cameraswitch,
                              size: 35,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (enableLocalAudio) {
                                  enableLocalAudio = false;
                                } else {
                                  enableLocalAudio = true;
                                }
                                _engine.enableLocalAudio(enableLocalAudio);
                              });
                            },
                            icon: Icon(
                              enableLocalAudio ? Icons.mic : Icons.mic_off,
                              size: 35,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (enableLocalVideo) {
                                  enableLocalVideo = false;
                                } else {
                                  enableLocalVideo = true;
                                }
                                _engine.enableLocalVideo(enableLocalVideo);
                              });
                            },
                            icon: Icon(
                              enableLocalVideo
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              size: 35,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 300,
                      width: 330,
                      decoration: BoxDecoration(
                          color: ColorApp.black_400,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Expanded(
                            child: StraemComments(),
                          ),
                        ],
                      )),
                ],
              ),
            );
          }),
    );
  }

  void showInSnackBar(String title) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SnackBar s = SnackBar(
        content: Row(
          children: [
            Expanded(
              flex: 1,
              child: TimerCounterDown(),
            ),
            Expanded(
              flex: 3,
              child: Text(' يريد $title ان ينضم الي البث '),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'ٌقبول',
          onPressed: () {
            //Accept User in live
            acceptToLive();
          },
        ),
        closeIconColor: Colors.white,
        showCloseIcon: true,
        duration: Duration(seconds: 30),
      );
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(s)
          .closed
          .then((value) {
        // declinedToLive();
      });
    });
  }

  Widget TimerCounterDown() {
    return CircularCountDownTimer(
      duration: 30,
      initialDuration: 0,
      controller: CountDownController(),
      width: 30,
      height: 30,
      ringColor: Colors.grey[300]!,
      ringGradient: null,
      fillColor: Colors.blue,
      fillGradient: null,
      backgroundColor: Colors.black54,
      backgroundGradient: null,
      strokeWidth: 5.0,
      strokeCap: StrokeCap.round,
      textStyle: const TextStyle(
          fontSize: 10.0, color: Colors.white, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.S,
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: true,
      onStart: () {
        debugPrint('Countdown Started');
      },
      onComplete: () {
        debugPrint('Countdown Ended');
        // declined
        declinedToLive();
      },
      onChange: (String timeStamp) {
        debugPrint('Countdown Changed $timeStamp');
      },
      timeFormatterFunction: (defaultFormatterFunction, duration) {
        if (duration.inSeconds == 0) {
          return "0";
        } else {
          return Function.apply(defaultFormatterFunction, [duration]);
        }
      },
    );
  }

  Widget BOx() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('ViewInLive')
          .doc(textUuid)
          .collection(textUuid!)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(color: AppColors.mainColor);
        }
        var d = snapshot.data!.docs[0].get("view");
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Expanded(
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        d.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 150,
              child: Text(
                name,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.white, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    Delete();
    _engine.destroy();
    _engine.leaveChannel();
  }

  Widget _localVideo() {
    return _localUserJoined
        ? RtcLocalView.SurfaceView()
        : Center(
            child: Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(color: AppColors.mainColor)));
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: textUuid,
      );
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget StraemComments() {
    return Container(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('StreamLive')
            .doc(textUuid)
            .collection("LiveComments")
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messagesWidgets = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.mainColor),
            );
          }
          snapshot.data!.docs.reversed.forEach((message) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageImage = message.get('imageUrl');

            final messageWidget = MessageLine(
              text: messageText,
              sender: messageSender,
              imageUrl: messageImage,
            );
            messagesWidgets.add(messageWidget);
          });
          return messagesWidgets.isEmpty
              ? Center(
                  child: Text(
                    'هنا تظهر التعليقات',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView(
                  reverse: true,
                  padding: const EdgeInsets.all(20),
                  children: messagesWidgets,
                );
        },
      ),
    );
  }
}
