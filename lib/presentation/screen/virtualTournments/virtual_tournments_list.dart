import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nadek/presentation/screen/virtualTournments/live_page.dart';
import 'package:nadek/presentation/screen/virtualTournments/virtual_methods.dart';
import 'package:nadek/sheard/component/column_social_icon.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/constante/string.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:share_plus/share_plus.dart';

class VirtualTournmentsList extends StatelessWidget {
  VirtualTournmentsList({super.key});
  final _channelNameController = TextEditingController(text: '');
  final token = CacheHelper.getString('tokens');
  final userId = CacheHelper.getString('Id');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        title: const Text(
          'البطولات الافتراضية',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("livestream")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const SizedBox();
                    }

                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    final data = (snapshot.requireData)
                        as QuerySnapshot<Map<String, dynamic>>;

                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              getIcons(
                                'assets/icons/ic_share.png',
                                'مشاركة',
                                25.0,
                                () {
                                  var channeName = stringToBase64
                                      .decode(data.docs.elementAt(index).id);
                                  Share.share(
                                      'شاهد البث المباشر لبطولة $channeName \n ${string_app.nadekplayStore}');
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Component_App.ButtonStyle(
                                    function: () async {
                                      final doc = await FirebaseFirestore
                                          .instance
                                          .collection('livestream')
                                          .doc(data.docs[index].id)
                                          .get();

                                      if (doc['Owner'] == userId) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LivePage(doc.id, true, true),
                                            ));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LivePage(
                                                  doc.id, false, false),
                                            ));
                                      }
                                    },
                                    text: stringToBase64
                                        .decode(data.docs[index].id),
                                    color: ColorApp.darkRead),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
