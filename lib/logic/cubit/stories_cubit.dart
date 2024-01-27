import 'package:dio/dio.dart';

import '../../data/model/stories_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Story>> getStoriesData() async {
    //try {
      Response response = await _dio.get('YOUR_API_ENDPOINT'); // Replace with your actual API endpoint

      if (response.statusCode == 200) {
        StoriesModel apiResponse = StoriesModel.fromJson(response.data);
        return apiResponse.response.values.toList();
      } else {
        throw DioError(
         // request: response.requestOptions,
          response: response,
          error: 'Failed to load stories data', requestOptions: response.requestOptions,
        );
      }
    // }
      // catch (error) {
    //   throw DioError(
    //     request: RequestOptions(path: 'YOUR_API_ENDPOINT'), // Replace with your actual API endpoint
    //     error: 'Failed to load stories data: $error',
    //   );
    // }
  }
}
