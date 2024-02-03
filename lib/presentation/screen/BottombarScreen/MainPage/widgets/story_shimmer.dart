import 'package:flutter/material.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/post_item.dart';
import 'package:nadek/presentation/screen/BottombarScreen/MainPage/widgets/story_item.dart';
import 'package:shimmer/shimmer.dart';

class StoryShimmer extends StatelessWidget {
  const StoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.black12,
        highlightColor: Colors.white,
        child: ListView.separated(scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) =>
                const StoryItem(name: '', image: ''),
            separatorBuilder: (context, index) => const SizedBox(width: 10,),
            itemCount: 5));
  }
}
