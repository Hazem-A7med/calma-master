
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/data/model/TournamentsMode.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/TournamentPage.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class TournamentList extends StatefulWidget {
  const TournamentList({super.key});

  @override
  State<TournamentList> createState() => _TournamentListState();
}

class _TournamentListState extends State<TournamentList> {
  int page =1;
  bool waiting = true;
  bool isLoading =false;
  TournamentsMode? mode;
  List<Data> d =<Data>[];
  String? token;
  late ScrollController controller;
  bool _sortAscending = true;


  @override
  void initState() {
    super.initState();
    token =CacheHelper.getString('tokens');
    BlocProvider.of<NadekCubit>(context).getTournamentsMode(token!, 1);
    controller = ScrollController()..addListener(pagination);
  }
  @override
  void dispose() {
    controller.removeListener(pagination);
    super.dispose();
  }

  void pagination() {
    if ((controller.position.pixels ==
        controller.position.maxScrollExtent)) {
      setState(() {
        isLoading = true;
        page += 1;
        //add api for load the more data according to new page
        BlocProvider.of<NadekCubit>(context).getTournamentsMode(token!, page);
      });
    }
  }
  void _sortList(bool ascending) {
    setState(() {
      _sortAscending = ascending;
      d.sort((a, b) => ascending
          ? a.iD!.compareTo(b.iD!)
          : b.iD!.compareTo(a.iD!));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar:  AppBar(
        actions: [
          IconButton(
              onPressed: (){
                setState(() {
                  if(d.isNotEmpty){
                   _sortList(_sortAscending?false:true);
                  }
                });


              },
              icon: Icon(Icons.filter_list)
          )
        ],
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        title: const Text('البطولات الواقعية',),
        centerTitle: true,
      ),
      body: BlocConsumer<NadekCubit,NadekState>(
        listener: (context,state){
          if(state is LoadedTournamentList){
            setState(() {
              waiting =false;

              mode =state.mode;
              mode!.data!.map((e) => d.add(e)).toList();

            });
            
          }
        },
        builder: (context,state){
          return waiting?Center(child: CircularProgressIndicator()):  Container(
            child: ListView.builder(
              controller: controller,
              itemCount: d.length,
              itemBuilder: (itemBuilder,index){
                return card(
                  id: d[index].iD!,
                    typeSport: '${d[index].sportTypeId}',
                    title: "${d[index].title} .",
                    subTitle: d[index].description!,
                    totalSubScr:d[index].minimumAge! ,
                    age:d[index].minimumAge!,
                    sex: d[index].gender!,
                    s: d[index].gift!,
                    price: d[index].price.toString(),
                    dateStart: d[index].dateStart.toString()
                );
              },

            ),
          );
        },
      ),
    );
  }
  Widget card({required int id,required String typeSport,required String title,required String subTitle,required int totalSubScr,required int age,required String sex,required String s,required String price,required String dateStart}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height:190 ,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.white,
                width: 1
            )
        ),
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
                      flex:2,
                      child:  Text(
                        typeSport,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14
                        ),
                      ),
                    ),
                    Expanded(
                        child:GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                                TournamentPage(id: id,)
                            ));
                          },
                          child:  Container(
                            decoration: BoxDecoration(
                                color: ColorApp.darkRead,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            height: 30,
                            width: 150,
                            child: const Center(
                              child: Text(
                                "عرض الاشتراك",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12
                                ),
                              ),
                            ),
                          ),
                        )
                    )
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
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      ),
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
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                    Text(
                      "الحد الأدنى للعمر : $age",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                    Text(
                      "الجنس : $sex",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
                    ),
                    Text(
                      "الجائزة : $s",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10
                      ),
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
