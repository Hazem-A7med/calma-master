import 'package:flutter/material.dart';

class StoryItem extends StatefulWidget {
  const StoryItem({Key? key, required this.name, required this.image})
      : super(key: key);
  final String name;
  final String image;

  @override
  State<StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xffE11717),
                child: Center(
                    child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(widget.image),
                ))),
          ),
          Text(
            widget.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xffE11717), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
