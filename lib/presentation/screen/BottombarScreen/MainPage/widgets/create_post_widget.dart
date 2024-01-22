import 'package:flutter/material.dart';

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({Key? key}) : super(key: key);

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: SizedBox(
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      TextField(
                                      enabled: false,
                                      decoration: InputDecoration(hintTextDirection: TextDirection.rtl,
                        hintText: 'ما الذي يدور في ذهنك,أحمد ؟',
                        hintStyle: TextStyle(
                            fontSize: 14, color: Colors.white.withOpacity(.4))),
                                    ),Container(height: 1,color: Colors.white.withOpacity(.4))
                    ],
                  )),
              SizedBox(
                width: 20,
              ),
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/front-view-woman-posing-futuristic-portrait_23-2151179031.jpg'),
              )
            ],
          ),
          Padding(
            padding:  EdgeInsets.only(bottom: 15.0,left: 17,right: 17,top: 25),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Row(children: [Text('المشاعر/الأنشطة',style: TextStyle(color: Colors.white.withOpacity(.3),fontSize: MediaQuery.of(context).size.width*.025)),
                SizedBox(width: 10,),
                Image.asset('assets/icons/smile.png',height: 20),],),
              Row(children: [Text('صورة / فيديو',style: TextStyle(color: Colors.white.withOpacity(.3),fontSize:  MediaQuery.of(context).size.width*.025)),
                SizedBox(width: 10,),
                Image.asset('assets/icons/image.png',height: 20),],),
              Row(children: [Text('بث مباشر',style: TextStyle(color: Colors.white.withOpacity(.3),fontSize:  MediaQuery.of(context).size.width*.025)),
                SizedBox(width: 10,),
                Image.asset('assets/icons/live.png',height: 17),],),

            ]),
          ),
          Container(width: double.infinity,height: 1,color: Colors.white.withOpacity(.4))
        ]),
      ),
    );
  }
}
