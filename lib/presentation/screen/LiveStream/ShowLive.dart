
import 'dart:ffi';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nadek/sheard/component/MessageLine.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/constante/string.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:permission_handler/permission_handler.dart';
final _firestore = FirebaseFirestore.instance;

class ShowLive extends StatefulWidget {

  String sender;
  String imageurl;
  String channelId;
  String title;

  ShowLive({super.key,required this.sender,required this.imageurl,required this.channelId,required this.title});



  @override
  State<ShowLive> createState() => _ShowLiveState();
}

class _ShowLiveState extends State<ShowLive> with WidgetsBindingObserver {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  String? messageText;
  TextEditingController messageTextController=TextEditingController();
  late String id;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    id= CacheHelper.getString('Id')!;
    initAgora();
    _firestore.collection('StreamLive').doc(widget.channelId).collection("LiveComments")
        .add({
      'text' : ' الي البث ${ widget.sender } لقد انضم ',
      'sender' :widget.sender ,
      'imageUrl':widget.imageurl,
      'time' : FieldValue.serverTimestamp(),
    });

  }
  void UserIsNotView(String UUId){
    var c=  FirebaseFirestore.instance.collection('ViewInLive').doc(UUId).collection(UUId);
    var shot =c.get().then((value){
      value.docs.forEach((element) {
        if(element.data()["view"] != 0){
          print(element.data());
          int i =element.data()["view"]-1;
          FirebaseFirestore.instance.collection('ViewInLive').doc(UUId).collection(UUId).doc(element.id).update({'view':i})
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));
        }



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
    await _engine.setClientRole(ClientRole.Audience);

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

    await _engine.joinChannel(null, widget.channelId, null, 0);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.back1,
      appBar: AppBar(
        backgroundColor:ColorApp.back1 ,
        toolbarHeight: 0,
        title: const Text('Live'),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('UserToLive').doc(widget.channelId).collection(widget.channelId).snapshots(),
        builder: (context, snapshot) {


          if(!snapshot.hasData){
            return const CircularProgressIndicator();
          }
          bool declinedToLive =snapshot.data!.docs[0].get('declinedToLive');
          int  userId         =snapshot.data!.docs[0].get('userId');
          bool addUser        =snapshot.data!.docs[0].get('addUser');
          int  total          =snapshot.data!.docs[0].get('total');
          //declinedToLive
          if(declinedToLive &&userId== int.parse(id)){
            funDeclinedToLive();
          }

          //acceptToLive
          if(addUser &&total ==1 &&userId== int.parse(id)){
            addUidForLive(_remoteUid!);
            acceptToLive();


          }

          return StreamBuilder<QuerySnapshot>(
            stream:  _firestore.collection('StreamLive').doc("Uid").collection(widget.channelId).snapshots(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        height: 350,
                        width: double.infinity,
                        child:Stack(
                          children: [

                            addUser&&userId== int.parse(id) ?Row(
                              children: [
                                Expanded(
                                  child: _remoteVideo(),
                                ),
                                Expanded(
                                    child:_localVideo()
                                ),
                              ],
                            ):total==1&&userId!= int.parse(id)? Row(
                              children: [
                                Expanded(
                                  child: RtcRemoteView.SurfaceView(
                                    uid: snapshot.data!.docs[0].get('Uid'),
                                    channelId: widget.channelId,
                                  ),
                                ),
                                Expanded(
                                    child:RtcRemoteView.SurfaceView(
                                      uid:snapshot.data!.docs[1].get('Uid'),
                                      channelId: widget.channelId,
                                    )
                                ),
                              ],
                            ):_remoteVideo(),
                            Container(
                              height: 50,
                              width: double.infinity,
                              color: Colors.black54,
                              child: BOx(),
                            )
                          ],
                        )
                    ),
                    const SizedBox(height: 10,),
                    Container(
                        height: 350,
                        width: 330,
                        decoration: BoxDecoration(
                            color: ColorApp.black_400,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: StraemComments(),
                              flex: 3,
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: inputText(
                                      controller: messageTextController,
                                      hint: 'اضافة تعليق',
                                      textInputType: TextInputType.multiline,
                                      function: (){
                                        _firestore.collection('StreamLive').doc(widget.channelId).collection("LiveComments")
                                            .add({
                                          'text' : messageText,
                                          'sender' :widget.sender ,
                                          'imageUrl':widget.imageurl,
                                          'time' : FieldValue.serverTimestamp(),
                                        });
                                        messageTextController.clear();
                                      }
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                    ),

                  ],
                ),
              );
            }
          );
        }
      )
    );
  }
  Widget BOx(){

    return  StreamBuilder<QuerySnapshot>(
      stream:_firestore.collection('ViewInLive').doc(widget.channelId).collection(widget.channelId).snapshots() ,
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return const CircularProgressIndicator();
        }
        var d =snapshot.data!.docs[0].get("view");
        return  Row(
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
                        style: const TextStyle(
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width:150,
              child: Text(
                widget.title,
                maxLines: 1,
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.white,overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    deleteUidForLive();
     UserIsNotView(widget.channelId);
    _engine.destroy();
    _engine.leaveChannel();

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

  }
  Widget _localVideo(){
    return  _localUserJoined
        ? const RtcLocalView.SurfaceView()
        : Center(child: Container(height:30,width:30,child: const CircularProgressIndicator()));
  }
  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: widget.channelId,
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  void sendAddToLive(){
    var c=  FirebaseFirestore.instance.collection('UserToLive').doc(widget.channelId).collection(widget.channelId);
    var shot =c.get().then((value){
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('UserToLive').doc(widget.channelId).collection(widget.channelId).doc(element.id).update({
          'msgAdd':true,
          'name':widget.sender,
          'userId':int.parse(id),
        }).then((value) => print("User Updated")).catchError((error) => print("Failed to update user: $error"));


      });
    });

  }
  void addUidForLive(int uId){
    _firestore.collection('StreamLive').doc("Uid").collection(widget.channelId).add({
      'channels' : widget.channelId,
      'Uid' : uId,
      'time' : FieldValue.serverTimestamp(),
    });
  }
  void deleteUidForLive(){
    _firestore.collection('StreamLive').doc("Uid").collection(widget.channelId).get().then((value) {
      value.docs.forEach((element) {
        if(element.data()['Uid'] == _remoteUid){

          FirebaseFirestore.instance.collection('StreamLive').doc("Uid").collection(widget.channelId).doc(element.id).delete();

        }

      });
    });
  }
  void funDeclinedToLive(){
    Fluttertoast.showToast(msg: 'تم رفض طلب الانضمام', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM,);

    var c=  FirebaseFirestore.instance.collection('UserToLive').doc(widget.channelId).collection(widget.channelId);

    var shot =c.get().then((value){
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('UserToLive').doc(widget.channelId).collection(widget.channelId).doc(element.id).update({
          'declinedToLive':false,
          'userId':-1,
        }).then((value) => print("User Updated")).catchError((error) => print("Failed to update user: $error"));


      });
    });

  }
  void acceptToLive(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await _engine.setClientRole(ClientRole.Broadcaster);

    });
  }
  void finishLiveFromMe(){
    var c=  FirebaseFirestore.instance.collection('UserToLive').doc(widget.channelId).collection(widget.channelId!);
    var shot =c.get().then((value){
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection('UserToLive').doc(widget.channelId).collection(widget.channelId!).doc(element.id).update({
          'addUser' : false,
          'msgAdd'  :false,
          'total'   :0,
          'name': 'non',
          'declinedToLive':false,
          'userId':-1,
        }).then((value) => print("User Updated")).catchError((error) => print("Failed to update user: $error"));


      });
    });

  }

  Widget StraemComments(){
    return Container(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream:  _firestore.collection('StreamLive').doc(widget.channelId).collection("LiveComments").orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messagesWidgets = [];
          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );

          }
          snapshot.data!.docs.reversed.forEach((message) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageImage =message.get('imageUrl');

            final messageWidget = MessageLine(
              text: messageText,
              sender: messageSender,
              imageUrl: messageImage,
            );
            messagesWidgets.add(messageWidget);
          });
          return ListView(
            reverse: true,
            padding: const EdgeInsets.all(20),
            children: messagesWidgets,
          );

        },
      ),
    );
  }
  Widget inputText({int? index,
    required TextEditingController controller,
    required String hint,
    required TextInputType textInputType,
    required Function function,
    IconData? icon}){
    return Container(
        width: double.infinity,
        child:  TextFormField(
          controller: controller,
          onChanged: (value){
            messageText=value;
          },

          textAlign: TextAlign.right,
          keyboardType: textInputType,
          maxLines: null,
          style: const TextStyle(
              color: Colors.black
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(31),
                  borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none
                  )
              ),
              suffixIcon:IconButton(
                onPressed:(){
                  if(!messageTextController.text.isEmpty){
                    _firestore.collection('StreamLive').doc(widget.channelId).collection("LiveComments")
                        .add({
                      'text' : messageText,
                      'sender' :widget.sender ,
                      'imageUrl':widget.imageurl,
                      'time' : FieldValue.serverTimestamp(),
                    });
                    messageTextController.clear();
                  }

                },
                icon: const Icon(Icons.send,color: Colors.blue,),
              ),
              icon:Icon(
                icon,
                color: Colors.blue,
              ),
              hintText: hint,
              hintStyle:const TextStyle(
                  color: Colors.black
              )

          ),
        )
    );
  }
}