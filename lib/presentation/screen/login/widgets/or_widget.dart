import 'package:flutter/material.dart';

class OrWidget extends StatefulWidget {
  const OrWidget({Key? key}) : super(key: key);

  @override
  State<OrWidget> createState() => _OrWidgetState();
}

class _OrWidgetState extends State<OrWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width * .35,
            color: Colors.white.withOpacity(.2),
          ),
          Text('أو',
              style:
                  TextStyle(color: Colors.white.withOpacity(.2), fontSize: 16)),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width * .35,
            color: Colors.white.withOpacity(.2),
          ),
        ],
      ),
    );
  }
}
