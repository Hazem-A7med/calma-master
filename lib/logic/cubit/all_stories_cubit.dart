import 'package:bloc/bloc.dart';
import 'package:nadek/data/model/all_stories_model.dart';

import '../../data/webservices/WebServices.dart';
import '../states/all_stories_states.dart';


class AllStoriesCubit extends Cubit<AllStoriesState> {
  final Web_Services web_services = Web_Services();
  List<AllStoriesResponse>allStories=[];

  AllStoriesCubit() : super(AllStoriesInitialState());
  void fetchAllStories(String token) async {
    emit(AllStoriesLoadingState());
    print('allStories step 0');
    try {
      AllStoriesModel allStoriesModel = await web_services.getAllStoriesData(token: token);
      print('allStories step 1');
      allStories=allStoriesModel.response!;
      print('allStories step 2');
      print(allStories.first.user?.name);
      print('allStories step 3');
      print(allStories);
      print(allStories);
      print(allStories.first.user?.name);
      emit(AllStoriesLoadedState(allStories: allStories));
      print('successsssssssssssssssssssssssssssss');
    } catch (error) {
      emit(AllStoriesErrorState(error: 'Failed to load stories: ${error.toString()}'));
    }
  }
}