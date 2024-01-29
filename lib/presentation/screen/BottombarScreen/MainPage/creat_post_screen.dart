import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        actions:  <Widget>[
          MaterialButton(onPressed: () {

          },child: Text('Post',style: TextStyle(fontSize: 18,color: Colors.white),),)
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
                          backgroundImage: NetworkImage(
                              CacheHelper.getString('photo')
                                  .toString()
                                  .replaceAll('\'', ''))),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        CacheHelper.getString('username') ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
