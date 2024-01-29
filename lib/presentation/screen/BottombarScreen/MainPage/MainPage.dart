import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/data/model/BestUser.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/create_post_widget.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/post_item.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/stories_list.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/story.dart';
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
  List<String> nameList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    // ScrollController controller =
    //     FixedExtentScrollController(initialItem: initialItem);
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
                                    builder: (builder) => ProfileOfUser(
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
                          // SizedBox(
                          //   height: 150,
                          //   child: RotatedBox(
                          //     quarterTurns: 1,
                          //     child: ListWheelScrollView(
                          //         itemExtent: 100,
                          //         squeeze: .7,
                          //         physics: const FixedExtentScrollPhysics(),
                          //         diameterRatio: 1.9,
                          //         perspective: 0.001,
                          //         onSelectedItemChanged: (value) {
                          //           setState(() {
                          //             currentScrollValue = value;
                          //           });
                          //         },
                          //         controller: controller,
                          //         children: <Widget>[
                          //           ...nameList.map((String name) {
                          //             return (nameList.indexOf(name) ==
                          //                     currentScrollValue)
                          //                 ? Container(
                          //                     height: 100,
                          //                     width: 100,
                          //                     decoration: BoxDecoration(
                          //                         color: CupertinoColors.white,
                          //                         borderRadius:
                          //                             BorderRadius.circular(10),
                          //                         border: Border.all(
                          //                             width: 1,
                          //                             color: CupertinoColors
                          //                                 .inactiveGray)),
                          //                     padding: const EdgeInsets.all(10),
                          //                     child: Text(name),
                          //                   )
                          //                 : Container(
                          //                     height: 40,
                          //                     width: 40,
                          //                     decoration: BoxDecoration(
                          //                         color:
                          //                             CupertinoColors.systemGreen,
                          //                         borderRadius:
                          //                             BorderRadius.circular(10),
                          //                         border: Border.all(
                          //                             width: 1,
                          //                             color: CupertinoColors
                          //                                 .inactiveGray)),
                          //                     padding: const EdgeInsets.all(10),
                          //                     child: Text(name),
                          //                   );
                          //           })
                          //         ]),
                          //   ),
                          // ),
                          const StoriesList(),
                          const CreatePostWidget(),
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => const PostItem(),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              itemCount: 10)

                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (builder) =>
                          //                 const ReservationScreen()));
                          //   },
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: SizedBox(
                          //       height: 129,
                          //       width: 320,
                          //       child: Stack(
                          //         alignment: Alignment.bottomCenter,
                          //         children: [
                          //           const Image(
                          //             image: AssetImage(
                          //                 'assets/images/stanley.png'),
                          //           ),
                          //           Container(
                          //             height: 40,
                          //             width: double.infinity,
                          //             color: Colors.black87,
                          //             child: const Center(
                          //               child: Text(
                          //                 'حجز الملاعب',
                          //                 style:
                          //                     TextStyle(color: Colors.white),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     card(
                          //       color: ColorApp.blue,
                          //       img: 'assets/images/shield.png',
                          //       text: 'تقييم اللاعب',
                          //       function: () {
                          //         Fluttertoast.showToast(
                          //           msg: 'قريبا ان شاء الله',
                          //           toastLength: Toast.LENGTH_LONG,
                          //           gravity: ToastGravity.BOTTOM,
                          //         );
                          //       },
                          //     ),
                          //     const SizedBox(
                          //       width: 15,
                          //     ),
                          //     card(
                          //       color: ColorApp.move,
                          //       img: 'assets/images/search.png',
                          //       text: 'البحث',
                          //       function: () {
                          //         // Fluttertoast.showToast(
                          //         //   msg: 'قريبا ان شاء الله',
                          //         //   toastLength: Toast.LENGTH_LONG,
                          //         //   gravity: ToastGravity.BOTTOM,
                          //         // );
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (builder) =>
                          //                     const SearchScreen()));
                          //       },
                          //     ),
                          //     const SizedBox(
                          //       width: 15,
                          //     ),
                          //     card(
                          //       color: ColorApp.blue2,
                          //       img: 'assets/images/user_search.png',
                          //       text: 'عرض اللاعبين',
                          //       function: () {
                          //         // Fluttertoast.showToast(
                          //         //   msg: 'قريبا ان شاء الله',
                          //         //   toastLength: Toast.LENGTH_LONG,
                          //         //   gravity: ToastGravity.BOTTOM,
                          //         // );
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (builder) =>
                          //                     const AllPlayers()));
                          //       },
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     card2(
                          //         color: ColorApp.yellow,
                          //         img: 'assets/images/map_use.png',
                          //         function: () {
                          //           Navigator.pushNamed(context, '/Maps');
                          //         },
                          //         text: 'خريطةاللاعبين'),
                          //     const SizedBox(
                          //       width: 15,
                          //     ),
                          //     card2(
                          //         color: ColorApp.green,
                          //         img: 'assets/images/sports_shoes.png',
                          //         function: () {
                          //           // Fluttertoast.showToast(
                          //           //   msg: 'قريبا ان شاء الله',
                          //           //   toastLength: Toast.LENGTH_LONG,
                          //           //   gravity: ToastGravity.BOTTOM,
                          //           // );
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (builder) =>
                          //                       const TypeSports()));
                          //         },
                          //         text: 'أنواع الرياضات')
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     card2(
                          //         width: 152,
                          //         color: Colors.deepPurpleAccent,
                          //         img: 'assets/icons/ic_location_map.png',
                          //         function: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (b) =>
                          //                       const PlaygroundMaps()));
                          //           BlocProvider.of<NadekCubit>(context)
                          //               .ChangePageView();
                          //         },
                          //         text: ' خريطة الملاعب'),
                          //     const SizedBox(
                          //       width: 15,
                          //     ),
                          //     card2(
                          //         width: 152,
                          //         color: Colors.indigoAccent,
                          //         img: 'assets/images/play.png',
                          //         function: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (_) =>
                          //                       VirtualTournmentsList()));
                          //           BlocProvider.of<NadekCubit>(context)
                          //               .ChangePageView();
                          //         },
                          //         text: 'بــث مبـاشــر'),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     ClipRRect(
                          //       borderRadius: BorderRadius.circular(10),
                          //       child: SizedBox(
                          //         height: 129,
                          //         width: 320,
                          //         child: Stack(
                          //           alignment: Alignment.bottomCenter,
                          //           children: [
                          //             Container(
                          //               color: ColorApp.darkRead,
                          //               child:
                          //                   BlocConsumer<NadekCubit, NadekState>(
                          //                 listener: (context, state) {
                          //                   if (state is LoadedBestUser) {
                          //                     setState(() {
                          //                       bestUser = state.data;
                          //                       waiting = true;
                          //                     });
                          //                   }
                          //                 },
                          //                 builder: (context, state) {
                          //                   return bestUsers();
                          //                 },
                          //               ),
                          //             ),
                          //             Container(
                          //               height: 40,
                          //               width: double.infinity,
                          //               color: Colors.black87,
                          //               child: const Center(
                          //                 child: Text(
                          //                   'قائمة المتصدرين',
                          //                   style: TextStyle(color: Colors.white),
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 40,
                          // ),
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

  // Widget bestUsers() {
  //   return Stack(
  //     children: [
  //       waiting
  //           ? Container(
  //               color: ColorApp.black_400,
  //               height: double.infinity,
  //               child: bestUser!.data!.isEmpty
  //                   ? Container(
  //                       color: ColorApp.darkRead,
  //                       height: double.infinity,
  //                       width: double.infinity,
  //                       alignment: Alignment.topCenter,
  //                       child: const Padding(
  //                         padding: EdgeInsets.only(top: 8.0),
  //                         child: Text(
  //                           "قريبا ....",
  //                           textDirection: TextDirection.rtl,
  //                           textAlign: TextAlign.right,
  //                           style: TextStyle(
  //                             fontSize: 32,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   : ListView.separated(
  //                       shrinkWrap: true,
  //                       scrollDirection: Axis.horizontal,
  //                       itemBuilder: (context, index) =>
  //                           Component_App.Item_group(
  //                               file: '${bestUser!.data![index].photo}',
  //                               name: '${bestUser!.data![index].name}',
  //                               function: () {
  //                                 Navigator.pushNamed(context, '/ProfileOfUser',
  //                                     arguments: [
  //                                       bestUser!.data![index].id,
  //                                     ]);
  //                               }),
  //                       separatorBuilder: (context, index) => Container(),
  //                       itemCount: bestUser!.data!.length),
  //             )
  //           : Container(
  //               height: double.infinity,
  //               width: double.infinity,
  //               color: ColorApp.black_400,
  //               child: const Center(
  //                 child: CircularProgressIndicator(),
  //               ),
  //             ),
  //     ],
  //   );
  // }
  //
  // Widget card(
  //     {required Color color,
  //     required String img,
  //     required Function() function,
  //     required String text}) {
  //   return Container(
  //     decoration:
  //         BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
  //     height: 95,
  //     width: 95,
  //     child: GestureDetector(
  //       onTap: function,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Image(
  //             height: 50,
  //             width: 50,
  //             image: AssetImage(img),
  //           ),
  //           Text(
  //             text,
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget card2(
  //     {double? width,
  //     required Color color,
  //     required String img,
  //     required Function() function,
  //     required String text}) {
  //   return GestureDetector(
  //     onTap: function,
  //     child: Container(
  //         width: width ?? 150,
  //         height: 95,
  //         decoration: BoxDecoration(
  //             color: color, borderRadius: BorderRadius.circular(10)),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Image(
  //               height: 60,
  //               width: 70,
  //               image: AssetImage(img),
  //             ),
  //             Text(
  //               text,
  //               style: const TextStyle(color: Colors.white, fontSize: 12),
  //             ),
  //           ],
  //         )),
  //   );
  // }

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
                        builder: (builder) => ProfileOfUser(
                            myProfile: true, user_id: int.parse(id!))));
              },
              child: SizedBox(width: double.infinity,
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
                itemBuilder: (context, index) => GestureDetector(
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
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white.withOpacity(.3),
                ),
                //children: [
                // ListTile(
                //   title: Text("المجموعات", style: TextStyle(color: Colors.white)),
                //   leading: Icon(
                //     Icons.chat,
                //     color: Colors.white,
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (c) => groups_page()));
                //   },
                // ),
                // ListTile(
                //   title:
                //       Text("انتاج فيديوهات", style: TextStyle(color: Colors.white)),
                //   leading: Icon(Icons.video_collection_sharp, color: Colors.white),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (c) => make_video_page()));
                //   },
                // ),
                // ListTile(
                //   title: Text(
                //     "الحساب",
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   leading: Icon(Icons.person, color: Colors.white),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context, MaterialPageRoute(builder: (c) => profile_page()));
                //   },
                // )
                //  ],
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
