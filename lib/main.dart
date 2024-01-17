import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nadek/core/utils/app_colors.dart';
import 'package:nadek/data/repository/repository.dart';
import 'package:nadek/data/webservices/WebServices.dart';
import 'package:nadek/logic/cubit/nadek_cubit.dart';
import 'package:nadek/presentation/App_Route.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);

  await CacheHelper.init();

  initializeDateFormatting().then((_) => runApp(Phoenix(
        child: MyApp(
          app_routeing: App_Routeing(),
        ),
      )));
}

class MyApp extends StatelessWidget {
  final App_Routeing app_routeing;
  const MyApp({Key? key, required this.app_routeing}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(
      child: BlocProvider(
        create: (context) => NadekCubit(repository(Web_Services())),
        child: MaterialApp(
          title: 'Calma',
          theme: ThemeData(scaffoldBackgroundColor: AppColors.scaffold,
            fontFamily: 'Schyler',
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.white,fontFamily: 'Schyler',
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: app_routeing.create_app_route,
        ),
      ),
    );
  }
}
