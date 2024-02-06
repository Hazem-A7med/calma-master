import '../../../../core/utils/app_colors.dart';
import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadek/data/model/sports.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/sheard/component/component.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class CreateChampions extends StatefulWidget {
  const CreateChampions({super.key});

  @override
  State<CreateChampions> createState() => _CreateChampionsState();
}

class _CreateChampionsState extends State<CreateChampions> {
  int tagClubs = 0;
  List<String> typeClubs = ['رابطه مشجعين', 'اكاديمية', 'نادي'];
  int tagSub = 0;
  List<String> typeSub = ['غير مختلط', 'مختلط'];
  String _SelectdType = 'اختر نوع الرياضة';
  int type_sportId = 0;
  sports? s;
  bool isLoadeing = true;
  String? token;
  bool statusNameClubs = false;
  ImagePicker? _picker;
  File? image;
  String? path;

  var controlNameClubs = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _picker = ImagePicker();
    token = CacheHelper.getString('tokens');
    BlocProvider.of<NadekCubit>(context).getSports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        title: Text('انشاء نادي جديد'),
        centerTitle: true,
        backgroundColor: ColorApp.black_400,
        elevation: 0,
      ),
      body: BlocConsumer<NadekCubit, NadekState>(
        listener: (context, state) {
          if (state is LoadedAddClub) {
            Fluttertoast.showToast(
              msg: '${state.addClub.msg}',
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
                child: CircularProgressIndicator(color: AppColors.mainColor),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(),
                      const Text(
                        "اختر نوع البطولة",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      ChipsChoice<int>.single(
                        value: tagClubs,
                        choiceCheckmark: true,
                        choiceStyle: C2ChipStyle.filled(
                          color: Colors.white,
                          checkmarkColor: Colors.blue,
                          foregroundStyle: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (val) => setState(() => tagClubs = val),
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: typeClubs,
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                      ),
                      const Text(
                        "نوع المشتركين ",
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
                                  alignment: Alignment.center,
                                  child: DropdownButton(
                                      padding: EdgeInsets.all(5),
                                      menuMaxHeight: 300,
                                      underline: Container(),
                                      items: s?.data?.map((value) {
                                        return DropdownMenuItem<int>(
                                          value: value.id,
                                          child: Text(
                                            value.title!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        _SelectdType,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.black),
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
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "اسم النادي",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Component_App.InputText3(
                              controller: controlNameClubs,
                              hint: 'اسم النادي ',
                              textInputType: TextInputType.text,
                              error: statusNameClubs,
                              function: (j) {}),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            image = await _picker
                                ?.pickImage(source: ImageSource.gallery)
                                .then((value) {
                              setState(() {
                                path = value!.path;
                              });
                            });
                          },
                          child: Container(
                            height: 143,
                            width: 388,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: path == null
                                ? const Row(
                                    children: [
                                      Expanded(
                                        child: Icon(
                                          Icons.image,
                                          size: 50,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                            'اضغط هنا لرفع صوره النادي الخاص بك '),
                                      )
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(File(path!),
                                        fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<NadekCubit>(context).createClub(
                              token!,
                              controlNameClubs.text,
                              path!,
                              tagClubs + 1,
                              type_sportId,
                              typeSub[tagSub]);
                          setState(() {
                            isLoadeing = true;
                          });
                        },
                        child: Container(
                            width: 340,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorApp.darkRead),
                            child: Center(
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
