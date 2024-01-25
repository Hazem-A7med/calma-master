import 'package:flutter/material.dart';

class FirstIconsRow extends StatefulWidget {
  const FirstIconsRow({Key? key}) : super(key: key);

  @override
  State<FirstIconsRow> createState() => _FirstIconsRowState();
}

class _FirstIconsRowState extends State<FirstIconsRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70,vertical: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Image.asset('assets/icons/Group 174.png',
            width: 35),Image.asset('assets/icons/Group 171.png',
            width: 35),Image.asset('assets/icons/Group 170.png',
            width: 35),Image.asset('assets/icons/Group 168.png',
            width: 35),
      ]),
    );
  }
}
