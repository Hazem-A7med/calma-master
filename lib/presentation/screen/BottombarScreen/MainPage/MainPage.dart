import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nadek/data/model/BestUser.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/AllPlayers.dart';
import 'package:nadek/presentation/screen/PlaygroundMaps.dart';
import 'package:nadek/presentation/screen/ProfileOfUser.dart';
import 'package:nadek/presentation/screen/ReservationScreen.dart';
import 'package:nadek/presentation/screen/SearchScreen.dart';
import 'package:nadek/presentation/screen/TypeSports.dart';
import 'package:nadek/presentation/screen/virtualTournments/virtual_tournments_list.dart';
import 'package:nadek/sheard/ChangeInternet.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    token = CacheHelper.getString('tokens');
    // BlocProvider.of<NadekCubit>(context).GetBestUser(token: token!);

    photo = CacheHelper.getString('photo').toString().replaceAll('\'', '');
    photo = 'https://calmaapp.com/default.png';

    name = CacheHelper.getString('username');
    id = CacheHelper.getString('Id')!;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        toolbarHeight: 0,
        title: const Text(
          'الرئيسية',
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            BlocProvider.of<NadekCubit>(context).openDrawers();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: ChangeInternet(
        chanegedInternt: (r) {
          BlocProvider.of<NadekCubit>(context).GetBestUser(token: token!);
        },
        child: BlocConsumer<NadekCubit, NadekState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
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
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      image: NetworkImage('$photo')),
                                ),
                              ),
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
                      )),
                      const Expanded(
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.notifications,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            const ReservationScreen()));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: 129,
                                  width: 320,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      const Image(
                                        image: AssetImage(
                                            'assets/images/stanley.png'),
                                      ),
                                      Container(
                                        height: 40,
                                        width: double.infinity,
                                        color: Colors.black87,
                                        child: const Center(
                                          child: Text(
                                            'حجز الملاعب',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            card(
                              color: ColorApp.blue,
                              img: 'assets/images/shield.png',
                              text: 'تقييم اللاعب',
                              function: () {
                                Fluttertoast.showToast(
                                  msg: 'قريبا ان شاء الله',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              },
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            card(
                              color: ColorApp.move,
                              img: 'assets/images/search.png',
                              text: 'البحث',
                              function: () {
                                // Fluttertoast.showToast(
                                //   msg: 'قريبا ان شاء الله',
                                //   toastLength: Toast.LENGTH_LONG,
                                //   gravity: ToastGravity.BOTTOM,
                                // );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            const SearchScreen()));
                              },
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            card(
                              color: ColorApp.blue2,
                              img: 'assets/images/user_search.png',
                              text: 'عرض اللاعبين',
                              function: () {
                                // Fluttertoast.showToast(
                                //   msg: 'قريبا ان شاء الله',
                                //   toastLength: Toast.LENGTH_LONG,
                                //   gravity: ToastGravity.BOTTOM,
                                // );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            const AllPlayers()));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            card2(
                                color: ColorApp.yellow,
                                img: 'assets/images/map_use.png',
                                function: () {
                                  Navigator.pushNamed(context, '/Maps');
                                },
                                text: 'خريطةاللاعبين'),
                            const SizedBox(
                              width: 15,
                            ),
                            card2(
                                color: ColorApp.green,
                                img: 'assets/images/sports_shoes.png',
                                function: () {
                                  // Fluttertoast.showToast(
                                  //   msg: 'قريبا ان شاء الله',
                                  //   toastLength: Toast.LENGTH_LONG,
                                  //   gravity: ToastGravity.BOTTOM,
                                  // );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const TypeSports()));
                                },
                                text: 'أنواع الرياضات')
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            card2(
                                width: 152,
                                color: Colors.deepPurpleAccent,
                                img: 'assets/icons/ic_location_map.png',
                                function: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (b) =>
                                              const PlaygroundMaps()));
                                  BlocProvider.of<NadekCubit>(context)
                                      .ChangePageView();
                                },
                                text: ' خريطة الملاعب'),
                            const SizedBox(
                              width: 15,
                            ),
                            card2(
                                width: 152,
                                color: Colors.indigoAccent,
                                img: 'assets/images/play.png',
                                function: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              VirtualTournmentsList()));
                                  BlocProvider.of<NadekCubit>(context)
                                      .ChangePageView();
                                },
                                text: 'بــث مبـاشــر'),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 129,
                                width: 320,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      color: ColorApp.darkRead,
                                      child:
                                          BlocConsumer<NadekCubit, NadekState>(
                                        listener: (context, state) {
                                          if (state is LoadedBestUser) {
                                            setState(() {
                                              bestUser = state.data;
                                              waiting = true;
                                            });
                                          }
                                        },
                                        builder: (context, state) {
                                          return bestUsers();
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: double.infinity,
                                      color: Colors.black87,
                                      child: const Center(
                                        child: Text(
                                          'قائمة المتصدرين',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget bestUsers() {
    return Stack(
      children: [
        waiting
            ? Container(
                color: ColorApp.black_400,
                height: double.infinity,
                child: bestUser!.data!.isEmpty
                    ? Container(
                        color: ColorApp.darkRead,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.topCenter,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "قريبا ....",
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            Component_App.Item_group(
                                file: '${bestUser!.data![index].photo}',
                                name: '${bestUser!.data![index].name}',
                                function: () {
                                  Navigator.pushNamed(context, '/ProfileOfUser',
                                      arguments: [
                                        bestUser!.data![index].id,
                                      ]);
                                }),
                        separatorBuilder: (context, index) => Container(),
                        itemCount: bestUser!.data!.length),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                color: ColorApp.black_400,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ],
    );
  }

  Widget card(
      {required Color color,
      required String img,
      required Function() function,
      required String text}) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      height: 95,
      width: 95,
      child: GestureDetector(
        onTap: function,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: 50,
              width: 50,
              image: AssetImage(img),
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget card2(
      {double? width,
      required Color color,
      required String img,
      required Function() function,
      required String text}) {
    return GestureDetector(
      onTap: function,
      child: Container(
          width: width ?? 150,
          height: 95,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                height: 60,
                width: 70,
                image: AssetImage(img),
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          )),
    );
  }
}
