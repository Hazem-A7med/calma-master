import 'package:equatable/equatable.dart';
import 'package:nadek/data/model/my_posts_model.dart';


abstract class MyPostsState extends Equatable {
  const MyPostsState();

  @override
  List<Object> get props => [];
}

class MyPostsInitialState extends MyPostsState {}

class MyPostsLoadingState extends MyPostsState {}

class MyPostsLoadedState extends MyPostsState {
  final List<MyPost> stories;

  const MyPostsLoadedState({required this.stories});

  @override
  List<Object> get props => [stories];
}

class MyPostsErrorState extends MyPostsState {
  final String error;

  const MyPostsErrorState({required this.error});

  @override
  List<Object> get props => [error];
}