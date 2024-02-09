import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/data/model/login_model.dart';
import 'package:nadek/logic/cubit/facebook_logIn_cubit.dart';
import 'package:nadek/logic/cubit/google_signIn_cubit.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/login/widgets/gradient_text.dart';
import 'package:nadek/presentation/screen/login/widgets/login_check_row.dart';
import 'package:nadek/presentation/screen/login/widgets/or_widget.dart';
import 'package:nadek/presentation/screen/login/widgets/social_sign_button.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login_user extends StatefulWidget {
  const login_user({Key? key}) : super(key: key);

  @override
  State<login_user> createState() => _login_userState();
}

class _login_userState extends State<login_user> {
  final _controller_phone = TextEditingController();
  final _controller_password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late login_model login;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: layout(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
    );
  }

  bool isChecked = false;

  Widget layout() {
    return BlocListener<NadekCubit, NadekState>(
      listener: (context, state) {
        // TODO: implement listener

        if (state is LoginLoadedDataState) {
          setState(() {
            isLoading = false;
            if (state.model.status == false) {
              //showSnackBarError(context, title: '',message:'${ state.model.msg}');
              Fluttertoast.showToast(
                msg: '${state.model.msg}',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
            } else {
              CacheHelper.setString('tokens', ' ${state.model.data?.apiKey}');
              CacheHelper.setString('username', ' ${state.model.data?.name}');
              CacheHelper.setString('photo', ' ${state.model.data?.photo}');
              CacheHelper.setString('Id', '${state.model.data?.iD}');
              SharedPreferences.getInstance().then((value) {
                setState(() {
                  // token =value.getString('token');
                  value.setString('token', ' ${state.model.data?.apiKey}');
                  value.setString('username', '${state.model.data?.name}');
                  value.setString('photo', '${state.model.data?.photo}');

                  value.setString('berth_day', '${state.model.data?.berthDay}');
                  value.setString('gender', '${state.model.data?.gender}');
                  value.setString('phone', '${state.model.data?.phoneNumber}');
                  value.setString('youtube', '${state.model.data?.youtube}');
                  value.setString(
                      'instagram', '${state.model.data?.instagram}');
                });
              });

              Navigator.popAndPushNamed(context, '/MainPage');
             // Navigator.popAndPushNamed(context, '/Home_screen');
            }
          });
        }
      },
      child: (isLoading) ?
      const SizedBox(
        height: double.infinity,
        width: double.infinity,
        //color: ColorApp.black_400,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.mainColor),
        ),
      )
          :
      SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'مرحباً بك في كالما',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'أدخل عنوان بريدك الالكتروني وكلمة المرور لاستخدام التطبيق',
                        style: TextStyle(
                            fontSize: 14,
                            color:
                            Colors.white.withOpacity(.7)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Component_App.InputText(
                      title: 'رقم الهاتف',
                      controller: _controller_phone,
                      hint: 'ادخل رقم الهاتف',
                      textInputType: TextInputType.phone,
                      icon: Icons.phone,
                      function: (value) {
                        if (value.isEmpty) {
                          return "ادخل رقم الهاتف";
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(
                    height: 18,
                  ),
                  Component_App.InputText(
                      title: 'كلمة المرور',
                      controller: _controller_password,
                      hint: 'ادخل كلمة المرور هنا',
                      textInputType:
                      TextInputType.visiblePassword,
                      icon: Icons.lock,
                      function: (value) {
                        if (value.isEmpty) {
                          return "ادخل كلمة السر";
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  LoginCheckRow(isChecked: isChecked,),
                  const SizedBox(
                    height: 50,
                  ),
                  const OrWidget(),
                   SocialSignButton(image: 'Google', txt: 'الدخول باستخدام جوجل', onTab: () { context.read<GoogleLogInCubit>().signInWithGoogle(context); },),
                   SocialSignButton(image: 'Facebook', txt: 'الدخول باستحدام فيس بوك', onTab: () { context.read<FacebookLoginCubit>().facebookLogIn(context); },),
                  const SizedBox(height: 5,),
                  Component_App.gradientButton(
                      text: 'تسجيل الدخول',
                      function: () {
                        Login();
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.popAndPushNamed(
                          //     context, '/Create_Account');
                          Navigator.pushNamed(
                              context, '/Create_Account');
                        },
                        child:  Text(
                          ' انشاء حساب جديد',
                          style: TextStyle(
                              fontSize: 14, color: ColorApp.darkRead.withOpacity(.6)),
                        ),
                      ),
                       Text(
                        'ليس لديك حساب ؟ ',
                        style: TextStyle(
                            fontSize: 14, color: Colors.white.withOpacity(.2)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 43,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void Login() {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      setState(() {
        isLoading = true;
        BlocProvider.of<NadekCubit>(context).login_user(
            phone: _controller_phone.text, password: _controller_password.text);
      });
    }

    //  print(login.msg);

    print('${_controller_password.text + '\n' + _controller_phone.text}');
  }
}
