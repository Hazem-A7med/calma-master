import 'package:flutter/material.dart';

class SecIconsRow extends StatefulWidget {
  const SecIconsRow({Key? key}) : super(key: key);

  @override
  State<SecIconsRow> createState() => _SecIconsRowState();
}

class _SecIconsRowState extends State<SecIconsRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0,left: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Image.asset('assets/icons/hand.png',
                  width: 25),Image.asset('assets/icons/share.png',
                  width: 25),Image.asset('assets/icons/video.png',
                  width: 25),Image.asset('assets/icons/edit.png',
                  width: 25),
            ]),
          ),
          SizedBox(height: 10,),Divider(height: 1,color: Colors.white.withOpacity(.3),),
        ],
      ),
    );
  }
}
