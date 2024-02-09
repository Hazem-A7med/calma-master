import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/logic/cubit/creat_post_cubit.dart';
import 'package:nadek/logic/states/create_post_states.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/video_player.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:video_player/video_player.dart';

import '../../../../logic/cubit/my_posts_cubit.dart';
import '../../../../sheard/constante/cache_hleper.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController contentController = TextEditingController();

  XFile? photo;
  XFile? video;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create Post',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                BlocProvider.of<CreatePostCubit>(context, listen: false)
                    .createPost(CacheHelper.getString('tokens')!,
                        contentController.text);
                BlocProvider.of<MyPostsCubit>(context, listen: false)
                    .fetchMyPosts(CacheHelper.getString('tokens')!);
                Navigator.pop(context);
              },
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
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
                  controller: contentController,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await BlocProvider.of<CreatePostCubit>(context,
                                  listen: false)
                              .pickVideo();
                          setState(() {
                            video = BlocProvider.of<CreatePostCubit>(context,
                                    listen: false)
                                .video;
                            if (video != null) photo = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: [
                              Text('فيديو',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.7),
                                      fontSize: 16)),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset('assets/icons/video.png', height: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await BlocProvider.of<CreatePostCubit>(context,
                                  listen: false)
                              .getImage();
                          setState(() {
                            photo = BlocProvider.of<CreatePostCubit>(context,
                                    listen: false)
                                .photo;
                            if (photo != null) video = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: [
                              Text('صورة',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.7),
                                      fontSize: 16)),
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset('assets/icons/image.png', height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60,),
                (photo != null)
                    ? Image.file(File(photo!.path))
                    : (video != null)
                        ? VideoPlayerWidget(videoFile: File(video!.path))
                        : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
