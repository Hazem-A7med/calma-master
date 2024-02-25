import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nadek/logic/states/google_login_states.dart';
import 'package:nadek/presentation/screen/Splach_Screen.dart';

class GoogleLogInCubit extends Cubit<GoogleLoginState> {
  String? name;
  String? email;
  String? image;
  String? id;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  GoogleLogInCubit():super(GoogleLoginInitialState());

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {return splach_screen();
          if (snapshot.hasData) {
           // return  HomeScreen(selectedIndex: 0,);
          } else {
           // return const LoginScreen();
          }
        });
  }

  signInWithGoogle(context) async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>['email']).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('googleAuth.accessToken');
    print(googleAuth.accessToken);
    print('googleAuth.accessToken');
    email = googleUser.email.toString();
    id = googleUser.id.toString();
    name = googleUser.displayName;
    image = googleUser.photoUrl.toString();
    print('logged in $name ---------------------------------------------');
    print('logged in $image--------------------------------------------');
    print('logged in $id--------------------------------------------');
    print('logged in $email--------------------------------------------');
    if(image=='null'){image='https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-High-Quality-Image.png';}
    //await Provider.of<PostUserData>(context, listen: false)
      //  .postUserData(id ?? 'no id', 'google', name ?? 'no name', email ?? 'no mail',image??'no image',context);
    //await Hive.box('myBox').put('userData', {'email':email,'id':id,});
    //notifyListeners();
    print('loooooooooooooooooooooooooooooooo');
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  googleSignOut() {
    FirebaseAuth.instance.signOut();
    auth.signOut().then((value) => {
          googleSignIn.signOut(),
        });
    // Hive.box('myBox').delete('userData');
    // Hive.box('myBox').delete('userSubscription');
    // print(Hive.box('myBox').get('userSubscription'));
    // print(Hive.box('myBox').get('userData'));
    //notifyListeners();
  }
}
