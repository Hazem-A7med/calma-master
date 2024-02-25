import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/creat_post_screen.dart';

import '../../../../../sheard/constante/cache_hleper.dart';
import '../../../CreateTournament.dart';
import '../../../virtualTournments/virtual_tournments_list.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: SizedBox(
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostScreen(),
                        )),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                          hintTextDirection: TextDirection.rtl,
                          hintText:
                              'ما الذي يدور في ذهنك,${CacheHelper.getString('username')} ؟',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(.4))),
                    ),
                  ),
                  Container(height: 1, color: Colors.white.withOpacity(.4))
                ],
              )),
              const SizedBox(
                width: 20,
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  CacheHelper.getString('photo')
                      .toString()
                      .replaceAll('\'', ''),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 15.0, left: 17, right: 17, top: 25),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePostScreen(),
                      )),
                    child: Row(
                      children: [
                        Text('المشاعر/الأنشطة',
                            style: TextStyle(
                                color: Colors.white.withOpacity(.3),
                                fontSize:
                                    MediaQuery.of(context).size.width * .025)),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset('assets/icons/smile.png', height: 20),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostScreen(),
                        )),
                    child: Row(
                      children: [
                        Text('صورة / فيديو',
                            style: TextStyle(
                                color: Colors.white.withOpacity(.3),
                                fontSize:
                                    MediaQuery.of(context).size.width * .025)),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset('assets/icons/image.png', height: 20),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTournament(),
                          ));
                    },
                    child: Row(
                      children: [
                        Text('بث مباشر',
                            style: TextStyle(
                                color: Colors.white.withOpacity(.3),
                                fontSize:
                                    MediaQuery.of(context).size.width * .025)),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset('assets/icons/live.png', height: 17),
                      ],
                    ),
                  ),
                ]),
          ),
          Container(
              width: double.infinity,
              height: 1,
              color: Colors.white.withOpacity(.4))
        ]),
      ),
    );
  }
}
