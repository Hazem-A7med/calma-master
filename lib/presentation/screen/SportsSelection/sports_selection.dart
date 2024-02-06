import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nadek/data/model/register_model.dart';
import 'package:nadek/data/model/sports.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/SportsSelection/widgets/sports_grid_item.dart';
import 'package:nadek/sheard/ChangeInternet.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/constante/string.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/app_colors.dart';

class sports_selection extends StatefulWidget {
  late String name;
  late String date;
  late String sex;
  late String phone;
  late String password;

  sports_selection(this.name, this.date, this.sex, this.phone, this.password,
      {Key? key})
      : super(key: key);

  @override
  State<sports_selection> createState() => _sports_selectionState();
}

class _sports_selectionState extends State<sports_selection> {
  late sports s;
  late register_model register;
  late String fcm_token;
  bool isLoading = true;
  bool isSelected = true;
  List<int> _fav = [];
  List<dynamic> _favText = [];

  @override
  void initState() {
    // TODO: implement initState
    // _token();
    BlocProvider.of<NadekCubit>(context).getSports();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: AppBar(
            title: Align(
              alignment: Alignment.centerRight,
              child: Text('اختر رياضتك المفضلة',
                  style: TextStyle(
                      fontSize: 20, color: Colors.white.withOpacity(.7))),
            ),
            centerTitle: true,
            actions: [
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_forward_rounded)),
              const SizedBox(
                width: 10,
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent),
        body: ChangeInternet(
          chanegedInternt: (status) {
            BlocProvider.of<NadekCubit>(context).getSports();
          },
          child: BlocConsumer<NadekCubit, NadekState>(
            listener: (context, state) {
              if (state is LoadedDataSports) {
                setState(() {
                  s = state.s;
                  isLoading = false;
                });
              }

              if (state is LoadedResgister) {
                setState(() {
                  register = state.r;
                });
                if (register.status == true) {
                  CacheHelper.setString('tokens', '${register.data?.apiKey}');
                  CacheHelper.setString('Id', '${register.data?.iD}');
                  SharedPreferences.getInstance().then((value) {
                    value.setString('token', '${register.data?.apiKey}');
                    value.setString('username', '${register.data?.name}');

                    value.setString('berth_day', '${register.data?.berthDay}');
                    value.setString('gender', '${register.data?.gender}');
                    value.setString('phone', '${register.data?.phoneNumber}');
                    value.setString('youtube', '${register.data?.youtube}');
                    value.setString('instagram', '${register.data?.instagram}');

                    Navigator.pushNamedAndRemoveUntil(
                        context, '/MainPage', (route) => false);
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, '/Home_screen', (route) => false);
                  });
                } else {
                  Fluttertoast.showToast(
                    msg: '${register.msg}}',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.pop(context);
                }
              }
            },
            builder: (context, state) {
              return layout(context);
            },
          ),
        ));
  }

  Widget layout(context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(color: AppColors.mainColor),
    )
        : SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  18.0),
        child: SizedBox(height: MediaQuery.of(context).size.height*.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   ' ${_favText.toString()}',
              //   style: const TextStyle(
              //       decoration: TextDecoration.none,
              //       fontSize: 21,
              //       color: Colors.white),
              // ),
              const SizedBox(),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: s.data?.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemBuilder: (itemBuilder, index) {
                    return
                      SportsGridItem(imagePath: s.data?[index].photo ?? '',
                          name: s.data?[index].title??'',
                          isSelected: (_fav.contains(s.data?[index].id) &&
                              _favText.contains(s.data?[index].title))?true:false,
                          onTab: () {
                            setState(() {
                              if (_fav.contains(s.data?[index].id) &&
                                  _favText.contains(s.data?[index].title)) {
                                _fav.remove(s.data?[index].id);
                                _favText.remove(s.data?[index].title);
                              } else {

                                _fav.add(s.data![index].id!.toInt());
                                _favText.add(s.data?[index].title);
                              }
                            });
                          },);

                    //
                    // Container(width: double.infinity, height: double.infinity,
                    //   decoration: const BoxDecoration(
                    //     borderRadius: BorderRadius.all(Radius.circular(15)),
                    //     gradient: LinearGradient(
                    //         begin: Alignment.topCenter,
                    //         end: Alignment.bottomCenter,
                    //         colors: [
                    //           Color(0xffE11717),
                    //           Color(0xffDA552B),
                    //         ]),
                    //   ),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         borderRadius: const BorderRadius.all(
                    //             Radius.circular(15)),
                    //         color: AppColors.scaffold,
                    //         border: Border.all(
                    //             width: 1, color: Colors.white12)),
                    //     child: Component_App.SelectionImage(
                    //       function: () {
                    //         setState(() {
                    //           if (_fav.contains(s.data?[index].id) &&
                    //               _favText.contains(s.data?[index].title)) {
                    //             _fav.remove(s.data?[index].id);
                    //             _favText.remove(s.data?[index].title);
                    //           } else {
                    //             _fav.add(s.data![index].id!.toInt());
                    //             _favText.add(s.data?[index].title);
                    //           }
                    //         });
                    //       },
                    //       image: "${s.data?[index].photo}",
                    //       title: '${s.data?[index].title}',
                    //     ),
                    //   ),
                    // );
                  }),
              // const SizedBox(
              //   height: 10,
              // ),
              const SizedBox(),
              Component_App.gradientButton(
                  text: 'متابعة التسجيل',
                  function: () {
                    CreateAccount(context);
                  })
            ],
          ),
        ),
      ),
    );
  }

  void CreateAccount(context) async {
    _token().then((value) {
      BlocProvider.of<NadekCubit>(context).Register(
          name: widget.name,
          date: widget.date,
          sex: widget.sex,
          phone: widget.phone,
          password: widget.password,
          fcm_token: value.toString(),
          list: _fav);
    });

    setState(() {
      isLoading = true;
    });
  }

  Future<String> _token() async {
    await FirebaseMessaging.instance.getToken().then((mtoken) {
      return mtoken;
    });
    return "";
  }
}
