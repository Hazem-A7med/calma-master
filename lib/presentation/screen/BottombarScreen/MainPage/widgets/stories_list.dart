import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/data/model/all_stories_model.dart';
import 'package:nadek/logic/cubit/all_stories_cubit.dart';
import 'package:nadek/logic/cubit/stories_cubit.dart';
import 'package:nadek/logic/states/all_stories_states.dart';
import 'package:nadek/logic/states/my_stories_states.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/story.dart';

import '../../../../../data/model/my_stories_model.dart';
import '../../../../../sheard/constante/cache_hleper.dart';

class StoriesList extends StatefulWidget {
  const StoriesList({Key? key}) : super(key: key);

  @override
  State<StoriesList> createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  List<AllStoriesResponse> allStories = [];
  int length = 0;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        BlocProvider.of<StoriesCubit>(context, listen: false)
            .fetchMyStories(CacheHelper.getString('tokens')!);
        BlocProvider.of<AllStoriesCubit>(context, listen: false)
            .fetchAllStories(CacheHelper.getString('tokens')!);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: 115,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => (index == 0)
                /////////////////////////////////////////////////////////////////////////////////
                ? BlocBuilder<StoriesCubit, MyStoriesState>(
                    builder: (BuildContext context, state) {
                    if (state is MyStoriesLoadedState) {
                      List<Story> stories = state.stories;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StoryWidget(listOfStories: stories),
                              ));
                        },
                        child: SizedBox(
                          width: 82,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        boxShadow: List.filled(
                                            1,
                                            BoxShadow(
                                                color: Colors.white38
                                                    .withOpacity(.3),
                                                blurRadius: 3,
                                                spreadRadius: 1)),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          style: BorderStyle.values[1],
                                          color: const Color(0xffE11717),
                                          width: 5,
                                        ),
                                        color: Colors.white),
                                    height: 80,
                                    width: 80),
                                Positioned(
                                  bottom: -5,
                                  right: -5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () {
                                          // pickingNewImage=true;
                                          // pickAndStoreImage();
                                          // if(image!.path.isEmpty)pickingNewImage=false;
                                        },
                                      );
                                    },
                                    child: IconButton(
                                        iconSize: 30,
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.add_circle_sharp,
                                          color: Color(0xffE11717),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  })
                :
                ////////////////////////////////////////////////////////////////////////////////
                BlocBuilder<AllStoriesCubit, AllStoriesState>(
                    builder: (BuildContext context, state) {
                      if (state is AllStoriesLoadedState) {
                        allStories = state.stories;
                        setState(() {
                          length = allStories.length;
                        });
                        return SizedBox(
                          width: 82,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: List.filled(
                                            1,
                                            BoxShadow(
                                                color: Colors.white38
                                                    .withOpacity(.3),
                                                blurRadius: 3,
                                                spreadRadius: 1)),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xffE11717),
                                          width: 5,
                                        ),
                                        color: Colors.white),
                                    height: 80,
                                    width: 80),
                              ),
                              const Text(
                                'Ahmad Moe',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xffE11717), fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
            separatorBuilder: (context, index) => const SizedBox(
              width: 20,
            ),
            itemCount: 1+length,
          ),
        ),
      ),
    );
  }
}
