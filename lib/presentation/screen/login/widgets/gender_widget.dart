import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenderWidget extends StatefulWidget {
  const GenderWidget(
      {Key? key, required this.isMale, required this.malePress, required this.feMalePress})
      : super(key: key);
  final bool isMale;
  final Function() malePress;
  final Function() feMalePress;

  @override
  State<GenderWidget> createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'أنثي',
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(.4)),
          ),
          const SizedBox(
            width: 7,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                widget.feMalePress();
              });
            },
            child: SizedBox(
                child: (!widget.isMale)
                    ? Image.asset(
                        'assets/icons/checked.png',
                        width: 12,
                      )
                    : Image.asset(
                        'assets/icons/unchecked.png',
                        width: 12,
                      )),
          ),
          const SizedBox(
            width: 40,
          ),



          Text(
            'ذكر',
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(.4)),
          ),
          const SizedBox(
            width: 7,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                widget.malePress();
              });
            },
            child: SizedBox(
                child: (widget.isMale)
                    ? Image.asset(
                        'assets/icons/checked.png',
                        width: 12,
                      )
                    : Image.asset(
                        'assets/icons/unchecked.png',
                        width: 12,
                      )),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            ': الجنس',
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(.4)),
          ),
        ],
      ),
    );
  }
}
