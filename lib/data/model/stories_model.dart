class StoriesModel {
  bool success;
  String message;
  Map<String, Story> response;

  StoriesModel({
    required this.success,
    required this.message,
    required this.response,
  });

  factory StoriesModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> responseJson = json['Response'];
    Map<String, Story> responseMap = {};
    responseJson.forEach((key, value) {
      responseMap[key] = Story.fromJson(value);
    });

    return StoriesModel(
      success: json['Success'],
      message: json['Message'],
      response: responseMap,
    );
  }
}

class Story {
  int id;
  String description;
  String mediaPath;
  String mediaType;

  Story({
    required this.id,
    required this.description,
    required this.mediaPath,
    required this.mediaType,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      description: json['description'],
      mediaPath: json['media_path'],
      mediaType: json['media_type'],
    );
  }
}