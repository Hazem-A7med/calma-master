import 'package:bloc/bloc.dart';
import 'package:nadek/data/model/my_posts_model.dart';

import '../../data/webservices/WebServices.dart';
import '../states/my_posts_states.dart';


class MyPostsCubit extends Cubit<MyPostsState> {
  final Web_Services web_services = Web_Services();
  List<MyPost>myPosts=[];

  MyPostsCubit() : super(MyPostsInitialState());
  void fetchMyPosts(String token) async {
    emit(MyPostsLoadingState());
    print('MyPosts step 0');
    try {
      MyPostsModel myPostsModel = await web_services.getMyPosts(token: token);
      print('MyPosts step 1');
      myPosts=myPostsModel.postsResponse!.post!;
      print('MyPosts step 2');
      print(myPosts);
      print('MyPosts step 3');
      emit(MyPostsLoadedState(stories: myPosts));
      print('successsssssssssssssssssssssssssssss');
    } catch (error) {
      emit(MyPostsErrorState(error: 'Failed to load MyPosts: ${error.toString()}'));
    }
  }
}