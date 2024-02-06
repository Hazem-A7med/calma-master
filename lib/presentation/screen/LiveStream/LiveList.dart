import '../../../core/utils/app_colors.dart';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:nadek/data/model/LiveListModel.dart';
import 'package:nadek/presentation/screen/LiveStream/ShowLive.dart';

import 'package:nadek/sheard/component/MessageLine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

final _firestore = FirebaseFirestore.instance;

class LiveList extends StatefulWidget {
  const LiveList({super.key});

  @override
  State<LiveList> createState() => _LiveListState();
}

class _LiveListState extends State<LiveList> with WidgetsBindingObserver {
  late String name;
  late String photo;
  late int v;
  late String id;
  String urlImage =
      'https://img.freepik.com/premium-photo/composition-various-sport-equipment-fitness-games_93675-82046.jpg';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    id = CacheHelper.getString('Id')!;
    name = CacheHelper.getString('username')!;
    photo = CacheHelper.getString('photo') ?? urlImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.back1,
      appBar: AppBar(
        backgroundColor: ColorApp.back1,
        toolbarHeight: 0,
        title: const Text('Live'),
      ),
      body: StraemComments(),
    );
  }

  Widget StraemComments() {
    return Container(
      height: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('StreamLive')
            .doc("Live")
            .collection("ChannelsId")
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          List<LiveListModel> list = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.mainColor),
            );
          }

          snapshot.data!.docs.reversed.forEach((message) {
            final channelsText = message.get('channels');
            final titleText = message.get('title');
            final imageUrl = message.get('imageUrl');

            final dataList = LiveListModel(
                channels: channelsText,
                title: titleText,
                imageUrl: imageUrl,
                view: "100");

            list.add(dataList);
          });
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 250,
            ),
            padding: const EdgeInsets.all(20),
            itemCount: list.length,
            itemBuilder: (c, index) {
              return StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('ViewInLive')
                    .doc(list[index].channels)
                    .collection(list[index].channels)
                    .snapshots(),
                builder: (context, snapshot) {
                  var d = snapshot.data!.docs[0].get("view");
                  return GestureDetector(
                    onTap: () {
                      AddView(list[index].channels);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowLive(
                                  title: list[index].title,
                                  sender: name,
                                  imageurl: photo,
                                  channelId: list[index].channels)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                list[index].imageUrl,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    urlImage,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                  );
                                },
                              ),
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.black26,
                              ),
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
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    list[index].title,
                                    style: const TextStyle(color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  ImageProvider<Object> getCharacterAvatar(String url) {
    final image = Image.network(
      url,
      errorBuilder: (context, object, trace) {
        return Image.network(urlImage);
      },
    ).image;
    return image;
  }

  void AddView(String UUId) {
    var c = FirebaseFirestore.instance
        .collection('ViewInLive')
        .doc(UUId)
        .collection(UUId);
    var shot = c.get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        int i = element.data()["view"] + 1;
        FirebaseFirestore.instance
            .collection('ViewInLive')
            .doc(UUId)
            .collection(UUId)
            .doc(element.id)
            .update({'view': i})
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      });
    });
  }
}
