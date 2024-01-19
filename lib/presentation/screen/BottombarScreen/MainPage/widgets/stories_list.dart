import 'package:flutter/material.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class StoriesList extends StatefulWidget {
  const StoriesList({Key? key}) : super(key: key);

  @override
  State<StoriesList> createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 115,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => SizedBox(width: 82,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                        decoration:  BoxDecoration(boxShadow: List.filled(1, BoxShadow(color: Colors.white38.withOpacity(.3),blurRadius: 3,spreadRadius: 1)),
                            shape: BoxShape.circle,border: Border.all(color: Color(0xffE11717),width: 5,),
                            color: Colors.white),
                        height: 80,
                        width: 80),
                  ),
                  const Text('Ahmad Moe',overflow: TextOverflow.ellipsis,style: TextStyle(color: Color(0xffE11717),fontSize: 12),)
                ],
              ),
            ),
            separatorBuilder: (context, index) =>
                const SizedBox(width: 20,),
            itemCount: 20));
  }
}
