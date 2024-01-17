import 'package:flutter/material.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

Widget getAlbum(albumImg) {
  return Container(
    width: 50,
    height: 50,
    decoration: const BoxDecoration(
        // shape: BoxShape.circle,
        // color: black
        ),
    child: Stack(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        ),
        Center(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(albumImg), fit: BoxFit.cover)),
          ),
        )
      ],
    ),
  );
}

Widget getIcons(icon, count, size, Function() function) {
  return Container(
    child: Column(
      children: <Widget>[
        IconButton(
            onPressed: function,
            icon: Image(
                height: size,
                width: size,
                image: AssetImage(icon),
                color: Colors.white)),
        const SizedBox(
          height: 5,
        ),
        Text(
          count,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
        )
      ],
    ),
  );
}

Widget getIconsLike(
    {required icon,
    required count,
    required size,
    required Function() function}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(onPressed: function, icon: icon),
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
          child: Text(
            count,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        )
      ],
    ),
  );
}

Widget getProfile(img,
    {required Function() function, required Function() profileClick}) {
  return GestureDetector(
    onTap: profileClick,
    child: SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(img), fit: BoxFit.cover)),
          ),
          Positioned(
              bottom: 3,
              left: 18,
              child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: ColorApp.move),
                  child: GestureDetector(
                    onTap: function,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 10,
                    ),
                  )))
        ],
      ),
    ),
  );
}
