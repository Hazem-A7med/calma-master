import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class SportsGridItem extends StatefulWidget {
  const SportsGridItem(
      {Key? key,
      required this.imagePath,
      required this.name,
      required this.isSelected,
      required this.onTab})
      : super(key: key);
  final String imagePath;
  final String name;
  final Function() onTab;
  final bool isSelected;

  @override
  State<SportsGridItem> createState() => _SportsGridItemState();
}

class _SportsGridItemState extends State<SportsGridItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTab,
      child: Container(padding: EdgeInsets.all((widget.isSelected)?1:0),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffE11717),
                Color(0xffDA552B),
              ]),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: AppColors.scaffold,
              border: Border.all(width: 1, color: Colors.white12)),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Image.network(widget.imagePath, height: 70),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white.withOpacity(.4), fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
