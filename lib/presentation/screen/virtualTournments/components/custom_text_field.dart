import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required TextEditingController channelName,
    required this.label,
    this.onTap,
  }) : _channelNameController = channelName;

  final TextEditingController _channelNameController;
  final String label;
  final Function(String value)? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        onSubmitted: onTap,
        controller: _channelNameController,
        textAlign: TextAlign.right,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(31),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
            ),
            hintText: label,
            hintStyle: const TextStyle(color: Colors.black, fontSize: 15)),
      ),
    );
  }
}
