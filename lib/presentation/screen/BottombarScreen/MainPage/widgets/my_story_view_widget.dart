import 'package:flutter/material.dart';
import 'package:nadek/data/model/my_stories_model.dart';
import 'package:story_view/story_view.dart';

class MyStoryViewWidget extends StatefulWidget {
  const MyStoryViewWidget({Key? key, required this.listOfStories}) : super(key: key);
  final List<Story> listOfStories;

  @override
  State<MyStoryViewWidget> createState() => _MyStoryViewWidgetState();
}

class _MyStoryViewWidgetState extends State<MyStoryViewWidget> {
  final storyController = StoryController();

  List<StoryItem> generateStoryItems(List<Story> listOfStories) {
    List<StoryItem> storyItems = [];

    for (var data in listOfStories) {
      print(listOfStories.length);
      StoryItem item = StoryItem.pageImage(
        url: data.mediaPath!,
        caption: data.description,
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
      body:  StoryView(inline: false,
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
