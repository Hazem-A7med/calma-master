import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

abstract class CreatePostState {}

class CreatePostInitialState extends CreatePostState {}

class CreatePostLoadingState extends CreatePostState {}

class CreatePostSuccessState extends CreatePostState {
  final XFile selectedMedia;

  CreatePostSuccessState(this.selectedMedia);
}

class CreatePostErrorState extends CreatePostState {}
