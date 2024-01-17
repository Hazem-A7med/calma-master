
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/BottombarScreen/Champions/CreateChampions.dart';
import 'package:nadek/sheard/ChangeInternet.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

import '../../../../data/model/AllClubs.dart';

class Champions extends StatefulWidget {
  const Champions({super.key});

  @override
  State<Champions> createState() => _ChampionsState();
}

class _ChampionsState extends State<Champions> {
  bool _sortAscending = true;

  int page =1;
  bool isLoading =true;
  AllClubs? clubs;
  List<Data> d =<Data>[];
  String? token;
  late ScrollController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    token =CacheHelper.getString('tokens');
    BlocProvider.of<NadekCubit>(context).getAllClubsModel(token!, 1);
    controller = ScrollController()..addListener(pagination);

  }
  void pagination() {
    if ((controller.position.pixels ==
        controller.position.maxScrollExtent)) {
      setState(() {
        isLoading = true;
        page += 1;
        //add api for load the more data according to new page
        BlocProvider.of<NadekCubit>(context).getAllClubsModel(token!, page);
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
      appBar:AppBar(
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
        title: const Text('صرح النادي',),
        centerTitle: true,
      ),
      body: ChangeInternet(
        chanegedInternt: (status){
          BlocProvider.of<NadekCubit>(context).getAllClubsModel(token!, 1);
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: BlocConsumer<NadekCubit,NadekState>(
            listener: (context,state){

              if(state is LoadedRegisterClub){
                Fluttertoast.showToast(
                  msg: '${state.model.msg}',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                );
              }
              if(state is LoadedGetAllClubs){
                setState(() {
                  isLoading =false;
                  clubs =state.allClubs;
                  clubs!.data!.map((e) => d.add(e)).toList();
                });
              }
            },
            builder:(context,state)=>isLoading?const Center(child: CircularProgressIndicator()): SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>CreateChampions()));
                    },
                    child: Container(
                      width: 340,
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorApp.darkRead
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child:  Image(
                                image: AssetImage('assets/images/add-square.png')
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child:  Text('لديك اكثر من 100 صديق ؟ أنشئ نادي خاص بك ',style: TextStyle(color: Colors.white),)
                          )
                        ],
                      ),

                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: d.length,
                      itemBuilder: (itemBuilder,index){
                        return  CardView(
                            images: d[index].photo.toString(),
                            title: '${ d[index].type}',
                            subTitle: 'الأعضاء : ${ d[index].countMembers}',
                            subTitle1: 'النوع : ${ d[index].typeSubscribe}',
                            isAdd: d[index].regitserClub,
                            textButtom: d[index].regitserClub==true?'تمت الاضافة':' اضافة',
                            cardFunction: (){},
                            butttonClick: (){
                              setState(() {
                                d[index].regitserClub? d[index].regitserClub=true:d[index].regitserClub =true;
                              });
                              BlocProvider.of<NadekCubit>(context).getRegisterClubModel(token!, d[index].iD!);
                              print('vvvvvvvvvvvvvvvvvvvvvvvv');
                            },
                        );
                      }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
class CardView extends StatefulWidget {
  String images;
  String title;
  String subTitle;
  String subTitle1;
  String textButtom;
  Function() cardFunction;
  Function() butttonClick;
  bool isAdd ;

  CardView({super.key,
    required this.images,
    required this.title,
    required this.subTitle,
    required this.subTitle1,
    required this.textButtom,
    required this.isAdd,
    required this.cardFunction,
    required this.butttonClick,
  });


  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.cardFunction,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image(
                image: NetworkImage(widget.images),
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 140,
                width: double.infinity,
                color: Colors.black54,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Container(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(widget.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(widget.subTitle,
                          style: const TextStyle(
                            color: Colors.white,

                          ),
                        ),
                        Text(widget.subTitle1,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 80),
                    child: GestureDetector(
                      onTap: (){
                        widget.butttonClick();

                      },
                      child:  Container(
                        decoration: BoxDecoration(
                            color: ColorApp.darkRead,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        height: 40,
                        width: 120,
                        child:  Center(
                          child: Text(
                            widget.isAdd?"تمت الاضافة":"اضافة",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12
                            ),
                          ),
                        ),
                      ),
                    )
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}


