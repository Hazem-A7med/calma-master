import 'package:flutter/material.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/data/model/my_stories_model.dart';
import 'package:story_view/story_view.dart';

class MyStoryViewWidget extends StatefulWidget {
  const MyStoryViewWidget({Key? key, required this.listOfStories})
      : super(key: key);
  final List<Story> listOfStories;

  @override
  State<MyStoryViewWidget> createState() => _MyStoryViewWidgetState();
}

class _MyStoryViewWidgetState extends State<MyStoryViewWidget> {
  final storyController = StoryController();

  List<StoryItem> generateStoryItems(List<Story> listOfStories) {
    List<StoryItem> storyItems = [];

    for (var data in listOfStories) {
      StoryItem item;
      if (data.mediaType == 'photo') {
        item = StoryItem.pageImage(
          url: data.mediaPath!,
          caption: data.description,
          controller: storyController,
          duration: const Duration(seconds: 10),
        );
      } else if (data.mediaType == 'video') {
        item = StoryItem.pageVideo(
           data.mediaPath!,
          caption: data.description,
          controller: storyController,
          duration: const Duration(seconds: 10),
        );
      } else if (data.mediaType == 'text') {
        item = StoryItem.text(
          title: data.description ?? '',
          backgroundColor: Colors.white,
        );
      } else {
        throw Exception('Unsupported media type: ${data.mediaType}');
      }

      storyItems.add(item);
    }
    return storyItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.scaffold,
      body: StoryView(
        inline: false,
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