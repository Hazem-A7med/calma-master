import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
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
      try {
        if (photo == null && video == null) mediaType = 'text';
        Response response = await web_services.createPost(
            token: token, content: content, photo: photo ,video: video,mediaType: mediaType);
        print('UploadPost step 1');
        print(response.statusCode);
        print('UploadPost step 2');
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: response.body);
          emit(CreatePostSuccessState());
          Fluttertoast.showToast(msg: 'created');
          print('successsssssssssssssssssssssssssssss');
        } else {
          Fluttertoast.showToast(msg: response.body);
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
