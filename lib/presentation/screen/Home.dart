import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:nadek/data/repository/repository.dart';
import 'package:nadek/data/webservices/WebServices.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Champions/Champions.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Clubs/Clubs.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Groups/Groups_Page.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Home_Page.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/MainPage.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Make_Video_Page.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Profile_Page.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Shopping/Shop_Page.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:permission_handler/permission_handler.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _State();
}

class _State extends State<Home_Screen> {
  GlobalKey<ScaffoldState> globalDrawer = GlobalKey();
  late repository rpo = repository(Web_Services());
  late NadekCubit cubit = NadekCubit(rpo);
  int index = 2;
  String? token;
  List<Widget> page = const [
    home_page(),
    Champions(),
    MainPage(),
    Clubs(),
    shop_page(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = CacheHelper.getString('tokens');
    _getLocation();
  }

  void ShowSocial() {
    String? s = CacheHelper.getString('isFirstOpen');
    if (s != null) {
      print('$s');
    } else {
      Navigator.pushNamed(context, '/FollowMe');
      CacheHelper.setString('isFirstOpen', 'yes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NadekCubit, NadekState>(listener: (context, state) {
      if (state is OpenDrawer) {
        globalDrawer.currentState!.openDrawer();
      }
    }, builder: (context, state) {
      return Scaffold(
        key: globalDrawer,
        backgroundColor: ColorApp.black_400,

        body: LazyLoadIndexedStack(index: index, children: page),
        // ConnectionNotifierToggler(
        //     onConnectionStatusChanged: (connected) {
        //       /// that means it is still in the initialization phase.
        //       if (connected == null) return;
        //       print(connected);
        //     },
        //     connected:
        //
        //     disconnected:Center(
        //       child: Image(
        //         height: 100,
        //         width: 100,
        //         image: AssetImage('assets/images/no-wifi.png'),
        //       ),
        //     ),
        //
        //   ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<NadekCubit>(context).ChangePageView();

            setState(() {
              this.index = 2;
            });
          },
          backgroundColor: ColorApp.darkRead,
          child: Image(
            height: 30,
            width: 30,
            image: AssetImage('assets/images/home.png'),
          ),
          //params
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: Container(
          height: 110,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BottomNavigationBar(
                      onTap: (index) {
                        BlocProvider.of<NadekCubit>(context).ChangePageView();
                        ShowSocial();
                        setState(() {
                          this.index = index;
                        });
                      },
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: ColorApp.black_400,
                      selectedItemColor: ColorApp.blue,
                      currentIndex: index,
                      unselectedItemColor: Colors.white,
                      unselectedIconTheme:
                          const IconThemeData(color: Colors.white),
                      selectedIconTheme: const IconThemeData(
                        color: ColorApp.move,
                      ),
                      items: const [
                        BottomNavigationBarItem(
                            label: 'الفيديوهات',
                            icon: Image(
                              height: 20,
                              width: 20,
                              image: AssetImage('assets/images/video.png'),
                            )),
                        BottomNavigationBarItem(
                            label: 'صرح',
                            icon: Image(
                              height: 25,
                              width: 25,
                              image: AssetImage('assets/images/diamonds.png'),
                            )),
                        BottomNavigationBarItem(
                            label: 'الرئيسية', icon: Icon(Icons.minimize)),
                        BottomNavigationBarItem(
                            label: 'البطولات',
                            icon: Image(
                              height: 25,
                              width: 25,
                              image: AssetImage('assets/images/crown.png'),
                            )),
                        BottomNavigationBarItem(
                            label: 'المتجر',
                            icon: Image(
                              height: 25,
                              width: 25,
                              image: AssetImage('assets/images/shop.png'),
                            )),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        drawer: drawer(),
      );
    });
  }

  Widget drawer() {
    return Drawer(
        backgroundColor: ColorApp.black_400,
        child: ListView(
          children: [
            ListTile(
              title: Text("المجموعات", style: TextStyle(color: Colors.white)),
              leading: Icon(
                Icons.chat,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => groups_page()));
              },
            ),
            ListTile(
              title:
                  Text("انتاج فيديوهات", style: TextStyle(color: Colors.white)),
              leading: Icon(Icons.video_collection_sharp, color: Colors.white),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => make_video_page()));
              },
            ),
            ListTile(
              title: Text(
                "الحساب",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.person, color: Colors.white),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => profile_page()));
              },
            )
          ],
        ));
  }

  _getLocation() async {
    await Geolocator.requestPermission();
    if (await Permission.location.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
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
