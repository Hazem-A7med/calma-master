import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nadek/data/model/register_model.dart';
import 'package:nadek/data/model/sports.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
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

  sports_selection(this.name, this.date, this.sex, this.phone, this.password,{Key? key}): super(key: key);

  @override
  State<sports_selection> createState() => _sports_selectionState();
}

class _sports_selectionState extends State<sports_selection> {

  late sports s;
  late register_model register;
  late String fcm_token;
  bool isLoading = true;
  List<int> _fav =[];
  List<dynamic> _favText=[];

  @override
  void initState() {
    // TODO: implement initState
   // _token();
    BlocProvider.of<NadekCubit>(context).getSports();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: AppColors.scaffold,
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
          chanegedInternt: (status){
            BlocProvider.of<NadekCubit>(context).getSports();

          },
          child: BlocConsumer<NadekCubit, NadekState>(
            listener:(context, state){

              if (state is LoadedDataSports ){
                setState((){

                  s= state.s;
                  isLoading=false;

                });

              }

              if(state is LoadedResgister) {
                setState((){
                  register =state.r;

                });
                if (register.status==true) {
                  CacheHelper.setString('tokens','${register.data?.apiKey}');
                  CacheHelper.setString('Id',  '${register.data?.iD}');
                  SharedPreferences.getInstance().then((value) {
                    value.setString('token','${register.data?.apiKey}');
                    value.setString('username', '${register.data?.name}');


                    value.setString('berth_day', '${register.data?.berthDay}');
                    value.setString('gender', '${register.data?.gender}');
                    value.setString('phone', '${register.data?.phoneNumber}');
                    value.setString('youtube', '${register.data?.youtube}');
                    value.setString('instagram', '${register.data?.instagram}');

                    Navigator.pushNamedAndRemoveUntil(context, '/Home_screen', (route) => false);



                  });
                }else{
                  Fluttertoast.showToast(
                    msg: '${register.msg}}',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.pop(context);
                }
              }
            } ,
            builder: (context, state) {



              return  layout(context);
            },
          ),
        )
    );
  }

  Widget layout(context) {
    return Stack(
      children: [
        isLoading ?
        Container(
          height: double.infinity,
          width: double.infinity,
          color: ColorApp.black_400,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ) :
        SingleChildScrollView(
          physics: ScrollPhysics(),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50),
                child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children:  [
                        const Text(string_app.nadek,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 40,
                              color: Colors.white
                          ),
                        ),
                        Text(' اختر رياضتك المفضلة${_favText.toString()}',
                          style: TextStyle(
                              decoration: TextDecoration.none,

                              fontSize: 21,
                              color: Colors.white
                          ),
                        ),
                      ],
                    )
                ),
              ),

              GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: s.data?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                  ),
                  itemBuilder: (itemBuilder, index) {
                    return  Component_App.SelectionImage(
                      function: (){
                        setState((){
                          if ( _fav.contains(s.data?[index].id) &&_favText.contains(s.data?[index].title)) {
                            _fav.remove(s.data?[index].id);
                            _favText.remove(s.data?[index].title);
                          } else{
                            _fav.add(s.data![index].id!.toInt()) ;
                            _favText.add(s.data?[index].title);
                          }

                        });
                      },
                      image: "${s.data?[index].photo}",
                      title: '${s.data?[index].title}',

                    );
                  }
              ),
              const SizedBox(
                height: 10,
              ),
              Component_App.Button(
                  text: 'متابعة التسجيل',
                  function: () {
                    CreateAccount(context);

                  }
              )
            ],
          ),
        )
      ],
    );
  }

  void CreateAccount(context) async{
    _token().then((value){
      BlocProvider.of<NadekCubit>(context).Register(
          name: widget.name,
          date: widget.date,
          sex: widget.sex,
          phone: widget.phone,
          password: widget.password,
          fcm_token: value.toString(),
          list: _fav
      );
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

