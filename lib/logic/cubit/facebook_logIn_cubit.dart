import 'package:bloc/bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:nadek/logic/states/google_login_states.dart';

class FacebookLoginCubit extends Cubit<GoogleLoginState> {
  late AccessToken? accessToken;
  bool isLoggedIn = false;
  Map userObj = {};
  String name = '';
  String id = '';
  String email = '';
  String image = '';

  FacebookLoginCubit():super(GoogleLoginInitialState());

  facebookLogIn(context) async {
    emit(GoogleLoginLoadingState());
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken;
      userObj = await FacebookAuth.instance.getUserData();
      id = accessToken?.userId ?? '';
      // email =
      //     accessToken?.declinedPermissions?.contains('email').toString() ?? '';
      image = userObj['picture']['data']['url'];
      name = userObj['name'];
      email = userObj['email'];
      print(
          '*************$id*************$email**************$name*************$image');
      // await Provider.of<EmailLoginProvider>(context, listen: false)
      //     .postUserData(id, 'facebook', name, email);
      // Hive.box('myBox').put('facebookLogin', {
      //   "image": image,
      //   "name": name,
      // });
      isLoggedIn = true;
      emit(GoogleLoginLoadedState());
    } else {
      print(result.status);
      print(result.message);
      print(result.accessToken);
      emit(GoogleLoginErrorState());
    }
    print(userObj);

  }


  facebookLogOut() async {
    await FacebookAuth.instance.logOut();
    accessToken = null;
    userObj = {};
    //Hive.box('myBox').delete('facebookLogin');
    //notifyListeners();
  }
}
