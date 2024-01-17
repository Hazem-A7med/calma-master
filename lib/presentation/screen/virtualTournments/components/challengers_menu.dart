import 'package:flutter/material.dart';
import 'package:nadek/data/model/Challenger.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class ChallengersMenu extends StatelessWidget {
  const ChallengersMenu(
      {Key? key,
      required this.challengers,
      required this.onAccept,
      required this.onClose})
      : super(key: key);
  final List<Challenger> challengers;
  final void Function(Challenger challenger) onAccept;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    for (int i = 0; i < challengers.length; i++) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              onAccept(challengers.elementAt(i));
                            },
                            child: const Text(
                              textDirection: TextDirection.rtl,
                              'قبول التحدى',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          Text(
                            challengers.elementAt(i).challenger,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
