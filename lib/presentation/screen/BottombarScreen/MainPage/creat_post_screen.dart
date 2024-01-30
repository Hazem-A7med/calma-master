import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

import '../../../../sheard/constante/cache_hleper.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          MaterialButton(
            onPressed: () {},
            child: const Text(
              'Post',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.scaffold,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                          radius: 23,
                          backgroundImage: NetworkImage(
                              CacheHelper.getString('photo')
                                  .toString()
                                  .replaceAll('\'', ''))),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        CacheHelper.getString('username') ?? '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              TextField(
                cursorColor: ColorApp.darkRead,
                style: TextStyle(
                    fontSize: 18, color: Colors.white.withOpacity(.6)),
                textDirection: TextDirection.rtl,
                maxLines: null,
                decoration: InputDecoration(
                    hintText:
                        'ما الذي يدور في ذهنك,${CacheHelper.getString('username')} ؟',
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(.3),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      children: [
                        Text('صورة / فيديو',
                            style: TextStyle(
                                color: Colors.white.withOpacity(.7),
                                fontSize: 22)),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset('assets/icons/image.png', height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
