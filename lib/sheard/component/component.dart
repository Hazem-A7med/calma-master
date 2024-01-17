import 'package:date_field/date_field.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:nadek/sheard/constante/string.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class Component_App {
  static Widget ImageSlider({required String asset, required String desc}) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          Image(
            image: AssetImage(asset),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 40, 30, 10),
                  child: Text(
                    string_app.nadek,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 55,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        // remove under text { Line yellow}
                        decoration: TextDecoration.none),
                  ),
                ),
                Container(
                    height: 140,
                    width: 287,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                        color: ColorApp.move,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(52),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(52),
                            bottomRight: Radius.circular(0))),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        desc,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            // remove under text { Line yellow}
                            decoration: TextDecoration.none),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget InputDate(
      {required Function(DateTime object) function,
      required String hint,
      required TextInputType textInputType,
      IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: SizedBox(
          width: 322,
          child: DateTimeFormField(
            dateTextStyle: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                borderRadius: BorderRadius.circular(31),
              ),
              hintStyle: const TextStyle(color: Colors.white),
              counterStyle: const TextStyle(
                color: Colors.white,
              ),
              errorStyle: const TextStyle(color: Colors.redAccent),
              suffixIcon: const Icon(
                Icons.event_note,
                color: Colors.white,
              ),
              hintText: 'التاريخ',
              labelStyle: const TextStyle(color: Colors.white),
              suffixStyle: const TextStyle(color: Colors.white),
              isDense: true,
              fillColor: ColorApp.input_text,
              filled: true,
            ),
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            validator: (e) {
              if (e == null) {
                return 'ادخل التاريخ';
              }
              (e.day ?? 0) == 1 ? 'Please not the first day' : null;
              return null;
            },
            onDateSelected: (DateTime value) => function(value),
          )),
    );
  }

  static Widget InputText(
      {required TextEditingController controller,
      required String hint,
      String? title,
      required TextInputType textInputType,
      required Function(String value) function,
      IconData? icon,
      bool? readOnly,
      Function()? onClick}) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        children: [
          if (title != '')
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                title ?? '',
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
            readOnly: readOnly ?? false,
            controller: controller,
            validator: (value) => function(value!),
            textAlign: TextAlign.right,
            keyboardType: textInputType,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              isDense: true,
              fillColor: ColorApp.textField,
              filled: true,
              suffixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(.2),
                size: 23,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget InputText3(
      {required TextEditingController controller,
      required String hint,
      required TextInputType textInputType,
      required bool error,
      double? height,
      double? width,
      required Function(String value) function}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width ?? 150,
        height: height,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.right,
          keyboardType: textInputType,
          style: TextStyle(color: Colors.black, height: height),
          cursorColor: Colors.black,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(5),
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              errorText: error ? 'ادخل قيمة' : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(31),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black, fontSize: 13)),
        ),
      ),
    );
  }

  static Widget InputText2(
      {required TextEditingController controller,
      required String hint,
      required TextInputType textInputType,
      required Function(String value) function}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: SizedBox(
        width: 322,
        child: TextFormField(
          controller: controller,
          validator: (value) => function(value!),
          textAlign: TextAlign.right,
          keyboardType: textInputType,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
              isDense: true,
              fillColor: ColorApp.input_text,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(31),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none)),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  static Widget gradientButton(
      {required String text,
      required Function() function,
      double? height,
      double? width}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: height ?? 50,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xffE11717),
            Color(0xffDA552B),
          ]),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  static Widget Button(
      {required String text,
      required Function() function,
      double? height,
      double? width}) {
    return MaterialButton(
      onPressed: function,
      child: Container(
        height: height ?? 60,
        width: width ?? 322,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(31), color: ColorApp.darkRead),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  static Widget SelectionImage(
      {required Function() function,
      required String image,
      required String title}) {
    return GestureDetector(
      onTap: function,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              height: 128,
              width: 174,
              fit: BoxFit.cover,
              image: NetworkImage(image),
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }

  static Widget Item_account(
      {required Function() function,
      required String file,
      required String title}) {
    return GestureDetector(
      onTap: function,
      child: SizedBox(
        height: 60,
        width: 349,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child:
                          Image(height: 14, width: 20, image: AssetImage(file)),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Image(
              height: 5,
              width: 320,
              image: AssetImage('assets/images/line_item.png'),
            ),
          ],
        ),
      ),
    );
  }

  static Widget Item_group(
      {required String name,
      required String file,
      required Function() function}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
      child: Column(
        children: [
          GestureDetector(
            onTap: function,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(file),
                ),
              ],
            ),
          ),
          const Image(
            height: 15,
            width: double.infinity,
            image: AssetImage('assets/images/line_item.png'),
          ),
        ],
      ),
    );
  }

  static Widget Item_Alluser(
      {required String name,
      required String file,
      required Function() function}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
      child: Column(
        children: [
          GestureDetector(
            onTap: function,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(file),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  static Widget Item_Make_Video(
      {required Function() function,
      required String file,
      required String title}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 151,
        width: 151,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: const LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: [0.0, 100.0],
            colors: [
              ColorApp.blue,
              ColorApp.move,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(height: 72, width: 61, image: AssetImage(file)),
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }

  static Widget Item_ShopingViewItem(
      {double? height,
      double? width,
      required String file,
      required String title}) {
    return Container(
      height: height ?? 187,
      width: width ?? 157,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          stops: [0.0, 100.0],
          colors: [
            ColorApp.blue,
            ColorApp.move,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(height: 261, width: 183, image: NetworkImage(file)),
          Text(
            title,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }

  static Widget Item_Shoping(
      {double? height,
      double? width,
      required String file,
      required String title}) {
    return Container(
      height: height ?? 187,
      width: width ?? 157,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          stops: [0.0, 100.0],
          colors: [
            ColorApp.blue,
            ColorApp.move,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(height: 134, width: 94, image: NetworkImage(file)),
          Text(
            title,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }

  static Widget ButtonStyle(
      {required Function() function,
      required String text,
      required Color color,
      final Size? size}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: (size != null) ? size.height : 60,
        width: (size != null) ? size.width : 322,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
