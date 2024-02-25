import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nadek/logic/states/create_post_states.dart';

import '../../data/webservices/WebServices.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit() : super(CreatePostInitialState());
  final Web_Services web_services = Web_Services();
  XFile? photo;

  final ImagePicker picker = ImagePicker();
  String mediaType = 'text';

  Future<XFile?> getImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      video = null;
      photo = XFile(image.path);
      mediaType = 'photo';
      print('********************************************************************************${photo?.path}');
      return XFile(image.path);
    }
    return null;
  }

  XFile? video;

  Future<void> pickVideo() async {
    final XFile? pickedVideo =
        await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      photo = null;
      video = XFile(pickedVideo.path);
      print(video!.path);
      mediaType = 'video';
    }
  }

  void createPost(String token, String content) async {
    emit(CreatePostLoadingState());
    print('UploadPost step 0');
    if (content.isEmpty && (photo == null || photo!.path.isEmpty)&&(video == null || video!.path.isEmpty)) {
      Fluttertoast.showToast(msg: 'content can\'t be empty');
    } else {
      Fluttertoast.showToast(msg: 'creating post...');
      try {
        if (photo == null && video == null) {
          mediaType = 'text';
        } else if (photo!=null) {
          mediaType = 'photo';
        } else {
          mediaType = 'video';
        }
        Response response = await web_services.createPost(
            token: token, content: content, photo: photo ,video: video,mediaType: mediaType);
        print('UploadPost step 1');
        print(response.statusCode);
        print('UploadPost step 2');
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: 'created');
          emit(CreatePostSuccessState());
          Fluttertoast.showToast(msg: 'created');
          print('successsssssssssssssssssssssssssssss');
        } else {
          Fluttertoast.showToast(msg: response.data);
          emit(CreatePostErrorState());
          print('faaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaile');
        }
      } catch (error) {
        print('errrrrrrrrrrrrrrrror create post ${error.toString()}');
        emit(CreatePostErrorState());
      }
    }
  }
}
