import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late NadekCubit nadekCubit;

  @override
  void initState() {
    nadekCubit = NadekCubit.get(context);
    super.initState();
    token = CacheHelper.getString('tokens')!;
    nadekCubit.GetFollowers(token: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     width: double.infinity,
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.centerRight,
      //         end: Alignment.centerLeft,
      //         stops: [0.0, 100.0],
      //         colors: [
      //           ColorApp.blue,
      //           ColorApp.move,
      //         ],
      //       ),
      //     ),
      //   ),
      //   centerTitle: true,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.settings),
      //     onPressed: () {
      //       Navigator.pushNamed(context, '/Update_Account');
      //     },
      //   ),
      // ),
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
                    child: CircularProgressIndicator(),
                  ),
                )
              : CustomScrollView(
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
                          backgroundColor: Color(0xffE11717),
                          child: Padding(
                            padding: EdgeInsets.all(1.0),
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
                              child: Image.asset(
                                  'assets/images/page_1.png',
                                  width: double.infinity,
                                  fit: BoxFit.cover),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profileModel!.data!.myData!.name!,
                                    style: TextStyle(color: Colors.white),
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
                          return const PostItem();
                        },
                        childCount: 20,
                      ),
                    ),
                  ],
                );
          // Container(
          //         width: double.infinity,
          //         height: double.infinity,
          //         color: AppColors.scaffold,
          //         child: SingleChildScrollView(
          //           child: Column(
          //             children: [
          //               Stack(
          //                 children: [
          //                   Container(
          //                     height: 100,
          //                     width: double.infinity,
          //                     decoration: const BoxDecoration(
          //                       gradient: LinearGradient(
          //                         begin: Alignment.centerRight,
          //                         end: Alignment.centerLeft,
          //                         stops: [0.0, 100.0],
          //                         colors: [
          //                           ColorApp.blue,
          //                           ColorApp.move,
          //                         ],
          //                       ),
          //                     ),
          //                     child: const Center(
          //                       child: Padding(
          //                         padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
          //                         child: Row(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [],
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          //                     child: Center(
          //                       child: CircleAvatar(
          //                         radius: 60,
          //                         backgroundColor: ColorApp.black_400,
          //                         backgroundImage: NetworkImage(profileModel!
          //                             .data!.myData!.photo
          //                             .toString()),
          //                       ),
          //                     ),
          //                   )
          //                 ],
          //               ),
          //               Text(
          //                 '${profileModel!.data!.myData!.name}',
          //                 style: const TextStyle(
          //                     fontSize: 20, color: Colors.white),
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   profileModel!.data!.myData!.youtube != null
          //                       ? GestureDetector(
          //                           onTap: () {
          //                             Uri url = Uri.parse(profileModel!
          //                                 .data!.myData!.youtube
          //                                 .toString());
          //                             _launchUrl(url);
          //                           },
          //                           child: const Image(
          //                             height: 35,
          //                             width: 35,
          //                             image: AssetImage(
          //                                 'assets/icons/ic_youtube.png'),
          //                           ),
          //                         )
          //                       : const SizedBox(),
          //                   const SizedBox(
          //                     width: 5,
          //                   ),
          //                   profileModel!.data!.myData!.instagram != null
          //                       ? GestureDetector(
          //                           onTap: () {
          //                             Uri url = Uri.parse(profileModel!
          //                                 .data!.myData!.instagram
          //                                 .toString());
          //                             _launchUrl(url);
          //                           },
          //                           child: const Image(
          //                             height: 35,
          //                             width: 35,
          //                             image: AssetImage(
          //                                 'assets/icons/ic_insta.png'),
          //                           ),
          //                         )
          //                       : const SizedBox(),
          //                 ],
          //               ),
          //               Text(
          //                 '${followersModel!.data!.length}  المتابِعين   ',
          //                 style: const TextStyle(
          //                     fontSize: 16, color: Colors.white),
          //               ),
          //               Component_App.Item_account(
          //                   function: () {
          //                     Navigator.pushNamed(context, '/Profile');
          //                   },
          //                   file: 'assets/icons/ic_myvideo.png',
          //                   title: 'فيديوهاتي'),
          //               Component_App.Item_account(
          //                   function: () {
          //                     Navigator.pushNamed(context, '/Update_Account');
          //                   },
          //                   file: 'assets/icons/ic_settings.png',
          //                   title: 'تعديل الحساب'),
          //               Component_App.Item_account(
          //                   function: () {
          //                     Navigator.pushNamed(
          //                         context, '/termsAndConditions');
          //                   },
          //                   file: 'assets/icons/ic_prv.png',
          //                   title: 'شروط الاستخدام '),
          //               Component_App.Item_account(
          //                   function: () {
          //                     Navigator.pushNamed(context, '/privacy_policy');
          //                   },
          //                   file: 'assets/icons/ic_lock.png',
          //                   title: 'سياسة الخصوصية '),
          //               Component_App.Item_account(
          //                 function: () {
          //                   SharedPreferences.getInstance().then((value) {
          //                     value.remove('token');
          //                   });
          //                   CacheHelper.Remove('tokens');
          //                   CacheHelper.Remove('isFirstOpen');
          //                   Navigator.popAndPushNamed(context, '/login_user');
          //                 },
          //                 file: 'assets/icons/ic_logout.png',
          //                 title: 'تسجيل الخروج',
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
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
