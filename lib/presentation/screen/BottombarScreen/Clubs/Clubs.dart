import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/logic/cubit/nadek_state.dart';
import 'package:nadek/presentation/screen/CreateTournament.dart';
import 'package:nadek/presentation/screen/TournamentList.dart';
import 'package:nadek/presentation/screen/virtualTournments/virtual_tournments_list.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';
import 'package:nadek/sheard/style/ColorApp.dart';

class Clubs extends StatefulWidget {
  const Clubs({super.key});

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        title: const Text(
          'البطولات',
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          card(
              images: 'assets/images/football_rournaments.png',
              text: 'البطولات الواقعيه',
              function: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const TournamentList()));
              }),
          const SizedBox(
            height: 10,
          ),
          card(
              images: 'assets/images/Lazio_Brondby.png',
              text: 'البطولات الافتراضية',
              function: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VirtualTournmentsList(),
                    ));
              }),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const CreateTournament()));
            },
            child: Container(
              width: 340,
              height: 56,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorApp.darkRead),
              child: const Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image(
                        image: AssetImage('assets/images/add-square.png')),
                  ),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'لديك بطولة ؟ قم انشاء واحده الان ',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget card(
      {required String images,
      required String text,
      required Function() function}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: function,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image(
                image: AssetImage(images),
                height: 140,
                fit: BoxFit.fill,
              ),
              Container(
                height: 140,
                width: double.infinity,
                color: Colors.black54,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
