import 'package:flutter/material.dart';
import 'package:nadek/data/model/all_stories_model.dart';
import 'package:nadek/data/model/my_stories_model.dart';
import 'package:story_view/story_view.dart';

class AllStoryViewWidget extends StatefulWidget {
  const AllStoryViewWidget({Key? key, required this.listOfStories}) : super(key: key);
  final List<AllStories> listOfStories;

  @override
  State<AllStoryViewWidget> createState() => _AllStoryViewWidgetState();
}

class _AllStoryViewWidgetState extends State<AllStoryViewWidget> {
  final storyController = StoryController();

  List<StoryItem> generateStoryItems(List<AllStories> listOfStories) {
    List<StoryItem> storyItems = [];

    for (var data in listOfStories) {
      print(listOfStories.length);
      StoryItem item = StoryItem.pageImage(
        url: data.mediaPath!,
        caption: data.text,
        controller: storyController,duration: const Duration(seconds: 10),
      );
      storyItems.add(item);
      print(item.duration);
    }
    return storyItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  StoryView(inline: true,
        storyItems: generateStoryItems(widget.listOfStories),
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
          Navigator.pop(context);
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
