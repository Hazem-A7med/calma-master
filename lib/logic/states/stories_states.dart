import 'package:equatable/equatable.dart';

import '../../data/model/stories_model.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

class StoriesInitialState extends StoriesState {}

class StoriesLoadingState extends StoriesState {}

class StoriesLoadedState extends StoriesState {
  final List<Story> stories;

  const StoriesLoadedState({required this.stories});

  @override
  List<Object> get props => [stories];
}

class StoriesErrorState extends StoriesState {
  final String error;

  const StoriesErrorState({required this.error});

  @override
  List<Object> get props => [error];
}