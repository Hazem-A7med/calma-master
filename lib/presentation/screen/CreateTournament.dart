import 'dart:ffi';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nadek/data/model/sports.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/virtualTournments/live_page.dart';
import 'package:nadek/presentation/screen/virtualTournments/virtual_methods.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateTournament extends StatefulWidget {
  const CreateTournament({super.key});

  @override
  State<CreateTournament> createState() => _CreateTournamentState();
}

class _CreateTournamentState extends State<CreateTournament> {
  bool isLoadeing = true;

  late String controllerTypeTournament;

  late String controllerTypeSub;

  var controllerPrice = TextEditingController();
  var controllerTypeSport = TextEditingController();

  var controllerNameTournament = TextEditingController();
  var controllerTotalSub = TextEditingController();

  var controllerUnderAge = TextEditingController();
  late String controllerGender;

  var controllerChampionshipAward = TextEditingController();
  var controllerDateTournament = TextEditingController();

  var controllerNumberPhone = TextEditingController();
  var controllerDescription = TextEditingController();

  bool statusValueSub = false;
  bool statusTypeSport = false;

  bool statusNameTournament = false;
  bool statusTotalSub = false;

  bool statusUnderAge = false;

  bool statusStartTournament = false;
  bool statusGift = false;
  bool statusNumberPhone = false;
  bool statusDesc = false;

  String _SelectdType = 'اختر نوع الرياضة';
  int type_sportId = 0;
  sports? s;

