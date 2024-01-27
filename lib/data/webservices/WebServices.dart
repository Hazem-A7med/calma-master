import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nadek/data/model/AddClub.dart';
import 'package:nadek/data/model/AddTournament.dart';
import 'package:nadek/data/model/AddUserRoom.dart';
import 'package:nadek/data/model/AllClubs.dart';
import 'package:nadek/data/model/AllPlayersModel.dart';
import 'package:nadek/data/model/AllPlayground.dart';
import 'package:nadek/data/model/AllRooms.dart';
import 'package:nadek/data/model/AllUser.dart';
import 'package:nadek/data/model/ApiData.dart';
import 'package:nadek/data/model/BestUser.dart';
import 'package:nadek/data/model/CommentsModel.dart';
import 'package:nadek/data/model/DetailsPlayground.dart';
import 'package:nadek/data/model/FollowedModel.dart';
import 'package:nadek/data/model/FollowersModel.dart';
import 'package:nadek/data/model/GetCart.dart';
import 'package:nadek/data/model/GetCategories.dart';
import 'package:nadek/data/model/LikeModel.dart';
import 'package:nadek/data/model/LiveModel.dart';
import 'package:nadek/data/model/LiveUserNowModel.dart';
import 'package:nadek/data/model/LocationUserModel.dart';
import 'package:nadek/data/model/MakeOrder.dart';
import 'package:nadek/data/model/PlaygrounSearch.dart';
import 'package:nadek/data/model/ProfileModel.dart';
import 'package:nadek/data/model/ProfileOfUserModel.dart';
import 'package:nadek/data/model/RegisterClubModel.dart';
import 'package:nadek/data/model/Reservation.dart';
import 'package:nadek/data/model/SettingsModel.dart';
import 'package:nadek/data/model/SrearchModel.dart';
import 'package:nadek/data/model/TournamentDetailsModel.dart';
import 'package:nadek/data/model/TournamentsMode.dart';
import 'package:nadek/data/model/UploadVideo.dart';
import 'package:nadek/data/model/UserSearch.dart';
import 'package:nadek/data/model/account_update.dart';
import 'package:nadek/data/model/create_group_model.dart';
import 'package:nadek/data/model/livechannel_token.dart';
import 'package:nadek/data/model/login_model.dart';
import 'package:nadek/data/model/private_video.dart';
import 'package:nadek/data/model/public_video.dart';
import 'package:nadek/data/model/register_model.dart';
import 'package:nadek/data/model/sports.dart';
import 'package:nadek/presentation/screen/virtualTournments/virtual_methods.dart';

import '../model/stories_model.dart';
import '../model/stories_model.dart';
import '../model/stories_model.dart';

class Web_Services {
  late Dio dio;

  Web_Services() {
    dio = Dio(BaseOptions(
      // baseUrl: 'https://calmaapp.com/api/',
      baseUrl: 'https://dev.calmaapp.com/api/',
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    ));
  }

  Future<List<Story>> getMyStoriesData({required String token,}) async {
    print('1111111111111111111111111111111111111111');
    dio.options.headers['Authorization'] = ' Bearer $token';
    try { print('1111111111111111111111111111111111111111');
      Response response = await dio.get('community/stories/my-stories');
    print('1111111111111111111111111111111111111111');
      if (response.statusCode == 200) { print('2222222222222222222222222222222222222222');
        if (response.headers.map['content-type']?.first == 'application/json') {
          Map<String, dynamic> responseData = json.decode(response.data.toString());
          StoriesModel storiesModel = StoriesModel.fromJson(responseData);
          List<Story> stories = storiesModel.response.values.toList();
          print('33333333333333333333333333333333333333333333333333333333');
          return stories;
                } else {
          print('Error: Unexpected content type in response');
          return [];
        }
      } else {
        print('Error: Non-200 status code');
        return [];
      }
    }on DioError catch (e) {
      if (e.response != null) {
        print('Dio Error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error send request!');
        print(e.message);
      }
      return [];
    } catch (e) {
      print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${e.toString()}');
      return [];
    }
  }

