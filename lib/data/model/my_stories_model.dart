// class StoriesModel {
//   bool? success;
//   String? message;
//   StoryResponse? storyResponse;
//
//   StoriesModel({this.success, this.message, this.storyResponse});
//
//   StoriesModel.fromJson(Map<String, dynamic> json) {
//     success = json['Success'];
//     message = json['Message'];
//     storyResponse = json['Response'] != null
//         ? StoryResponse.fromJson(json['Response'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Success'] = success;
//     data['Message'] = message;
//     if (storyResponse != null) {
//       data['Response'] = storyResponse!.toJson();
//     }
//     return data;
//   }
// }
//
// class StoryResponse {
//   List<Story>? story;
//
//   StoryResponse({this.story});
//
//   StoryResponse.fromJson(Map<String, dynamic> json) {
//     if (json['Story'] != null) {
//       story = <Story>[];
//       json['Story'].forEach((v) {
//         story!.add(Story.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (story != null) {
//       data['Story'] = story!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Story {
//   int? id;
//   String? description;
//   String? mediaPath;
//   String? mediaType;
//   List<Views>? views;
//
//   Story(
//       {this.id, this.description, this.mediaPath, this.mediaType, this.views});
//
//   Story.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     description = json['description'];
//     mediaPath = json['media_path'];
//     mediaType = json['media_type'];
//     if (json['views'] != null) {
//       views = <Views>[];
//       json['views'].forEach((v) {
//         views!.add(Views.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['description'] = description;
//     data['media_path'] = mediaPath;
//     data['media_type'] = mediaType;
//     if (views != null) {
//       data['views'] = views!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Views {
//   int? id;
//   int? userId;
//   int? storyId;
//   String? createdAt;
//   String? updatedAt;
//
//   Views({this.id, this.userId, this.storyId, this.createdAt, this.updatedAt});
//
//   Views.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     storyId = json['story_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['story_id'] = storyId;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }

class StoriesModel {
  bool? success;
  String? message;
  StoryResponse? storyResponse;

  StoriesModel({this.success, this.message, this.storyResponse});

  factory StoriesModel.fromJson(Map<String, dynamic> json) {
    return StoriesModel(
      success: json['Success'],
      message: json['Message'],
      storyResponse: json['Response'] != null
          ? StoryResponse.fromJson(json['Response'])
          : null,
    );
  }
}

class StoryResponse {
  List<Story>? stories;

  StoryResponse({this.stories});

  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['Story'] is List) {
      return StoryResponse(
        stories: (json['Story'] as List)
            .map((v) => Story.fromJson(v))
            .toList(),
      );
    } else {
      return StoryResponse(stories: []);
    }
  }
}

class Story {
  int? id;
  String? description;
  String? mediaPath;
  String? mediaType;
  List<Views>? views;

  Story({
    this.id,
    this.description,
    this.mediaPath,
    this.mediaType,
    this.views,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      description: json['description'],
      mediaPath: json['media_path'],
      mediaType: json['media_type'],
      views: (json['views'] as List<dynamic>?)
          ?.map((v) => Views.fromJson(v))
          .toList(),
    );
  }
}

class Views {
  int? id;
  int? userId;
  int? storyId;
  String? createdAt;
  String? updatedAt;

  Views({this.id, this.userId, this.storyId, this.createdAt, this.updatedAt});

  factory Views.fromJson(Map<String, dynamic> json) {
    return Views(
      id: json['id'],
      userId: json['user_id'],
      storyId: json['story_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}