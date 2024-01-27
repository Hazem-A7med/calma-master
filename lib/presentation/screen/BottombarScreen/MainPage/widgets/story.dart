import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryWidget extends StatefulWidget {
  const StoryWidget({Key? key}) : super(key: key);

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final storyController = StoryController();

  @override
  Widget build(BuildContext context) {
    return StoryView(
      storyItems: [
        StoryItem.text(
          title: "I guess you'd love to see more of our food. That's great.",
          backgroundColor: Colors.blue,
        ),
        StoryItem.text(
          title: "Nice!\n\nTap to continue.",
          backgroundColor: Colors.red,
          textStyle: const TextStyle(
            fontFamily: 'Dancing',
            fontSize: 40,
          ),
        ),
        StoryItem.pageImage(
          url:
          "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
          caption: "Still sampling",
          controller: storyController,
        ),
        StoryItem.pageImage(
            url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
            caption: "Working with gifs",
            controller: storyController),
        StoryItem.pageImage(
          url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
          caption: "Hello, from the other side",
          controller: storyController,
        ),
        StoryItem.pageImage(
          url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
          caption: "Hello, from the other side2",
          controller: storyController,
        ),
      ],
      onStoryShow: (s) {
        print("Showing a story");
      },
      onComplete: () {
        print("Completed a cycle");
      },
      progressPosition: ProgressPosition.top,
      repeat: false,
      controller: storyController,

    );
  }
}
