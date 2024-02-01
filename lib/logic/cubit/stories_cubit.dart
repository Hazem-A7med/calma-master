import 'package:bloc/bloc.dart';
import 'package:date_format/date_format.dart';

import '../../data/model/my_stories_model.dart';
import '../../data/webservices/WebServices.dart';
import '../states/my_stories_states.dart'; // Replace with your actual project structure


class StoriesCubit extends Cubit<MyStoriesState> {
  final Web_Services web_services = Web_Services();
  List<Story>myStories=[];

  StoriesCubit() : super(MyStoriesInitialState());
  void fetchMyStories(String token) async {
    emit(MyStoriesLoadingState());
    print('stories step 0');
    try {
      StoriesModel storiesModel = await web_services.getMyStoriesData(token: token);
      print('stories step 1');
      myStories=storiesModel.storyResponse!.stories!;
      print('stories step 2');
      print(myStories.first.description);
      print('stories step 3');
      emit(MyStoriesLoadedState(stories: myStories));
      print('successsssssssssssssssssssssssssssss');
    } catch (error) {
      emit(MyStoriesErrorState(error: 'Failed to load stories: ${error.toString()}'));
    }
  }
}