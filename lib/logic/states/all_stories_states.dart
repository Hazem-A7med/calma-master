import 'package:equatable/equatable.dart';

import '../../data/model/all_stories_model.dart';

abstract class AllStoriesState extends Equatable {
  const AllStoriesState();

  @override
  List<Object> get props => [];
}

class AllStoriesInitialState extends AllStoriesState {}

class AllStoriesLoadingState extends AllStoriesState {}

class AllStoriesLoadedState extends AllStoriesState {
  final List<AllStoriesResponse> stories;

  const AllStoriesLoadedState({required this.stories});

  @override
  List<Object> get props => [stories];
}

class AllStoriesErrorState extends AllStoriesState {
  final String error;

  const AllStoriesErrorState({required this.error});

  @override
  List<Object> get props => [error];
}