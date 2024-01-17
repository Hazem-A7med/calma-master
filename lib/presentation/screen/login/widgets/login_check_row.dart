import 'package:flutter/material.dart';

import 'gradient_text.dart';

class LoginCheckRow extends StatefulWidget {
   LoginCheckRow({Key? key, required this.isChecked}) : super(key: key);
 bool isChecked;
  @override
  State<LoginCheckRow> createState() => _LoginCheckRowState();
}

class _LoginCheckRowState extends State<LoginCheckRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        const GradientText(
          'هل نسيت كلمة المرور ؟',
          style: TextStyle(fontSize: 11),
          gradient: LinearGradient(colors: [
            Color(0xffE11717),
            Color(0xffDA552B),
          ]),
        ),
        Row(
          children: [
            const GradientText(
              'هل تذكرني ؟',
              style: TextStyle(fontSize: 11),
              gradient: LinearGradient(colors: [
                Color(0xffE11717),
                Color(0xffDA552B),
              ]),
            ),
            const SizedBox(width: 7,),
            GestureDetector(onTap: () {
              setState(() {
                widget.isChecked=!widget.isChecked;
              });
            },
              child: SizedBox(
                  child: (widget.isChecked)?Image.asset('assets/icons/checked.png',width: 12,):Image.asset('assets/icons/unchecked.png',width: 12,)
              ),
            )
          ],
        ),
      ],
    );
  }
}
