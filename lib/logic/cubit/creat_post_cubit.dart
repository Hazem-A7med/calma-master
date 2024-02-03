
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadek/logic/states/create_post_states.dart';

class MediaPickerCubit extends Cubit<CreatePostState> {
  MediaPickerCubit() : super(CreatePostInitialState());

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
        source: ImageSource
            .gallery); // You can also use ImageSource.camera to capture a new image
    if (image != null) {
      return XFile(image.path);
    }
    return null;
  }

}