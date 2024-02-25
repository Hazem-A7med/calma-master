import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/data/model/FollowersModel.dart';
import 'package:nadek/data/model/ProfileModel.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/create_post_widget.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/post_item.dart';
import 'package:nadek/presentation/screen/BottombarScreen/profile_page/widgets/first_icons_row.dart';
import 'package:nadek/presentation/screen/BottombarScreen/profile_page/widgets/sec_icons_row.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/model/my_posts_model.dart';
import '../../../../logic/cubit/my_posts_cubit.dart';
import '../../../../logic/cubit/post_edit_cubit.dart';
import '../../../../logic/states/my_posts_states.dart';
import '../MainPage/widgets/post_shimmer.dart';

class profile_page extends StatefulWidget {
  const profile_page({Key? key}) : super(key: key);

  @override
  State<profile_page> createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {
  late String token;

  FollowersModel? followersModel;
  ProfileModel? profileModel;
  bool loading = true;
  Timer? timer;
  bool liked=false;
  late NadekCubit nadekCubit;


  void playLikeSound() async {
    final cache = AudioPlayer();
    await cache.play(AssetSource('sound/click.mp3'), volume: .1);
  }
  @override
  void initState() {
    nadekCubit = NadekCubit.get(context);
    super.initState();
    token = CacheHelper.getString('tokens')!;
    nadekCubit.GetFollowers(token: token);
    Future.delayed(
      Duration.zero,
      () async {
        BlocProvider.of<MyPostsCubit>(context, listen: false)
            .fetchMyPosts(CacheHelper.getString('tokens')!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: BlocConsumer<NadekCubit, NadekState>(
        listener: (context, state) {
          if (state is ChangeProfile) {
            nadekCubit.GetFollowers(token: token);
          }

          if (state is LoadedFollowers) {
            setState(() {
              followersModel = state.followersModel;
              BlocProvider.of<NadekCubit>(context).GetProfile(token: token);
            });
          }
          if (state is LoadedProfile) {
            setState(() {
              profileModel = state.profileModel;
              loading = false;
            });
          }
        },
        builder: (context, state) {
          return loading
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: AppColors.scaffold,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.mainColor),
                  ),
                )
              : RefreshIndicator( onRefresh: () async {
            BlocProvider.of<MyPostsCubit>(context, listen: false)
                .fetchMyPosts(CacheHelper.getString('tokens')!);

          },
                child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Colors.transparent,
                        expandedHeight: 260.0,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          centerTitle: true,
                          titlePadding: const EdgeInsets.only(bottom: 70),
                          title: CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color(0xffE11717),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    profileModel!.data!.myData!.photo.toString()),
                              ),
                            ),
                          ),
                          background: Container(
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Column(children: [
                              Expanded(
                                flex: 4,
                                child: Image.asset('assets/images/page_1.png',
                                    width: double.infinity, fit: BoxFit.cover),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      profileModel!.data!.myData!.name!,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Footballer',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.4)),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                'Choose your peace of mind, no matter the cost',
                                style:
                                    TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              FirstIconsRow(),
                              SecIconsRow(),
                              CreatePostWidget(),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return BlocBuilder<MyPostsCubit, MyPostsState>(
                                builder: (context, state) {
                              if (state is MyPostsLoadedState) {
                                List<MyPost> s = state.stories;
                                print(s.length);
                                return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => PostItem(onLike: () async {
                                      playLikeSound();
                                      setState(() {
                                        if (s[index]
                                            .isLiked ==
                                            true) {
                                          s[index]
                                              .isLiked = false;
                                          BlocProvider
                                              .of<
                                              PostEditCubit>(
                                              context,
                                              listen: false)
                                              .likePost(
                                              token: CacheHelper
                                                  .getString(
                                                  'tokens') ??
                                                  '',
                                              postId: s[index]
                                                  .id
                                                  .toString(),
                                              type: 'unlike');
                                        } else {
                                          s[index]
                                              .isLiked = true;
                                          BlocProvider
                                              .of<
                                              PostEditCubit>(
                                              context,
                                              listen: false)
                                              .likePost(
                                              token: CacheHelper
                                                  .getString(
                                                  'tokens') ??
                                                  '',
                                              postId: s[index]
                                                  .id
                                                  .toString(),
                                              type: 'like');
                                        }
                                      });
                                    },
                                          name: CacheHelper.getString('username'),
                                          image: CacheHelper.getString('photo')
                                              .toString()
                                              .replaceAll('\'', ''),
                                          mediaType: s[index].mediaType,
                                          mediaLink: s[index].mediaPath,likeCount: s[index].likesCount.toString(),
                                          description: s[index].content, liked: s[index].isLiked??false,
                                        ),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 10,
                                        ),
                                    itemCount: s.length);
                              } else if (state is MyPostsLoadingState) {
                                return const PostShimmer();
                              } else {
                                return const Center(
                                  child: Text('Failed to load posts !!'),
                                );
                              }
                            });
                          },
                          childCount: 1,
                        ),
                      ),
                    ],
                  ),
              );
        },
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
