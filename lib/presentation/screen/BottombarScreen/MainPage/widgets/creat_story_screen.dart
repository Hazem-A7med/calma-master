import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/logic/cubit/stories_cubit.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

import '../../../../../logic/cubit/creat_story_cubit.dart';
import '../../../../../logic/states/create_story_states.dart';
import '../../../../../sheard/constante/cache_hleper.dart';


class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({Key? key}) : super(key: key);

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  TextEditingController contentController =TextEditingController();

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
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<CreateStoryCubit>(context,
                                  listen: false).pickVideo();
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
                                          fontSize: 22)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                      'assets/icons/video.png', height: 30),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                            BlocProvider.of<CreateStoryCubit>(context,
                                listen: false).getImage();
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
                                          fontSize: 22)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                      'assets/icons/image.png', height: 30),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
