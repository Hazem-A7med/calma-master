import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/logic/cubit/stories_cubit.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/video_player.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

import '../../../../logic/cubit/creat_story_cubit.dart';
import '../../../../logic/states/create_story_states.dart';
import '../../../../sheard/constante/cache_hleper.dart';


class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  TextEditingController contentController =TextEditingController();
XFile? video;
XFile? photo;
  @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStoryCubit, CreateStoryState>(
      builder: (context, state) =>
          Scaffold(
            appBar: AppBar(
              title: const Text(
                'Create Story',
                style: TextStyle(fontSize: 18),
              ),
              backgroundColor: Colors.transparent,
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    BlocProvider.of<CreateStoryCubit>(context, listen: false)
                        .createStory(CacheHelper.getString('tokens')!, contentController.text);
                    BlocProvider.of<StoriesCubit>(context,listen: false).fetchMyStories(CacheHelper.getString('tokens')!);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Create Story',
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
                    TextField(
                      cursorColor: ColorApp.darkRead,
                      style: TextStyle(
                          fontSize: 18, color: Colors.white.withOpacity(.6)),
                      textDirection: TextDirection.rtl,controller: contentController,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText:
                          'اكتب في قصتك ,${CacheHelper.getString(
                              'username')} ؟',
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
                              await BlocProvider.of<CreateStoryCubit>(context,
                                  listen: false)
                                  .pickVideo();
                              setState(() {
                                video = BlocProvider.of<CreateStoryCubit>(context,
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
                              await BlocProvider.of<CreateStoryCubit>(context,
                                  listen: false)
                                  .getImage();
                              setState(() {
                                photo = BlocProvider.of<CreateStoryCubit>(context,
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
