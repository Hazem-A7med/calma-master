import 'package:bloc/bloc.dart';
import 'package:date_format/date_format.dart';

import '../../data/model/stories_model.dart';
import '../../data/webservices/WebServices.dart';
import '../states/stories_states.dart'; // Replace with your actual project structure


class StoriesCubit extends Cubit<StoriesState> {
  final Web_Services web_services = Web_Services();
  List<Story>s=[];
  StoriesCubit() : super(StoriesInitialState());
  void fetchMyStories(String token) async {
    emit(StoriesLoadingState());
    print('stories step 0');
    try {
      StoriesModel storiesModel = await web_services.getStoriesData(token: token);
      print('stories step 1');
      s=storiesModel.storyResponse!.stories!;
      print('stories step 2');
      print(s.first.description);
      print('stories step 3');
      //emit(StoriesLoadedState(stories: storiesModel.storyResponse?.story ?? []));
      emit(StoriesLoadedState(stories: s));
      print('successsssssssssssssssssssssssssssss');
    } catch (error) {
      emit(StoriesErrorState(error: 'Failed to load stories: ${error.toString()}'));
    }
  }
}