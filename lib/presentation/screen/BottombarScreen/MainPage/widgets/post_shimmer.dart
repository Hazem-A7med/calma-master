import 'package:flutter/material.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/post_item.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmer extends StatelessWidget {
  const PostShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white,
        child: const Column(
          children: [
            PostItem(),
            PostItem(),
          ],
        ));
  }
}
