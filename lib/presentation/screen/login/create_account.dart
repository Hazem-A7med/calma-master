import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:nadek/presentation/screen/login/widgets/gender_widget.dart';
import 'package:nadek/presentation/screen/login/widgets/or_widget.dart';
import 'package:nadek/presentation/screen/login/widgets/register_check_row.dart';
import 'package:nadek/presentation/screen/login/widgets/social_sign_button.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/constante/string.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

import '../../../core/utils/app_colors.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerDate = TextEditingController();
  final _controllerGender = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerPassword = TextEditingController();
  DateTime selectedDate = DateTime.now();

  final formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool isMale = true;
  final String _sex = 'male';
  String? _date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffold,
        appBar: AppBar(
            title: Align(
              alignment: Alignment.centerRight,
              child: Text('يرجى إنشاء حساب للمتابعة',
                  style: TextStyle(
                      fontSize: 18, color: Colors.white.withOpacity(.7))),
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
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Component_App.InputText(
                        icon: Icons.person,
                        controller: _controllerName,
                        title: 'الاسم',
                        hint: 'ادخل اسمك هنا',
                        textInputType: TextInputType.text,
                        function: (value) {
                          if (value.isEmpty) {
                            return "ادخل الاسم";
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    //////////////
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'رقم الهاتف',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white.withOpacity(.5),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _controllerPhone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "ادخل رقم الهاتف";
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            isDense: true,
                            fillColor: ColorApp.textField,
                            filled: true,
                            suffixIcon: const SizedBox(width: 70,
                              child: CountryCodePicker(showFlag: true,enabled: true,
                                padding: EdgeInsets.zero,
                                showDropDownButton: false,
                                hideMainText: true,
                                showCountryOnly: true,
                                flagDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                alignLeft: false,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            hintText: 'رقم الهاتف',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ////////////
                    // Component_App.InputText(
                    //     title: 'رقم الهاتف',
                    //     controller: _controllerPhone,
                    //     hint: 'رقم الهاتف',
                    //     textInputType: TextInputType.phone,
                    //     icon: Icons.call,
                    //     function: (value) {
                    //       if (value.isEmpty) {
                    //         return "ادخل رقم الهاتف";
                    //       } else {
                    //         return null;
                    //       }
                    //     }),
                    const SizedBox(
                      height: 10,
                    ),
                    Component_App.InputText(
                        title: 'البريد الالكتروني',
                        controller: _controllerEmail,
                        hint: 'ادخل بريدك الإكتروني هنا',
                        textInputType: TextInputType.emailAddress,
                        icon: Icons.mail,
                        function: (value) {
                          if (value.isEmpty) {
                            return "ادخل البريد الالكتروني";
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Component_App.InputText(
                        title: 'كلمة المرور',
                        controller: _controllerPassword,
                        hint: 'ادخل كلمة المرور هنا',
                        textInputType: TextInputType.visiblePassword,
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
                    RegisterCheckRow(
                      isChecked: isChecked,
                    ),
                    GenderWidget(
                      isMale: isMale,
                      feMalePress: () {
                        setState(() {
                          isMale = false;
                        });
                      },
                      malePress: () {
                        setState(() {
                          isMale = true;
                        });
                      },
                    ),
                    const OrWidget(),
                    SocialSignButton(
                      image: 'Google',
                      txt: 'التسجيل باستخدام جوجل ',
                      onTab: () {},
                    ),
                    SocialSignButton(
                      image: 'Facebook',
                      txt: 'التسجيل باستحدام فيس بوك ',
                      onTab: () {},
                    ),
                    const SizedBox(
                      height: 19,
                    ),
                    Component_App.gradientButton(
                      text: 'إنشاء حساب ',
                      function: () {
                        final isValid = formKey.currentState!.validate();
                        if (isValid) {
                          Navigator.pushNamed(context, '/Sports_Selection',
                              arguments: [
                                _controllerName.text,
                                _date,
                                _sex,
                                _controllerPhone.text,
                                _controllerPassword.text
                              ]);
                        }
                      },
                    ),
                    // Component_App.Button(
                    //     text: 'متابعة التسجيل',
                    //     function: () {
                    //       final isValid = formKey.currentState!.validate();
                    //       if (isValid) {
                    //         Navigator.pushNamed(context, '/Sports_Selection',
                    //             arguments: [
                    //               _controllerName.text,
                    //               _date,
                    //               _sex,
                    //               _controllerPhone.text,
                    //               _controllerPassword.text
                    //             ]);
                    //       }
                    //     }),
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(context, '/login_user');
                          },
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorApp.darkRead.withOpacity(.7)),
                          ),
                        ),
                        Text(
                          ' لديك حساب بالفعل ؟ ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(.3)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 43,
                    ),
                  ],
                ),
              ),
            )));
  }

// Future<void> _selectDate(BuildContext context) async {
//   final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(1900, 8),
//       lastDate: DateTime.now());
//
//   if (picked != null && picked != selectedDate) {
//     setState(() {
//       selectedDate = picked;
//       _date =
//           '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
//       print(_date);
//     });
//   }
// }
}
//Navigator.pushNamed(context, '/termsAndConditions');
// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// const Text(
// 'عند متابعة  التسجيل فأنت توافق علي الاحكام والشروط ',
// style: TextStyle(
// fontSize: 14,
// color: Colors.white,
// ),
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// GestureDetector(
// onTap: () {
// Navigator.pushNamed(
// context, '/termsAndConditions');
// },
// child: const Text(
// 'Terms of use,\n',
// style:
// TextStyle(fontSize: 14, color: Colors.blue),
// ),
// ),
// GestureDetector(
// onTap: () {
// Navigator.pushNamed(context, '/privacy_policy');
// },
// child: const Text(
// 'Privacy policy\n',
// style:
// TextStyle(fontSize: 14, color: Colors.blue),
// ),
// ),
// ],
// ),
// ],
// ),
