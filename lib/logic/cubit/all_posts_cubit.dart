import 'package:bloc/bloc.dart';
import 'package:nadek/data/model/all_posts_model.dart';

import '../../data/model/all_posts_model.dart';
import '../../data/webservices/WebServices.dart';
import '../states/all_posts_states.dart';
import '../states/all_posts_states.dart';


class AllPostsCubit extends Cubit<AllPostsState> {
  final Web_Services web_services = Web_Services();
  List<AllPostsResponse>allPosts=[];

  AllPostsCubit() : super(AllPostsInitialState());
  void fetchAllPosts(String token) async {
    emit(AllPostsLoadingState());
    print('AllPosts step 0');
    try {
      AllPostsModel allPostsModel = await web_services.getAllPosts(token: token);
      print('AllPosts step 1');
      allPosts=allPostsModel.allPostsResponse!;
      print('AllPosts step 2');
      print(allPosts);
      print('AllPosts step 3');
      emit(AllPostsLoadedState(allPosts: allPosts));
      print('successsssssssssssssssssssssssssssss');
    } catch (error) {
      emit(AllPostsErrorState(error: 'Failed to load AllPosts: ${error.toString()}'));
    }
  }
}