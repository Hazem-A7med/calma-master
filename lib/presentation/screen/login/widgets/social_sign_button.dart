import 'package:flutter/material.dart';

class SocialSignButton extends StatefulWidget {
  const SocialSignButton({Key? key, required this.image, required this.txt, required this.onTab}) : super(key: key);
final String image;
final String txt;
final Function() onTab;
  @override
  State<SocialSignButton> createState() => _SocialSignButtonState();
}

class _SocialSignButtonState extends State<SocialSignButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(onTap: widget.onTab,
        child: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border:
                    Border.all(width: 1.5, color: Colors.white.withOpacity(.2)),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.txt,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.3),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 13),
                Image.asset(
                  'assets/icons/${widget.image}.png',
                  width: 30,
                  height: 30,
                )
              ],
            )),
      ),
    );
  }
}
