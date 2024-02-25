import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class FirstIconsRow extends StatefulWidget {
  const FirstIconsRow({Key? key}) : super(key: key);

  @override
  State<FirstIconsRow> createState() => _FirstIconsRowState();
}

class _FirstIconsRowState extends State<FirstIconsRow> {
  shareLink() async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final data = await rootBundle.load('assets/images/logo.png');
    final buffer = data.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'Calma',
          mimeType: 'image/png',
        ),
      ],
      subject: 'الابليكيشن الاول في الوطن العربي الخاص بالرياضه',
      text: 'store link',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
          onTap: () => shareLink(),
          child: Image.asset('assets/icons/Group 174.png', width: 35),
        ),
       // Image.asset('assets/icons/Group 171.png', width: 35),
        Image.asset('assets/icons/Group 170.png', width: 35),
        Image.asset('assets/icons/Group 168.png', width: 35),
      ]),
    );
  }
}