  String? token;
  int tagTournament = 1;
  List<String> typeTournament = ['افتراضية', 'واقعية'];
  int tagSub = 1;
  List<String> typeSub = ['مجانا', 'مدفوعة'];
  int tagGender = 1;
  List<String> typeGender = ['انثي', 'ذكر'];
  void GetData() {
    if (typeTournament[tagTournament] == 'افتراضية') {
      controllerTypeTournament = 'virtual';
    } else {
      controllerTypeTournament = 'real';
    }
    if (typeSub[tagSub] == 'مجانا') {
      controllerTypeSub = 'free';
    } else {
      controllerTypeSub = 'paid';
    }
    if (typeGender[tagGender] == 'ذكر') {
      controllerGender = 'male';
    } else {
      controllerGender = 'female';
    }
    if (controllerPrice.text.isEmpty) {
      setState(() {
        statusValueSub = true;
      });
      return;
    }
    if (controllerNameTournament.text.isEmpty) {
      setState(() {
        statusNameTournament = true;
      });
      return;
    }
    if (controllerTotalSub.text.isEmpty) {
      setState(() {
        statusTotalSub = true;
      });
      return;
    }
    if (controllerUnderAge.text.isEmpty) {
      setState(() {
        statusUnderAge = true;
      });
      return;
    }
    if (controllerDateTournament.text.isEmpty) {
      setState(() {
        statusStartTournament = true;
      });
      return;
    }
    if (controllerChampionshipAward.text.isEmpty) {
      setState(() {
        statusGift = true;
      });
      return;
    }
    if (controllerNumberPhone.text.isEmpty) {
      setState(() {
        statusNumberPhone = true;
      });
      return;
    }
    if (controllerDescription.text.isEmpty) {
      setState(() {
        statusDesc = true;
      });
      return;
    }
    setState(() {
      isLoadeing = true;
    });
    BlocProvider.of<NadekCubit>(context).PostTournamentsModel(
        token: token!,
        type: controllerTypeTournament,
        payment: controllerTypeSub,
        typesportid: type_sportId,
        price: controllerPrice.text.toString(),
        name: controllerNameTournament.text.toString(),
        number_participants: controllerTotalSub.text.toString(),
        minimum_age: controllerUnderAge.text,
        gender: controllerGender.toString(),
        gift: controllerChampionshipAward.text.toString(),
        date_start: controllerDateTournament.text.toString(),
        description: controllerDescription.text.toString(),
        mobile: controllerNumberPhone.text.toString(),
        title: controllerNameTournament.text.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = CacheHelper.getString('tokens');
    BlocProvider.of<NadekCubit>(context).getSports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        title: const Text(
          'انشاء بطولة  الان',
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<NadekCubit, NadekState>(
        listener: (context, state) {
          if (state is LoadedPostTournaments) {
            Fluttertoast.showToast(
              msg: '${state.addTournament.msg}',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
            Navigator.pop(context);
          }
          if (state is LoadedDataSports) {
            setState(() {
              s = state.s;
              isLoadeing = false;
              _SelectdType = s!.data![0].title.toString();
              type_sportId = s!.data![0].id!.toInt();
            });
          }
        },
        builder: (context, state) => isLoadeing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(),
                      if (tagTournament == 0) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "اسم البطولة",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Component_App.InputText3(
                                controller: controllerNameTournament,
                                hint: 'اسم البطولة',
                                textInputType: TextInputType.text,
                                error: statusNameTournament,
                                function: (j) {}),
                          ],
                        )
                      ],
                      const Text(
                        "اختر نوع البطولة",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      ChipsChoice<int>.single(
                        value: tagTournament,
                        choiceCheckmark: true,
                        choiceStyle: C2ChipStyle.filled(
                          color: Colors.white,
                          checkmarkColor: Colors.blue,
                          foregroundStyle: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            tagTournament = val;
                          });
                          print(tagTournament);
                        },
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: typeTournament,
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                      ),
                      if (tagTournament == 1) ...[
                        const Text(
                          "اختر نوع الاشتراك",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        ChipsChoice<int>.single(
                          value: tagSub,
                          choiceCheckmark: true,
                          choiceStyle: C2ChipStyle.filled(
                            color: Colors.white,
                            checkmarkColor: Colors.blue,
                            foregroundStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (val) => setState(() => tagSub = val),
                          choiceItems: C2Choice.listFrom<int, String>(
                            source: typeSub,
                            value: (i, v) => i,
                            label: (i, v) => v,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "نوع الرياضية",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      color: Colors.white),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: DropdownButton(
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        menuMaxHeight: 300,
                                        underline: Container(),
                                        items: s?.data?.map((value) {
                                          return DropdownMenuItem<int>(
                                            value: value.id,
                                            child: Text(
                                              value.title!,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Text(
                                          _SelectdType,
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        onChanged: (int? value) {
                                          setState(() {
                                            type_sportId = s!
                                                .data![value!.toInt() - 1].id!
                                                .toInt();
                                            //type_sportId =value!.toInt();

                                            _SelectdType = s!
                                                .data![value.toInt() - 1].title
                                                .toString();

                                            print(type_sportId);
                                          });
                                        }),
                                  ),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "ادخل قيمة الاشتراك",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Component_App.InputText3(
                                    controller: controllerPrice,
                                    hint: 'قيمة الاشتراك',
                                    textInputType: TextInputType.number,
                                    error: statusValueSub,
                                    function: (j) {}),
                              ],
                            ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "عدد المشاركين",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Component_App.InputText3(
                                    controller: controllerTotalSub,
                                    hint: 'عدد المشاركين',
                                    textInputType: TextInputType.number,
                                    error: statusTotalSub,
                                    function: (j) {}),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "اسم البطولة",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Component_App.InputText3(
                                    controller: controllerNameTournament,
                                    hint: 'اسم البطولة',
                                    textInputType: TextInputType.text,
                                    error: statusNameTournament,
                                    function: (j) {}),
                              ],
                            ))
                          ],
                        ),
                        const Text(
                          "الجنس",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        ChipsChoice<int>.single(
                          value: tagGender,
                          choiceCheckmark: true,
                          choiceStyle: C2ChipStyle.filled(
                            color: Colors.white,
                            checkmarkColor: Colors.blue,
                            foregroundStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onChanged: (val) => setState(() => tagGender = val),
                          choiceItems: C2Choice.listFrom<int, String>(
                            source: typeGender,
                            value: (i, v) => i,
                            label: (i, v) => v,
                          ),
                        ),
                        const Text(
                          "الحد الأدنى للعمر",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Component_App.InputText3(
                            controller: controllerUnderAge,
                            hint: 'الحد الأدنى للعمر',
                            textInputType: TextInputType.number,
                            error: statusUnderAge,
                            function: (j) {}),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "جائزة البطولة",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Component_App.InputText3(
                                    controller: controllerChampionshipAward,
                                    hint: 'جائزة البطولة',
                                    textInputType: TextInputType.number,
                                    error: statusGift,
                                    function: (j) {}),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "وقت بدء البطوله ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Component_App.InputText3(
                                    controller: controllerDateTournament,
                                    hint: 'حدد اليوم والوقت',
                                    textInputType: TextInputType.text,
                                    error: statusStartTournament,
                                    function: (j) {}),
                              ],
                            ))
                          ],
                        ),
                        const Text(
                          "رقم التواصل  ",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Component_App.InputText3(
                            controller: controllerNumberPhone,
                            hint: '20XXXXXXX',
                            textInputType: TextInputType.number,
                            error: statusNumberPhone,
                            width: 260,
                            function: (j) {}),
                        const Text(
                          "وصف البطوله  ",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 300,
                          height: 200,
                          child: TextField(
                            controller: controllerDescription,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3, // <-- SEE HERE
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                fillColor: Colors.white,
                                filled: true,
                                isDense: true,
                                errorText: statusDesc ? 'ادخل قيمة' : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(31),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                hintText:
                                    'اكتب اسم الملعب او المكان او\n أي تفاصيل حول البطولة',
                                hintStyle: const TextStyle(
                                    color: Colors.black, fontSize: 15)),
                          ),
                        ),
                      ],
                      GestureDetector(
                        onTap: () async {
                          if (tagTournament == 0) {
                            if (defaultTargetPlatform ==
                                TargetPlatform.android) {
                              await [Permission.microphone, Permission.camera]
                                  .request();
                            }
                            if (controllerNameTournament.text.isEmpty) return;
                            FocusManager.instance.primaryFocus?.unfocus();
                            final userId = CacheHelper.getString('Id');

                            final result = await createVirtualTournment(
                                controllerNameTournament.text,
                                userId ?? 99999.toString());

                            if (result) {
                              final encodedChannelName = stringToBase64
                                  .encode(controllerNameTournament.text);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LivePage(
                                        encodedChannelName, true, true),
                                  ));
                            }
                          } else {
                            GetData();
                          }
                        },
                        child: Container(
                            width: 340,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorApp.darkRead),
                            child: const Center(
                                child: Text(
                              'تأكيد النشاء',
                              style: TextStyle(color: Colors.white),
                            ))),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
