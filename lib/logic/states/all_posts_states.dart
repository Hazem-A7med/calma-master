import 'package:equatable/equatable.dart';
import 'package:nadek/data/model/my_posts_model.dart';

import '../../data/model/all_posts_model.dart';


abstract class AllPostsState extends Equatable {
  const AllPostsState();

  @override
  List<Object> get props => [];
}

class AllPostsInitialState extends AllPostsState {}

class AllPostsLoadingState extends AllPostsState {}

class AllPostsLoadedState extends AllPostsState {
  final List<AllPostsResponse> allPosts;

  const AllPostsLoadedState({required this.allPosts});

  @override
  List<Object> get props => [allPosts];
}

class AllPostsErrorState extends AllPostsState {
  final String error;

  const AllPostsErrorState({required this.error});

  @override
  List<Object> get props => [error];
}