import 'package:bloc/bloc.dart';
import '../../data/model/stories_model.dart';
import '../../data/webservices/WebServices.dart';
import '../../sheard/constante/cache_hleper.dart';
import '../states/stories_states.dart';


class StoriesCubit extends Cubit<StoriesState> {
  final Web_Services apiService = Web_Services();

  StoriesCubit() : super(StoriesInitialState());

  void fetchMyStories() async {
    emit(StoriesLoadingState());

    try {
      List<Story> stories = await apiService.getMyStoriesData(token: CacheHelper.getString('tokens')??'');
      emit(StoriesLoadedState(stories: stories));
    } catch (error) {
      emit(StoriesErrorState(error: 'Failed to load stories: $error'));
    }
  }
}