import 'package:flutter/material.dart';

import 'gradient_text.dart';

class RegisterCheckRow extends StatefulWidget {
  RegisterCheckRow({Key? key, required this.isChecked}) : super(key: key);
  bool isChecked;
  @override
  State<RegisterCheckRow> createState() => _RegisterCheckRowState();
}

class _RegisterCheckRowState extends State<RegisterCheckRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Row(
          children: [
            const GradientText(
              'أوافق على شروط وسياسة الخصوصية',
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
