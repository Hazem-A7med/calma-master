
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/data/model/sports.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import '../../core/utils/app_colors.dart';
class TypeSports extends StatefulWidget {
  const TypeSports({super.key});

  @override
  State<TypeSports> createState() => _TypeSportsState();
}

class _TypeSportsState extends State<TypeSports> {
  late sports s;

  bool waiting =true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<NadekCubit>(context).getSports();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        backgroundColor: ColorApp.black_400,

        elevation: 0,
        title: Text('انواع الريـاضــات'),
        centerTitle: true,
      ),
      body: BlocConsumer<NadekCubit, NadekState>(
          listener:(context, state){
            if (state is LoadedDataSports ){
              setState((){
                s= state.s;
                waiting=false;
              });

            }
          },
          builder:(context, state){
            return waiting?const Center(child: CircularProgressIndicator(color: AppColors.mainColor),):
            ListView.builder(
              itemCount: s.data!.length,
                itemBuilder: (itemBuilder,index){

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:card(
                        images: '${s.data![index].photo}',
                        text: '${s.data![index].title}',
                        function: (){

                        }
                     )
                  );
                }
            );
          },

      ),
    );
  }
  Widget card({required String images,required String text,required Function() function}){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: function,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image(
                image: NetworkImage(images),
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 140,
                width: double.infinity,
                color: Colors.black54,
                child:Center(
                  child: Text(text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}
