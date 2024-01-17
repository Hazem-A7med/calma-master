import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/data/model/TournamentDetailsModel.dart';
import 'package:nadek/data/model/TournamentsMode.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/Pay/PaypalPayment.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class TournamentPage extends StatefulWidget {
  int id;

  TournamentPage({
    super.key,
    required this.id,
  });

  @override
  State<TournamentPage> createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> {
  bool waiting = true;
  bool isLoading = false;
  TournamentDetailsModel? detailsModel;

  TournamentsMode? mode;
  List<dynamic> d = <dynamic>[];
  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = CacheHelper.getString('tokens');
    BlocProvider.of<NadekCubit>(context).getTournamentDetails(token!, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        title: const Text(
          'البطولات الواقعية',
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<NadekCubit, NadekState>(listener: (context, state) {
        if (state is LoadedTournamentDetails) {
          BlocProvider.of<NadekCubit>(context).getTournamentsMode(token!, 1);
          setState(() {
            waiting = false;
            detailsModel = state.model;
          });
        }
        if (state is LoadedTournamentList) {
          print(state.mode);
          setState(() {
            mode = state.mode;
            mode!.data!.map((e) => d.add(e)).toList();
          });
        }
      }, builder: (context, state) {
        return waiting
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  card1(
                      function: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) {
                          return PaypalPayment(onFinish: (onFinish) {
                            print(onFinish);
                          });
                        }));
                      },
                      typeSport: detailsModel!.data!.sportTypeId!,
                      title: detailsModel!.data!.title!,
                      subTitle: detailsModel!.data!.description!,
                      totalSubScr: detailsModel!.data!.minimumAge!,
                      age: detailsModel!.data!.minimumAge!,
                      sex: detailsModel!.data!.gender!,
                      s: detailsModel!.data!.gift!,
                      price: "السعر ${detailsModel!.data!.price}",
                      dateStart: detailsModel!.data!.dateStart!),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "مقترح من اجلك",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: d.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (itemBuilder, index) {
                      return card(
                          id: d[index].iD!,
                          typeSport: d[index].sportTypeId!,
                          title: "${d[index].title} .",
                          subTitle: d[index].description!,
                          totalSubScr: d[index].minimumAge!,
                          age: d[index].minimumAge!,
                          sex: d[index].gender!,
                          s: d[index].gift!,
                          price: d[index].price.toString(),
                          dateStart: d[index].dateStart.toString());
                    },
                  ),
                ],
              ));
      }),
    );
  }

  Widget card1(
      {required Function() function,
      required String typeSport,
      required String title,
      required String subTitle,
      required int totalSubScr,
      required int age,
      required String sex,
      required String s,
      required String price,
      required String dateStart}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        typeSport,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: function,
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorApp.darkRead,
                                borderRadius: BorderRadius.circular(10)),
                            height: 45,
                            width: 150,
                            child: const Center(
                              child: Text(
                                "تواصل الان ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      subTitle,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "عدد المشاركين :$totalSubScr",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "الحد الأدنى للعمر : $age",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "الجنس : $sex",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "الجائزة : $s",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "تبدا المبارة :$dateStart",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget card(
      {required int id,
      required String typeSport,
      required String title,
      required String subTitle,
      required int totalSubScr,
      required int age,
      required String sex,
      required String s,
      required String price,
      required String dateStart}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        typeSport,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => TournamentPage(
                                      id: id,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorApp.darkRead,
                            borderRadius: BorderRadius.circular(10)),
                        height: 30,
                        width: 150,
                        child: const Center(
                          child: Text(
                            "عرض الاشتراك",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      subTitle,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "عدد المشاركين :$totalSubScr",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "الحد الأدنى للعمر : $age",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "الجنس : $sex",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "الجائزة : $s",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
