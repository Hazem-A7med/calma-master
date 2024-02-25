import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key, required this.image});
final String image;
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Set it to false
          //boundaryMargin: EdgeInsets.all(100),
          minScale: 1,
          maxScale: 2,constrained: true,
          child: Image.network(
            widget.image,
            // width: 200,
            // height: 200,
       //     fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}

