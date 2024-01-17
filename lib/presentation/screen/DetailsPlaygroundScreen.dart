import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nadek/data/model/DetailsPlayground.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/Pay/PaypalServices.dart';
import 'package:nadek/sheard/ChangeInternet.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/constante/string.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPlaygroundScreen extends StatefulWidget {
  int play_ground_id;
  String date;

  DetailsPlaygroundScreen(
      {super.key, required this.play_ground_id, required this.date});

  @override
  State<DetailsPlaygroundScreen> createState() =>
      _DetailsPlaygroundScreenState();
}

class _DetailsPlaygroundScreenState extends State<DetailsPlaygroundScreen> {
  String? token;
  late DetailsPlayground p;
  List<ReservationTimeOpen> list = [];
  bool waiting = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = CacheHelper.getString('tokens');
    BlocProvider.of<NadekCubit>(context)
        .getDetailsPlayground(token!, widget.play_ground_id, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        backgroundColor: ColorApp.black_400,
        elevation: 5,
        title: const Text('تفاصيل الملعب'),
        centerTitle: true,
      ),
      body: ChangeInternet(
        chanegedInternt: (f) {
          BlocProvider.of<NadekCubit>(context)
              .getDetailsPlayground(token!, widget.play_ground_id, widget.date);
        },
        child: BlocConsumer<NadekCubit, NadekState>(
          listener: (context, state) {
            if (state is LoadedReservation) {
              setState(() {
                Fluttertoast.showToast(
                  msg: '${state.reservation.msg}',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
                waiting = false;
                Navigator.pop(context);
              });
            }

            if (state is LoadedDetailsPlayground) {
              setState(() {
                p = state.detailsPlayground;
                p.data!.reservationTimeOpen!.map((e) => list.add(e)).toList();
                waiting = false;
              });
            }
          },
          builder: (context, state) {
            return waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: Image(
                                image: NetworkImage('${p.data!.images!.image}'),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${p.data!.ownerName}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${p.data!.title}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "${p.data!.sportTypeId}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "${p.data!.expanse}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "${p.data!.price}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "${p.data!.details}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Uri url = Uri.parse("${p.data!.location}");
                                  // _launchUrl(url);
                                  Share.share(
                                      'ملعب ${p.data!.title} \n موقع الملعب $url \n يمكنك تحميل تطبيق ناديك لحجز ملعبك ومشاركته مع الجميع \n ${string_app.nadekplayStore}');
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5 -
                                          20,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: ColorApp.darkRead,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                      child: Text(
                                    "مشاركة الملعب",
                                    style: TextStyle(color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Uri url =
                                            Uri.parse("${p.data!.location}");
                                        _launchUrl(url);
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: ColorApp.darkRead,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                            child: Text(
                                          "عرض موقع الملعب",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        _launchCaller("${p.data!.mobile}");
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: ColorApp.darkRead,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                            child: Text(
                                          "اتصال",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "مـواعـيـد مـتـاحـة",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            list.isEmpty
                                ? const Center(
                                    child: Text(
                                      'لا يوجد مواعيد متاحة',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (itemBuilder, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              color: ColorApp.back1,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "${list[index].date}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          " ${list[index].timeFrom} :من  ",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: .5,
                                                          width: 100,
                                                          color: Colors.white60,
                                                        ),
                                                        Text(
                                                          "  ${list[index].timeTo} :الي  ",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    const price = '10.0';

                                                    PaypalServices.payout(
                                                      context: context,
                                                      price: price,
                                                      items: [
                                                        {
                                                          "name":
                                                              "reservation playground",
                                                          "quantity": 1,
                                                          "price": price,
                                                          "currency": "USD"
                                                        },
                                                      ],
                                                      onError: () {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              'تم الغاء العملية',
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                        );
                                                      },
                                                      onSuccess: () {
                                                        BlocProvider.of<
                                                                    NadekCubit>(
                                                                context)
                                                            .postReservation(
                                                                token!,
                                                                widget
                                                                    .play_ground_id,
                                                                p
                                                                    .data!
                                                                    .reservationTimeOpen![
                                                                        index]
                                                                    .id!);
                                                        setState(() {
                                                          waiting = true;
                                                        });
                                                      },
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Container(
                                                      width: 150,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              ColorApp.darkRead,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: const Center(
                                                          child: Text(
                                                        "حـجـز",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                          ],
                        )
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchCaller(String num) async {
    var url = "tel:$num";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
