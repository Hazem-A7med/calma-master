
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadek/presentation/screen/LiveStream/LiveForUser.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class make_video_page extends StatefulWidget {
  const make_video_page({Key? key}) : super(key: key);

  @override
  State<make_video_page> createState() => _make_video_pageState();
}

class _make_video_pageState extends State<make_video_page> {
  ImagePicker? _picker;
  File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _picker = ImagePicker();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اصنع تريندك الخاص'),
        leading:const Text(""),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorApp.black_400,

      ),
      body:Container(
        color: ColorApp.black_400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding (
              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
              child:Text('قم بانشاء الفيديو الخاص بك او البث المباشر ليظهر الان على التطبيق وتحصل على المتابعين ',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white
                ),
              ),

            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Component_App.Item_Make_Video(
                    file: 'assets/icons/ic_live.png',
                    title: 'اضافة بث مباشر',
                    function: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>LiveForUser()));
                    }

                ),
                SizedBox(width: 19,),
                Component_App.Item_Make_Video(
                  file: 'assets/icons/ic_gallery.png',
                  title: 'اضافة فيديو',
                  function: ()async{
                    Navigator.pushNamed(context, '/Upload_Video');
                  },
                ),

              ],
            )
          ],
        ),
      ) ,
    );
  }

}


