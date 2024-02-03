import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/data/model/BestUser.dart';
import 'package:nadek/data/model/all_posts_model.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/logic/cubit/my_posts_cubit.dart';
import 'package:nadek/logic/states/all_posts_states.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/create_post_widget.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/post_item.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/post_shimmer.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/stories_list.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/my_story_view_widget.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/switch_button.dart';
import 'package:nadek/presentation/screen/PlaygroundMaps.dart';
import 'package:nadek/presentation/screen/ProfileOfUser.dart';
import 'package:nadek/presentation/screen/ReservationScreen.dart';
import 'package:nadek/presentation/screen/SearchScreen.dart';
import 'package:nadek/presentation/screen/TypeSports.dart';
import 'package:nadek/presentation/screen/virtualTournments/virtual_tournments_list.dart';
import 'package:nadek/sheard/ChangeInternet.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Clubs/Clubs.dart';

import '../../../../logic/cubit/all_posts_cubit.dart';
import '../../../../logic/cubit/stories_cubit.dart';
import '../../Maps.dart';
import '../Champions/Champions.dart';
import '../Groups/Groups_Page.dart';
import '../Home_Page.dart';
import '../Make_Video_Page.dart';
import '../profile_page/Profile_Page.dart';
import '../Shopping/Shop_Page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool waiting = false;
  BestUser? bestUser;
  String? token;
  String? photo;
  String? name;
  String? id;

  int initialItem = 2;
  int currentScrollValue = 2;

  @override
  void initState() {
    token = CacheHelper.getString('tokens');
    // BlocProvider.of<NadekCubit>(context).GetBestUser(token: token!);
    _getLocation();
    photo = CacheHelper.getString('photo').toString().replaceAll('\'', '');
    photo = 'https://calmaapp.com/default.png';
    name = CacheHelper.getString('username');
    id = CacheHelper.getString('Id')!;
    initialItem = 2;
    print('tttttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
    print(token);
    print(token);
    print(token);
    print(token);

    Future.delayed(
      Duration.zero,
          () async {
        BlocProvider.of<AllPostsCubit>(context, listen: false)
            .fetchAllPosts(CacheHelper.getString('tokens')!);
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    super.didChangeDependencies();
  }

  GlobalKey<ScaffoldState> globalDrawer = GlobalKey();


  @override
  Widget build(BuildContext context) {

    final _advancedDrawerController = AdvancedDrawerController();
    return AdvancedDrawer(
      drawer: drawer(),
      backdropColor: AppColors.scaffold,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: true,
      openScale: .8,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        key: globalDrawer,
        backgroundColor: AppColors.scaffold,
        //endDrawer: drawer(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorApp.black_400,
          toolbarHeight: 0,
          centerTitle: true,
        ),
        body: ChangeInternet(
          chanegedInternt: (r) {
            BlocProvider.of<NadekCubit>(context).GetBestUser(token: token!);
          },
          child: BlocConsumer<NadekCubit, NadekState>(
            listener: (context, state) {
              if (state is OpenDrawer) {
                globalDrawer.currentState!.openEndDrawer();
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        ProfileOfUser(
                                            myProfile: true,
                                            user_id: int.parse(id!))));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                    backgroundImage: NetworkImage('$photo')),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '$name',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 170, child: SwitchButton()),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.menu,
                                size: 25,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                _advancedDrawerController.showDrawer();
                                // BlocProvider.of<NadekCubit>(context)
                                //     .openDrawers();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const StoriesList(),
                          const CreatePostWidget(),
                          BlocBuilder<AllPostsCubit, AllPostsState>(
                              builder: (context, state) {
                                if (state is AllPostsLoadedState) {
                                  List<AllPostsResponse>s = state.allPosts;
                                  return ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          PostItem(name: s[index].user?.name,
                                            image: s[index].user?.photo,
                                            description: s[index].allPost!.first.post,),
                                      separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      itemCount: s.length);
                                } else if (state is AllPostsLoadingState) {
                                  return const Center(
                                    child: PostShimmer(),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('Faild to load posts !!'),
                                  );
                                }
                              }),

                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }


  Widget drawer() {
    List<DrawerData> drawerData = [
      DrawerData(
        'الرئيسية',
            () {
          //Navigator.pop(context);
          Navigator.popAndPushNamed(context, '/MainPage');
        },
        Icon(Icons.home_filled, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'المجموعات',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const groups_page()));
        },
        Icon(Icons.group, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'انتاج فيديوهات',
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const make_video_page()));
        },
        Icon(Icons.video_collection_sharp, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'الحساب',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const profile_page()));
        },
        Icon(Icons.person, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'الفيديوهات',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const home_page()));
        },
        Icon(Icons.video_collection, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'صرح',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const Champions()));
        },
        Icon(Icons.diamond, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'الملاعب',
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const ReservationScreen()));
        },
        Icon(Icons.map, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'البحث',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const SearchScreen()));
        },
        Icon(Icons.search, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'أنواع الرياضات',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const TypeSports()));
        },
        Icon(Icons.format_list_bulleted_rounded,
            color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'خريطة اللاعبين',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const Maps()));
        },
        Icon(Icons.queue_play_next_rounded,
            color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'بث مباشر',
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => VirtualTournmentsList()));
        },
        Icon(Icons.live_tv, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'خريطة الملاعب',
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const PlaygroundMaps()));
        },
        Icon(Icons.map_outlined, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'البطولات',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const Clubs()));
        },
        Icon(Icons.people_alt_outlined, color: Colors.white.withOpacity(.4)),
      ),
      DrawerData(
        'المتجر',
            () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const shop_page()));
        },
        Icon(Icons.shopping_cart, color: Colors.white.withOpacity(.4)),
      ),
    ];
    return Drawer(
        backgroundColor: AppColors.scaffold,
        child: Column(
          children: [
            const SizedBox(height: 90),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            ProfileOfUser(
                                myProfile: true, user_id: int.parse(id!))));
              },
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(backgroundImage: NetworkImage('$photo')),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$name',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                itemBuilder: (context, index) =>
                    GestureDetector(
                      onTap: drawerData[index].action,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            drawerData[index].icon,
                            const SizedBox(
                              width: 15,
                            ),
                            Text(drawerData[index].title,
                                style:
                                TextStyle(color: Colors.white.withOpacity(.4))),
                            const Expanded(child: SizedBox())
                          ],
                        ),
                      ),
                    ),
                itemCount: drawerData.length,
                separatorBuilder: (context, index) =>
                    Divider(
                      color: Colors.white.withOpacity(.3),
                    ),
              ),
            ),
            Container(
              color: Colors.blueGrey.withOpacity(.4),
              height: 50,
              child: Center(
                  child: Text(
                    'Calma App',
                    style: TextStyle(color: Colors.white.withOpacity(.7)),
                  )),
            ),
          ],
        ));
  }

  _getLocation() async {
    await Geolocator.requestPermission();
    if (await Permission.location.isPermanentlyDenied) {
      print('isDenied');
    } else {
      [
        Permission.location,
        Permission.locationAlways,
        Permission.locationWhenInUse
      ].request();

      if (await Permission.location.isDenied) {
        //   Navigator.pop(context);
      } else {
        if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
          await Geolocator.requestPermission();
          final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          setState(() {
            BlocProvider.of<NadekCubit>(context).UpdateLocationUser(
                lit: position.latitude,
                long: position.longitude,
                token: token!);
            print('${position.latitude} \n ${position.longitude}');
          });
        }
      }
    }
  }
}

class DrawerData {
  String title;
  Function() action;
  Icon icon;

  DrawerData(this.title, this.action, this.icon);
}
