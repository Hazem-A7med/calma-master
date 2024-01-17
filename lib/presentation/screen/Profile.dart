import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/data/model/FollowedModel.dart';
import 'package:nadek/data/model/FollowersModel.dart';
import 'package:nadek/data/model/ProfileModel.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/sheard/ChangeInternet.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:video_player/video_player.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({Key? key}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileUser> {
  late String token;
  bool loading = true;
  ProfileModel? user;
  FollowedModel? followedModel;
  FollowersModel? followersModel;
  ScrollController? _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

    token = CacheHelper.getString('tokens')!;
    BlocProvider.of<NadekCubit>(context).GetFollowers(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مقاطع الفيديو الخاصة بي',
        ),
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        centerTitle: true,
      ),
      body: ChangeInternet(
        chanegedInternt: (status) {
          BlocProvider.of<NadekCubit>(context).GetFollowers(token: token);
        },
        child: BlocConsumer<NadekCubit, NadekState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is LoadedProfile) {
              setState(() {
                user = state.profileModel;
                loading = false;
              });
            }
            if (state is LoadedFollowed) {
              setState(() {
                followedModel = state.followedModel;

                BlocProvider.of<NadekCubit>(context).GetProfile(token: token);
              });
            }
            if (state is LoadedFollowers) {
              setState(() {
                followersModel = state.followersModel;
                BlocProvider.of<NadekCubit>(context).GetFollowed(token: token);
              });
            }
          },
          builder: (context, state) {
            return Container(
              color: ColorApp.black_400,
              height: double.infinity,
              width: double.infinity,
              child: loading
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: ColorApp.black_400,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 70,
                                      backgroundColor: ColorApp.black_400,
                                      backgroundImage: NetworkImage(
                                          user!.data!.myData!.photo.toString()),
                                    ),
                                    Text(
                                      ' ${user!.data!.myData!.name}',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${followedModel?.data?.length ?? 0}المتابَعون ',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${followersModel?.data?.length ?? 0}المتابِعين ',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'مقاطع الفيديو الخاصة بي',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          user!.data!.myVideos!.isEmpty
                              ? Container(
                                  child: Text(
                                    'لا توجد فيديوهات',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: user!.data!.myVideos!.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 2.0,
                                          mainAxisSpacing: 2.0,
                                          childAspectRatio: 0.6),
                                  itemBuilder: (itemBuilder, index) {
                                    return ItemVideoPlayer(
                                      videoUrl:
                                          user!.data!.myVideos![index].path,
                                      scrollController: _scrollController!,
                                      function: () {},
                                    );
                                  })
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class ItemVideoPlayer extends StatefulWidget {
  String? videoUrl;
  Function() function;
  ScrollController scrollController;

  ItemVideoPlayer(
      {Key? key,
      required this.videoUrl,
      required this.function,
      required this.scrollController})
      : super(key: key);

  @override
  State<ItemVideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<ItemVideoPlayer> {
  late VideoPlayerController _videoController;
  late String image;
  bool isShow = false;
  bool isShowPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.scrollController.addListener(() {
      _videoController.pause();
    });

    _videoController = VideoPlayerController.network(widget.videoUrl!)
      ..initialize().then((value) {
        setState(() {
          isShow = true;
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isShow
        ? InkWell(
            onTap: () {
              setState(() {
                _videoController.value.isPlaying
                    ? _videoController.pause()
                    : _videoController.play();
              });
            },
            child: Stack(
              children: [
                VideoPlayer(_videoController),
                Center(
                  child: isPlaying(),
                )
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          );
  }
}
