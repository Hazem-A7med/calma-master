import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nadek/data/model/AllPlayersModel.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/ProfileOfUser.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class AllPlayers extends StatefulWidget {
  const AllPlayers({super.key});

  @override
  State<AllPlayers> createState() => _AllPlayersState();
}

class _AllPlayersState extends State<AllPlayers> {
  int page = 1;
  bool waiting = true;
  bool isLoading = false;
  AllPlayersModel? mode;
  List<Data> d = <Data>[];
  String? token;
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    token = CacheHelper.getString('tokens');
    BlocProvider.of<NadekCubit>(context).getAllPlayers(token!, 1);
    controller = ScrollController()..addListener(pagination);
  }

  @override
  void dispose() {
    controller.removeListener(pagination);
    super.dispose();
  }

  void pagination() {
    if ((controller.position.pixels == controller.position.maxScrollExtent)) {
      setState(() {
        isLoading = true;
        page += 1;
        //add api for load the more data according to new page
        BlocProvider.of<NadekCubit>(context).getAllPlayers(token!, page);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        backgroundColor: ColorApp.black_400,
        title: Text('اللاعبين'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<NadekCubit, NadekState>(listener: (context, state) {
        if (state is LoadedAllPlayers) {
          setState(() {
            waiting = false;

            mode = state.model;
            mode!.data!.map((e) => d.add(e)).toList();
          });
        }
      }, builder: (context, state) {
        return Container(
          child: waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: d.length,
                  itemBuilder: (itemBuilder, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ProfileOfUser(
                                      user_id: d[index].iD!.toInt(),
                                      myProfile: false,
                                    )));
                      },
                      child: Container(
                        height: 70,
                        child: Center(
                          child: ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                  height: 50,
                                  width: 50,
                                  image: NetworkImage('${d[index].photo}'),
                                  fit: BoxFit.cover,
                                )),
                            title: Text(
                              '${d[index].name}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
        );
      }),
    );
  }
}
