import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:nadek/logic/states/post_edit_states.dart';

import '../../data/webservices/WebServices.dart';

class PostEditCubit extends Cubit<PostEditState> {
  PostEditCubit() : super(PostEditInitialState());
  final Web_Services web_services = Web_Services();
  Future<void> likePost({
    required String token,
    required String type,
    required String postId,
  }) async {

      emit(PostEditLoadingState());

      Response response = await web_services.likePost(type: type,
        token: token,
        postId: postId,
      );
print(response.toString());
print(response.toString());
print(response.toString());try {
      if (response.statusCode == 200) {
        print('object1');
        emit(PostEditSuccessState());
      } else {
        print(response.statusCode);
        print(response.toString());
        print('object2');
        emit(PostEditErrorState());
      }
    } catch (e) {
      print('object3');
      print(e.toString());
      emit(PostEditErrorState());
    }
  }
}