  Future<void> logout({
    required String token,
  }) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    try {
      Response response = await dio.post('logout');
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio Error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error send request!');
        print(e.message);
      }
    }
  }

  Future<void> deleteAccount({
    required String token,
    required int id,
  }) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    try {
      print('Mostafaaa: $token');
      print('Mostafaaa: $id');
      Response response = await dio.post('delete_account/$id');
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio Error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error send request!');
        print(e.message);
      }
    }
  }

  Future<login_model> getData(
      {required String phone, required String password}) async {
    login_model? login;
    try {
      Response response =
          await dio.post('login', data: {'phone': phone, 'password': password});
      login = login_model.fromJson(response.data);
      printWarning('${login.data?.photo}');
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio Error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error send request!');
        print(e.message);
      }
    }
    return login!;
  }

  Future<sports> getSports() async {
    sports? s;

    try {
      Response response = await dio.get('sports');
      print(response.data);

      s = sports.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio Error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error send request!');
        print(e.message);
      }
    }
    return s!;
  }

  Future<register_model> Register(
      {required String name,
      required String date,
      required String sex,
      required String phone,
      required String password,
      required String fcm_token,
      required List list}) async {
    register_model? register;

    try {
      Response response = await dio.post('register', data: {
        'name': name,
        'berth_day': date,
        'gender': sex,
        'phone': phone,
        'password': password,
        'fcm_token': fcm_token,
        'sports': list
      });

      register = register_model.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio Error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error send request!');
        print(e.message);
      }
    }

    return register!;
  }

  Future<dynamic> Create_group(String token, String name, String file) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    String fileName = file.split('/').last;

    FormData data = FormData.fromMap({
      'photo': await MultipartFile.fromFile(file, filename: fileName),
      'name': name
    });
    Response response = await dio.post('create_room', data: data);
    return create_group_model.fromJson(response.data);
  }

  Future<LiveChannelToken> getRTCToken(String token, String channelName) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    FormData data = FormData.fromMap({
      'channelName': channelName,
    });

    Response response = await dio.post('agora', data: data);
    return LiveChannelToken.fromMap(response.data);
  }

  Future<dynamic> getAllRooms(String token) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    Response response = await dio.get('rooms');

    return AllRooms.fromJson(response.data);
  }

  Future<dynamic> getPrivateVideo(String token) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    Response response = await dio.get('videos');

    print(response.data);

    return private_video.fromJson(response.data);
  }

  Future<dynamic> getPublicVideo(String token) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    Response response = await dio.get('home');
    return public_video.fromJson(response.data);
  }

  Future<dynamic> getAllUser(
      {required int room_id, required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    Response response =
        await dio.get('users', queryParameters: {'room_id': room_id});
    print(response.data);
    return AllUser.fromJson(response.data);
  }

  Future<dynamic> add_room_users(int roomId, int userId, String token) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    Response response = await dio
        .post('add_room_users', data: {'room_id': roomId, 'user_id': userId});
    return AddUserRoom.fromJson(response.data);
  }

  Future<dynamic> UpdatePhoto(String file, String token) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    String fileName = file.split('/').last;

    FormData data = FormData.fromMap({
      'photo': await MultipartFile.fromFile(file, filename: fileName),
    });
    printWarning('Uploaded');

    Response response = await dio.post('account_update', data: data);
    printError(response.data.toString());
    return account_update.fromJson(response.data);
  }

  Future<dynamic> UpdateLocation(
      {required double lit,
      required double long,
      required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    Response response =
        await dio.post('account_update', data: {'lat': lit, 'long': long});
    print(response.data);
    return account_update.fromJson(response.data);
  }

  Future<dynamic> setaccount_update(
      String name,
      String berthDay,
      String gender,
      String phone,
      String password,
      String instagram,
      String youtube,
      String token) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    FormData formData = FormData.fromMap({
      'name': name,
      'berth_day': berthDay,
      'gender': gender,
      'phone': phone,
      'instagram': instagram ?? '',
      'youtube': youtube ?? '',
      'password': password
    });
    Response response = await dio.post('account_update', data: formData);
    print(response.data);
    return account_update.fromJson(response.data);
  }

  Future<dynamic> getCategories(String token) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('categories');

    return GetCategories.fromJson(response.data);
  }

  Future<dynamic> setUploadVideo(
      Function(int sent, int total) function,
      String file,
      String title,
      String location,
      int sportId,
      String token) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    String fileName = file.split('/').last;

    FormData data = FormData.fromMap({
      'title': title,
      'location': location,
      'sport_id': sportId,
      'video': await MultipartFile.fromFile(file, filename: fileName)
    });
    Response response = await dio.post('upload_video',
        data: data,
        onSendProgress: (int sent, int total) => function(sent, total));
    print(response.data);
    return UploadVideo.fromJson(response.data);
  }

  Future<dynamic> PostToCart(
      {required int product_id,
      required int quantity,
      required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('add_to_cart',
        data: {'product_id': product_id, 'quantity': quantity});
    return ApiData.fromJson(response.data);
  }

  Future<dynamic> GetFromCart({required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('cart');
    print(response.data);
    return GetCart.fromJson(response.data);
  }

  Future<dynamic> RemoveFromCart(
      {required int product_id,
      required int quantity,
      required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('add_to_cart',
        data: {'product_id': product_id, 'quantity': quantity});
    return ApiData.fromJson(response.data);
  }

  Future<dynamic> PostMakeOrder(
      {required String location, required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response =
        await dio.post('make_order', data: {'location': location});
    return MakeOrder.fromJson(response.data);
  }

  Future<dynamic> GetCount({required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('cart_count');
    return ApiData.fromJson(response.data);
  }

  Future<dynamic> PostAddComment(
      {required String token,
      required int video_id,
      required String comment}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('add_comment', data: {
      'video_id': video_id,
      'comment': comment,
    });
    return response.statusCode;
  }

  Future<dynamic> GetProfile({required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('profile');
    return ProfileModel.fromJson(response.data);
  }

  Future<dynamic> GetProfileOfUser(
      {required int user_id, required String token}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    print(user_id);
    Response response =
        await dio.get('profile', queryParameters: {'user_id': user_id});
    print(response.data);
    return ProfileOfUserModel.fromJson(response.data);
  }

  Future<dynamic> GetFollowed({required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('followed');
    print(response.data);
    return FollowedModel.fromJson(response.data);
  }

  Future<dynamic> GetFollowers({required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('followers');
    return FollowersModel.fromJson(response.data);
  }

  Future<dynamic> GetAllComments(
      {required String token, required Map<String, dynamic> map}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('comments', queryParameters: map);
    print(response.data);

    return CommentsModel.fromJson(response.data);
  }

  Future<dynamic> AddLike(
      {required String token, required Map<String, dynamic> map}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('add_like', queryParameters: map);
    return LikeModel.fromJson(response.data);
  }

  Future<dynamic> AddFollow({required String token, required int uid}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('make_follow', data: {'user_id': uid});
    // print(response.data);
    return ApiData.fromJson(response.data);
  }

  Future<dynamic> GetBestUser({required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('best_users');
    return BestUser.fromJson(response.data);
  }

  Future<dynamic> GetAllocationUser({required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('users_near');
    print(response.data);
    return LocationUserModel.fromJson(response.data);
  }

  Future<dynamic> StartAndEndLive(
      {required String token, required Map<String, dynamic> map}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('agora_token', queryParameters: map);
    return LiveModel.fromJson(response.data);
  }

  Future<dynamic> GetLiveUserNow({required String token}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('users_live');
    return LiveUserNowModel.fromJson(response.data);
  }

  Future<dynamic> GetSettings() async {
    Response response = await dio.get('settings');
    print(response.data);
    return SettingsModel.fromJson(response.data);
  }

  Future<dynamic> DeleteUserFromRom(
      {required String token,
      required String room_id,
      required String user_id}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('delete_room_user',
        data: {'room_id': room_id, 'user_id': user_id});
    print(response.data);
    return response.data;
  }

  Future<dynamic> DeleteRoom(
      {required String token, required String room_id}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('delete_room', data: {
      'room_id': room_id,
    });
    print(response.data);
    return ApiData.fromJson(response.data);
  }

  Future<dynamic> tournamentDetails(
      {required String token, required int id}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('details/tournament/$id');
    print(response.data);
    return TournamentDetailsModel.fromJson(response.data);
  }

  Future<dynamic> Tournaments(
      {required String token, required int page}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response =
        await dio.get('all/tournaments', queryParameters: {'page': page});
    print(response.data);
    return TournamentsMode.fromJson(response.data);
  }

  Future<dynamic> PostTournaments({
    required String token,
    required String type,
    required String payment,
    required int typesportid,
    required String price,
    required String name,
    required String number_participants,
    required String minimum_age,
    required String gender,
    required String gift,
    required String date_start,
    required String description,
    required String mobile,
    required String title,
  }) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('add/tournament', data: {
      'type': type,
      'payment': payment,
      'type_sport_id': typesportid,
      'price': price,
      'name': name,
      'number_participants': number_participants,
      'minimum_age': minimum_age,
      'gender': gender,
      'gift': gift,
      'date_start': date_start,
      'description': description,
      'mobile': mobile,
      'title': title,
    });
    print(response.data);
    return AddTournament.fromJson(response.data);
  }

  Future<dynamic> allClubs({required String token, required int page}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response =
        await dio.get('all/clubs', queryParameters: {'page': page});
    print(response.data);
    return AllClubs.fromJson(response.data);
  }

  Future<dynamic> registerClub(
      {required String token, required int clubId}) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response =
        await dio.post('register/club', queryParameters: {'club_id': clubId});
    print(response.data);
    return RegisterClubModel.fromJson(response.data);
  }

  Future<dynamic> createClub(String token, String name, String file,
      int typeClub, int sportTypeId, String typeSubscribe) async {
    dio.options.headers['Authorization'] = ' Bearer $token';

    String fileName = file.split('/').last;

    FormData data = FormData.fromMap({
      'photo': await MultipartFile.fromFile(file, filename: fileName),
      'name': name,
      'type_club': typeClub,
      'sport_type_id': sportTypeId,
      'type_subscribe': typeSubscribe,
    });
    Response response = await dio.post('add/club', data: data);
    return AddClub.fromJson(response.data);
  }

  Future<dynamic> getAllPlayground(String token, int page) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response =
        await dio.get('playground/all', queryParameters: {'page': page});
    return AllPlayground.fromJson(response.data);
  }

  Future<dynamic> getDetailsPlayground(
      String token, int playGroundId, String date) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.get('playground/details',
        queryParameters: {'play_ground_id': playGroundId, 'date': date});
    return DetailsPlayground.fromJson(response.data);
  }

  Future<dynamic> postReservation(
      String token, int playGroundId, int reservationId) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('store/reservation', queryParameters: {
      'play_ground_id': playGroundId,
      'reservation_id': reservationId
    });
    return Reservation.fromJson(response.data);
  }

  Future<AllPlayersModel> getAllPlayers(String token, int page) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response =
        await dio.get('all/users', queryParameters: {'page': page});
    return AllPlayersModel.fromJson(response.data);
  }

  Future<dynamic> searchModel(
      String token, String searchName, String searchValue) async {
    dio.options.headers['Authorization'] = ' Bearer $token';
    Response response = await dio.post('search/all', queryParameters: {
      'search_name': searchName,
      'search_value': searchValue
    });
    print(response.data);
    switch (searchName) {
      case 'user':
        return UserSearch.fromJson(response.data);
        break;
      case 'playground':
        return PlaygrounSearch.fromJson(response.data);
        break;
      case 'tournament':
        return SrearchModel.fromJson(response.data);
        break;
    }
  }
}
