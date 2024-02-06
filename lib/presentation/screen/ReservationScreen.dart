import '../../core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/DateAndTimePlayGraound.dart';
import 'package:nadek/presentation/screen/DetailsPlaygroundScreen.dart';
import 'package:nadek/sheard/ChangeInternet.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

import '../../data/model/AllPlayground.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {

  int page =1;
  bool waiting = true;
  AllPlayground? mode;
  List<Data> d =<Data>[];
  String? token;
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    token =CacheHelper.getString('tokens');
    controller = ScrollController()..addListener(pagination);
    BlocProvider.of<NadekCubit>(context).getAllPlayground(token!, 1);
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
        page += 1;
        //add api for load the more data according to new page
        BlocProvider.of<NadekCubit>(context).getAllPlayground(token!, page);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar:  AppBar(
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        title: const Text('المـلاعـب',),
        centerTitle: true,

      ),
      body: ChangeInternet(
        chanegedInternt: (status){
          BlocProvider.of<NadekCubit>(context).getAllPlayground(token!, 1);

        },
        child: BlocConsumer<NadekCubit,NadekState>(
          listener: (context,state){
            if(state is LoadedAllPlayground){
              setState(() {
                waiting =false;

                mode =state.allPlayground;
                d.clear();
                mode!.data!.map((e) => d.add(e)).toList();

              });

            }
          },
          builder: (context,state) {
            return  waiting?Center(child: CircularProgressIndicator(color: AppColors.mainColor)):
            ListView.builder(
              itemCount: d.length,
                itemBuilder: (itemBuilder,index){
                  return Card(
                    function: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (builder)=>DateAndTimePlayGraound(play_ground_id: d[index].iD!,)
                      ));
                    },
                    img:'${d[index].images!.image}' ,
                    title:'${d[index].title}' ,
                    owner:'${d[index].ownerName}' ,
                    sport: '${d[index].sportTypeId}',
                    expanse:'${d[index].expanse}' ,

                  );
                }
            );
          },
        ),
      ),

    );
  }
  Widget Card({required Function() function,required String img,required String title,required String owner,required String sport,required String expanse}){
    return  GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15,bottom: 5,top: 5),
        child: Container(
          width: 370,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorApp.black_400,
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(.5, .5), // Shadow position
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Image(
                        image:
                        NetworkImage(img),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Container(
                          height: 50,
                          width: 50,
                          color: ColorApp.darkRead,
                          child: Center(
                            child: Text(
                              sport,
                              style:const TextStyle(
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
                              expanse,
                              style:const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              title,
                              style:const TextStyle(color: Colors.white),
                            ),
                            Text(
                             owner,
                              style: const TextStyle(color: Colors.white),
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
  }
}
