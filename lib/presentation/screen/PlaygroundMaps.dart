import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nadek/data/model/AllPlayground.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/DateAndTimePlayGraound.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:permission_handler/permission_handler.dart';

class PlaygroundMaps extends StatefulWidget {
  const PlaygroundMaps({super.key});

  @override
  State<PlaygroundMaps> createState() => _PlaygroundMapsState();
}

class _PlaygroundMapsState extends State<PlaygroundMaps> {
  static double? latit = 31.24855744664037;
  static double? long = 36.6919811752108;
  bool isLoading = true;
  String? token;
  CameraPosition? _kLake;
  List<Marker> _markers = <Marker>[];
  Iterable markers = [];
  String? photo;

  AllPlayground? model;

  Completer<GoogleMapController> _completer = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = CacheHelper.getString('tokens');
    photo = CacheHelper.getString('photo') != null
        ? CacheHelper.getString('photo').toString().replaceAll('\'', '')
        : 'https://calmaapp.com/default.png';
    print(photo);
    _goToTheLake();
    _getLocation();
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    AssetImage assetImage = AssetImage(imagePath);
    File imageFile = File(assetImage.assetName);
    Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  _getLocation() async {
    final LocationPermission permission = await Geolocator.requestPermission();
    final bool status = await Permission.location.serviceStatus.isEnabled;

    if (status &&
        (permission != LocationPermission.denied ||
            permission != LocationPermission.deniedForever ||
            permission != LocationPermission.unableToDetermine)) {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latit = position.latitude;
      long = position.longitude;
    }

    setState(() {
      isLoading = false;
    });
    _markers.add(Marker(
        icon: await MarkerIcon.downloadResizePictureCircle(
          photo!,
          size: 150,
          addBorder: true,
          borderColor: ColorApp.move,
          borderSize: 10,
        ),
        markerId: MarkerId('Mi_Location'),
        position: LatLng(
          latit ?? 31.24855744664037,
          long ?? 36.6919811752108,
        ),
        infoWindow: InfoWindow(
          title: 'موقعي',
        )));
    setState(() {
      _markers;
    });

    return;

    // if (await Permission.location.isPermanentlyDenied) {
    //   // The user opted to never again see the permission request dialog for this
    //   // app. The only way to change the permission's status now is to let the
    //   // user manually enable it in the system settings.
    //   print('openAppSettings');
    //
    //   openAppSettings();
    //
    //   Fluttertoast.showToast(
    //     msg: "اسمح لتطبيق الوصول الي الموقع",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //   );
    //   Navigator.pop(context);
    // } else {
    //   await [Permission.location, Permission.locationWhenInUse].request();
    //
    //   if (await Permission.location.isDenied) {
    //     openAppSettings();
    //
    //     Fluttertoast.showToast(
    //       msg: "اسمح لتطبيق الوصول الي الموقع",
    //       toastLength: Toast.LENGTH_LONG,
    //       gravity: ToastGravity.CENTER,
    //     );
    //     Navigator.pop(context);
    //   } else {
    //     if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
    //       // Use location.
    //       var location = Location();
    //       LocationData locationData = await location.getLocation();
    //       setState(() {
    //         latit = locationData.latitude!;
    //         long = locationData.longitude!;
    //         _goToTheLake();
    //         //isLoading = false;
    //       });
    //       _markers.add(Marker(
    //           icon: await MarkerIcon.downloadResizePictureCircle(
    //             photo!,
    //             size: 150,
    //             addBorder: true,
    //             borderColor: ColorApp.move,
    //             borderSize: 10,
    //           ),
    //           markerId: MarkerId('Mi_Location'),
    //           position: LatLng(
    //             locationData.latitude!,
    //             locationData.longitude!,
    //           ),
    //           infoWindow: InfoWindow(
    //             title: 'موقعي',
    //           )));
    //       setState(() {
    //         _markers;
    //       });
    //     } else {
    //       var location = Location();
    //       location.requestService().then((value) {
    //         if (value) {
    //           _getLocation();
    //         } else {
    //           Navigator.pop(context);
    //         }
    //       });
    //     }
    //   }
    // }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latit ?? 31.24855744664037, long ?? 36.6919811752108),
    zoom: 5,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NadekCubit, NadekState>(
        listener: (context, state) async {
          if (state is LoadedAllPlayground) {
            setState(() {
              model = state.allPlayground;
              //  print('Mostafaaaa: ${model!.status}');
              isLoading = false;
            });
            for (int i = 0; i < state.allPlayground.data!.length; i++) {
              double x = double.parse(model!.data![i].lat.toString());
              double y = double.parse(model!.data![i].lang.toString());

              print(y);
              _markers.add(
                Marker(
                  markerId: MarkerId(model!.data![i].iD.toString()),
                  infoWindow: InfoWindow(
                      title: model!.data![i].title,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => DateAndTimePlayGraound(
                                      play_ground_id:
                                          model!.data![i].iD!.toInt(),
                                    )));
                      }),
                  position: LatLng(x, y),
                  icon: await MarkerIcon.downloadResizePictureCircle(
                    model!.data![i].images!.image!,
                    size: 150,
                    addBorder: true,
                    borderColor: ColorApp.move,
                    borderSize: 10,
                  ),
                ),
              );
              setState(() {
                _markers;
              });
            }
          }
        },
        builder: (context, state) {
          return isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      markers: Set.from(_markers),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _completer.complete(controller);
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.transparent,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: model!.data!.length,
                            itemBuilder: (itemBuilder, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              DateAndTimePlayGraound(
                                                play_ground_id: model!
                                                    .data![index].iD!
                                                    .toInt(),
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    width: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorApp.black_400,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Image(
                                                  image: NetworkImage(model!
                                                      .data![index]
                                                      .images!
                                                      .image!),
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    color: ColorApp.darkRead,
                                                    child: Center(
                                                      child: Text(
                                                        model!.data![index]
                                                            .sportTypeId!,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        model!.data![index]
                                                            .expanse!,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        model!.data![index]
                                                            .title!,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                      ),
                                                      Text(
                                                        model!.data![index]
                                                            .ownerName!,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }

  Future<void> _goToTheLake() async {
    BlocProvider.of<NadekCubit>(context).getAllPlayground(token!, 1);
  }
}
