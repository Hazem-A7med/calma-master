import 'package:equatable/equatable.dart';


abstract class PostEditState extends Equatable {
  const PostEditState();

  @override
  List<Object> get props => [];
}

class PostEditInitialState extends PostEditState {}

class PostEditLoadingState extends PostEditState {}

class PostEditSuccessState extends PostEditState {}

class PostEditErrorState extends PostEditState {}
