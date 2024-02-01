import 'package:equatable/equatable.dart';

import '../../data/model/my_stories_model.dart';

abstract class MyStoriesState extends Equatable {
  const MyStoriesState();

  @override
  List<Object> get props => [];
}

class MyStoriesInitialState extends MyStoriesState {}

class MyStoriesLoadingState extends MyStoriesState {}

class MyStoriesLoadedState extends MyStoriesState {
  final List<Story> stories;

  const MyStoriesLoadedState({required this.stories});

  @override
  List<Object> get props => [stories];
}

class MyStoriesErrorState extends MyStoriesState {
  final String error;

  const MyStoriesErrorState({required this.error});

  @override
  List<Object> get props => [error];
}