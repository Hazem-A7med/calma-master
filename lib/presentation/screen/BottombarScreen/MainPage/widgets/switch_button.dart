import 'package:flutter/material.dart';


class TapBarWidget extends StatefulWidget {
  const TapBarWidget({Key? key}) : super(key: key);

  @override
  State<TapBarWidget> createState() => _TapBarWidgetState();
}

class _TapBarWidgetState extends State<TapBarWidget> {
  double width = 300.0;
  double height = 60.0;
  double loginAlign = -1;
  double signInAlign = 1;
  Color selectedColor = Colors.white;
  Color normalColor =  Colors.white;

  late double xAlign;
  late Color loginColor;
  late Color signInColor;

  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(xAlign, 0),
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: width * 0.5,
                height: height,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // Provider.of<ClosedTradesProvider>(context, listen: false)
                  //     .changeTapBarIndex(0);
                  xAlign = loginAlign;
                  loginColor = selectedColor;
                  signInColor = normalColor;
                });
              },
              child: Align(
                alignment: const Alignment(-1, 0),
                child: Container(
                  width: width * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    'yyyyy',
                    style: TextStyle(
                      color: loginColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // Provider.of<ClosedTradesProvider>(context, listen: false)
                  //     .changeTapBarIndex(1);
                  xAlign = signInAlign;
                  signInColor = selectedColor;

                  loginColor = normalColor;
                });
              },
              child: Align(
                alignment: const Alignment(1, 0),
                child: Container(
                  width: width * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    'llll',
                    style: TextStyle(
                      color: signInColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
