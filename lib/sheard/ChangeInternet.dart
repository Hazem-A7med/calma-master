
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ChangeInternet extends StatefulWidget {
  Widget child;
  Function(ConnectivityResult result) chanegedInternt;
  ChangeInternet({super.key,required this.chanegedInternt ,required this.child});

  @override
  State<ChangeInternet> createState() => _ChangeInternetState();
}

class _ChangeInternetState extends State<ChangeInternet> {
    var internet ;
  @override
  void initState() {
    // TODO: implement initState
    internet =Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      initData(result);
    });
    super.initState();

  }
  void initData(ConnectivityResult result)async{
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile
        || connectivityResult == ConnectivityResult.wifi
        || connectivityResult == ConnectivityResult.ethernet
        || connectivityResult == ConnectivityResult.vpn) {
      // I am connected to a mobile network or wifi or vpn or ethernet.
      widget.chanegedInternt(result);

    }
  }
  @override
  void dispose() {
    // TODO: implement dispose

    //internet.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return widget.child;
  }
}
