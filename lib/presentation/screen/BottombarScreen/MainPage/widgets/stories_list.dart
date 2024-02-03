import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/data/model/all_stories_model.dart';
import 'package:nadek/logic/cubit/all_stories_cubit.dart';
import 'package:nadek/logic/cubit/stories_cubit.dart';
import 'package:nadek/logic/states/all_stories_states.dart';
import 'package:nadek/logic/states/my_stories_states.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/all_stories_view_widget.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/my_story_view_widget.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/story_item.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/story_shimmer.dart';

import '../../../../../data/model/my_stories_model.dart';
import '../../../../../sheard/constante/cache_hleper.dart';

class StoriesList extends StatefulWidget {
  const StoriesList({Key? key}) : super(key: key);

  @override
  State<StoriesList> createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  List<AllStoriesResponse> allStories = [];
  int length = 1;
  List<Story> myStories = [];

  void updateLength() {
    setState(() {
      length = 1 + allStories.length;
      print(
          '###########################################################$length');
    });
  }

  Future<void> fetchData() async {
    BlocProvider.of<StoriesCubit>(context, listen: false)
        .fetchMyStories(CacheHelper.getString('tokens')!);
    BlocProvider.of<AllStoriesCubit>(context, listen: false)
        .fetchAllStories(CacheHelper.getString('tokens')!);

    // Set state after fetching data
    setState(() {
      myStories = BlocProvider.of<StoriesCubit>(context)
          .myStories; // Update with your actual state access
      allStories = BlocProvider.of<AllStoriesCubit>(context)
          .allStories; // Update with your actual state access
      length = 1 + allStories.length;
    });
  }

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

    // fetchData();
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
          child: BlocConsumer<AllStoriesCubit, AllStoriesState>(
              listener: (context, state) {
            if (state is AllStoriesLoadedState) {
              setState(() {
                allStories = state.allStories;
                updateLength();
              });
              print('allStoriesState is $state');
            }
            print('allStoriesState is $state');
          }, builder: (BuildContext context, allStoriesState) {
            if (allStoriesState is AllStoriesLoadedState) {
              return BlocConsumer<StoriesCubit, MyStoriesState>(
                listener: (context, state) {
                  if (state is MyStoriesLoadedState) {
                    setState(() {
                      myStories = state.stories;
                      updateLength();
                    });
                    print('myStoriesState is $state');
                  }
                  print('myStoriesState is $state');
                },
                builder: (BuildContext context, myStoriesState) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return (index == 0)
                          ?
                          /////////////////////////////////////////////////////////////////////////////////
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyStoryViewWidget(
                                          listOfStories: myStories),
                                    ));
                              },
                              child: SizedBox(
                                width: 82,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor:
                                              const Color(0xffE11717),
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 35,
                                              backgroundImage: NetworkImage(
                                                  CacheHelper.getString('photo')
                                                      .toString()
                                                      .replaceAll('\'', '')),
                                            ),
                                          ),
                                        ),
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
                              ),
                            )

                          ////////////////////////////////////////////////////////////////////////////////
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllStoryViewWidget(
                                          listOfStories:
                                              allStories[index - 1].story!),
                                    ));
                              },
                              child: StoryItem(
                                name: allStories[index - 1].user?.name ?? '',
                                image: allStories[index - 1].user?.photo ?? '',
                              ),
                            );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                    itemCount: length,
                  );
                },
              );
            }
            else if(allStoriesState is AllStoriesLoadingState){return StoryShimmer();}else {return Container();}
          }),
        ),
      ),
    );
  }
}
