import '../../core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadek/data/model/ProfileModel.dart';
import 'package:nadek/data/model/ProfileOfUserModel.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/repprt_screen.dart';
import 'package:nadek/sheard/ChangeInternet.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ProfileOfUser extends StatefulWidget {
  int user_id;
  final bool myProfile;

  ProfileOfUser({
    Key? key,
    required this.user_id,
    required this.myProfile,
  }) : super(key: key);

  @override
  State<ProfileOfUser> createState() => _ProfileOfUserState();
}

class _ProfileOfUserState extends State<ProfileOfUser> {
  late String token;
  bool loading = true;
  ProfileModel? user;
  ScrollController? _scrollController;
  ProfileOfUserModel? model;
  String add = 'متابعة';
  final _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

    token = CacheHelper.getString('tokens')!;
    BlocProvider.of<NadekCubit>(context)
        .GetProfileOfUser(user_id: widget.user_id, token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
        ),
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        centerTitle: true,
      ),
      body: ChangeInternet(
        chanegedInternt: (status) {
          BlocProvider.of<NadekCubit>(context)
              .GetProfileOfUser(user_id: widget.user_id, token: token);
        },
        child: BlocConsumer<NadekCubit, NadekState>(
          listener: (context, state) {
            // TODO: implement listener

            if (state is LoadedAddFollow) {
              Fluttertoast.showToast(
                msg: '${state.data.msg}',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
              print('${state.data.msg}');
            }

            if (state is LoadedProfileOfUser) {
              setState(() {
                model = state.model;
                loading = false;
                model!.data!.myData!.user_follow == true
                    ? add = 'تم المتابعة'
                    : add = 'متابعة';
              });
            }

            if (state is UpdatePhoto) {
              BlocProvider.of<NadekCubit>(context)
                  .GetProfileOfUser(user_id: widget.user_id, token: token);
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
                      child: const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.mainColor),
                      ),
                    )
                  : SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CircleContainer(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'نوع الرياضة',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          model!.data!.sports!.isNotEmpty
                                              ? model!
                                                  .data!.sports!.first.title!
                                              : '',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: (() async {
                                        final image = await _picker.pickImage(
                                            source: ImageSource.gallery);

                                        if (image != null) {
                                          BlocProvider.of<NadekCubit>(context)
                                              .UpadtePhoto(
                                                  file: image.path,
                                                  token: token);
                                        }
                                      }),
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundColor: ColorApp.black_400,
                                        backgroundImage: NetworkImage(model!
                                            .data!.myData!.photo
                                            .toString()),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      ' ${model!.data!.myData!.name}',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${model!.data!.myFollows!.length ?? 0}المتابَعون ',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${model!.data!.myFollowers!.length ?? 0}المتابِعين ',
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                // const SizedBox(width: 10),
                                Expanded(
                                  child: CircleContainer(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'نوع اللاعب',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        model!.data!.myData!.player_type ?? '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                ),
                              ],
                            ),
                          ),
                          if (model!.data!.myData!.id != widget.user_id)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorApp.darkRead),
                                  child: GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                        msg: 'قريبا ان شاء الله',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    },
                                    child: const Center(
                                      child: Text(
                                        'ارسال رسالة',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 140,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorApp.back1),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        add == 'متابعة'
                                            ? add = 'تم المتابعة'
                                            : add = 'متابعة';
                                      });
                                      BlocProvider.of<NadekCubit>(context)
                                          .AddFollow(
                                              token: token,
                                              uid: model!.data!.myData!.id!
                                                  .toInt());

                                      print(model!.data!.myData!.facebook);
                                    },
                                    child: Center(
                                      child: Text(
                                        add,
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (model!.data!.myData!.id != widget.user_id)
                            const SizedBox(
                              height: 10,
                            ),
                          if (widget.myProfile) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorApp.darkRead),
                                  child: GestureDetector(
                                    onTap: () async {
                                      BlocProvider.of<NadekCubit>(context)
                                          .logout(token: token);
                                      CacheHelper.clear();
                                      await Phoenix.rebirth(context);
                                    },
                                    child: const Center(
                                      child: Text(
                                        'تسجيل خروج',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 140,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorApp.darkRead,
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      BlocProvider.of<NadekCubit>(context)
                                          .deleteAccount(
                                        token: token,
                                        id: widget.user_id,
                                      );
                                      CacheHelper.clear();
                                      await Phoenix.rebirth(context);
                                    },
                                    child: const Center(
                                      child: Text(
                                        'حذف الحساب',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (model!.data!.myData!.youtube != null)
                                SocialMediaButton(
                                  onTap: () {
                                    Uri url = Uri.parse(model!
                                        .data!.myData!.youtube
                                        .toString());
                                    _launchUrl(url);
                                  },
                                  assetImagePath:
                                      'assets/icons/socialmedia/youtube.png',
                                ),
                              if (model!.data!.myData!.instagram != null)
                                SocialMediaButton(
                                  onTap: () {
                                    Uri url = Uri.parse(model!
                                        .data!.myData!.instagram
                                        .toString());
                                    _launchUrl(url);
                                  },
                                  assetImagePath:
                                      'assets/icons/socialmedia/instagram.png',
                                ),
                              if (model!.data!.myData!.facebook != null)
                                SocialMediaButton(
                                  onTap: () {
                                    Uri url = Uri.parse(model!
                                        .data!.myData!.facebook
                                        .toString());
                                    _launchUrl(url);
                                  },
                                  assetImagePath:
                                      'assets/icons/socialmedia/facebook.png',
                                ),
                              if (model!.data!.myData!.twitter != null)
                                SocialMediaButton(
                                  onTap: () {
                                    Uri url = Uri.parse(model!
                                        .data!.myData!.twitter
                                        .toString());
                                    _launchUrl(url);
                                  },
                                  assetImagePath:
                                      'assets/icons/socialmedia/twitter.png',
                                ),
                              if (model!.data!.myData!.snapchat != null)
                                SocialMediaButton(
                                  onTap: () {
                                    Uri url = Uri.parse(model!
                                        .data!.myData!.snapchat
                                        .toString());
                                    _launchUrl(url);
                                  },
                                  assetImagePath:
                                      'assets/icons/socialmedia/snapchat.png',
                                ),
                              if (model!.data!.myData!.telegram != null)
                                SocialMediaButton(
                                  onTap: () {
                                    Uri url = Uri.parse(model!
                                        .data!.myData!.telegram
                                        .toString());
                                    _launchUrl(url);
                                  },
                                  assetImagePath:
                                      'assets/icons/socialmedia/telegram.png',
                                ),
                              if (model!.data!.myData!.whatsapp != null)
                                SocialMediaButton(
                                  onTap: () {
                                    Uri url = Uri.parse(model!
                                        .data!.myData!.whatsapp
                                        .toString());
                                    _launchUrl(url);
                                  },
                                  assetImagePath:
                                      'assets/icons/socialmedia/whatsapp.png',
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // hidden by mostafa
                          if (!widget.myProfile) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorApp.back1),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                        msg: 'تم حظر المستخدم',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    },
                                    child: const Center(
                                      child: Text(
                                        'حظر المستخدم',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorApp.back1),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  repprt_screen(
                                                      title:
                                                          'ابلاغ عن مستخدم')));
                                    },
                                    child: const Center(
                                      child: Text(
                                        'ابلاغ',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                          const Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'مقاطع الفيديو الخاصة بي',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          model!.data!.myVideos!.isEmpty
                              ? Container(
                                  child: const Text(
                                    'لا توجد فيديوهات',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: model!.data!.myVideos!.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 2.0,
                                          mainAxisSpacing: 2.0,
                                          childAspectRatio: 0.6),
                                  itemBuilder: (itemBuilder, index) {
                                    return ItemVideoPlayer(
                                      videoUrl:
                                          model!.data!.myVideos![index].path,
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

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CircleContainer extends StatelessWidget {
  const CircleContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 96,
        height: 96,
        decoration: const BoxDecoration(
            color: ColorApp.darkRead, shape: BoxShape.circle),
        child: child,
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
        : const Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
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

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton(
      {super.key, required this.onTap, required this.assetImagePath});

  final void Function() onTap;
  final String assetImagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: ColorApp.back1),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Image(
            height: 35,
            width: 35,
            image: AssetImage(assetImagePath),
          ),
        ),
      ),
    );
  }
}
