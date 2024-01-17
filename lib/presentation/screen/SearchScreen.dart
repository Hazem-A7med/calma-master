import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/data/model/PlaygrounSearch.dart';
import 'package:nadek/data/model/SrearchModel.dart';
import 'package:nadek/data/model/UserSearch.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/DateAndTimePlayGraound.dart';
import 'package:nadek/presentation/screen/ProfileOfUser.dart';
import 'package:nadek/presentation/screen/TournamentPage.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool t = true;

  SrearchModel? model;
  PlaygrounSearch? playgrounSearch;
  UserSearch? userSearch;

  var text = TextEditingController();
  String? token;
  static const user = 'user';
  static const playground = 'playground ';
  static const tournament = 'tournament';

  String typeSearch = 'user';

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token = CacheHelper.getString('tokens');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: ColorApp.black_400,
      ),
      body: BlocConsumer<NadekCubit, NadekState>(
        listener: (context, state) {
          if (state is LoadedTournamentSearch) {
            setState(() {
              model = state.model;
              isLoading = false;
            });
          }
          if (state is LoadedUserSearch) {
            setState(() {
              userSearch = state.model;
              isLoading = false;
            });
          }
          if (state is LoadedPlaygroundSearch) {
            setState(() {
              playgrounSearch = state.model;
              isLoading = false;
            });
          }
        },
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 80,
                  child: TextField(
                    controller: text,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        isDense: true,
                        fillColor: ColorApp.input_text,
                        filled: true,
                        prefixIcon: IconButton(
                            onPressed: () {
                              bottomSheet();
                            },
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(31),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none)),
                        hintText: 'بحث',
                        hintStyle: const TextStyle(color: Colors.white)),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                      switch (typeSearch) {
                        case user:
                          BlocProvider.of<NadekCubit>(context)
                              .searchUserModel(token!, 'user', value);
                          break;
                        case playground:
                          BlocProvider.of<NadekCubit>(context)
                              .searchPlaygroundModel(
                                  token!, 'playground', value);
                          break;
                        case tournament:
                          BlocProvider.of<NadekCubit>(context)
                              .searchTournamentModel(
                                  token!, 'tournament', value);
                          break;
                      }

                      print(value);
                    },
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 8,
                child: typeSearch == user &&
                        userSearch != null &&
                        userSearch!.data != null
                    ? ListView.builder(
                        itemCount: userSearch!.data!.length,
                        itemBuilder: (itemBuilder, index) {
                          return InkWell(
                            onTap: () {
                              //Open Profile Of User
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => ProfileOfUser(
                                          myProfile: false,
                                          user_id:
                                              userSearch!.data![index].iD!)));
                            },
                            child: ListTile(
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image(
                                    height: 50,
                                    width: 50,
                                    image: NetworkImage(
                                        '${userSearch!.data![index].photo}'),
                                    fit: BoxFit.cover,
                                  )),
                              title: Text(
                                '${userSearch!.data![index].name}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          );
                        })
                    : typeSearch == playground &&
                            playgrounSearch != null &&
                            playgrounSearch!.data != null
                        ? ListView.builder(
                            itemCount: playgrounSearch!.data!.length,
                            itemBuilder: (itemBuilder, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              DateAndTimePlayGraound(
                                                  play_ground_id:
                                                      playgrounSearch!
                                                          .data![index].iD!)));
                                },
                                child: ListTile(
                                  leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(
                                            '${playgrounSearch!.data![index].images!.image}'),
                                        fit: BoxFit.cover,
                                      )),
                                  title: Text(
                                    '${playgrounSearch!.data![index].title}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    '${playgrounSearch!.data![index].ownerName}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              );
                            })
                        : typeSearch == tournament &&
                                model != null &&
                                model!.data != null
                            ? ListView.builder(
                                itemCount: model!.data!.length,
                                itemBuilder: (itemBuilder, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (build) {
                                        return TournamentPage(
                                            id: model!.data![index].iD!);
                                      }));
                                    },
                                    child: ListTile(
                                      title: Text(
                                        '${model!.data![index].title}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                  );
                                })
                            : Container(
                                height: 200,
                                child: Center(
                                    child: const Icon(
                                  Icons.search,
                                  size: 100,
                                  color: Colors.white,
                                )),
                              ))
          ],
        ),
      ),
    );
  }

  void bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 300,
            child: Column(
              children: [
                const Text(
                  'اختر نوع البحث',
                  style: TextStyle(fontSize: 20),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      typeSearch = user;
                    });
                    Navigator.pop(context);
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      title: Text(
                        ' البحث عن مستخدمين',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      typeSearch = playground;
                    });
                    Navigator.pop(context);
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      title: Text(
                        ' البحث عن ملاعب',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      typeSearch = tournament;
                    });
                    Navigator.pop(context);
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListTile(
                      title: Text(
                        ' البحث عن بطولات',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
