class AllStoriesModel {
  bool? success;
  String? message;
  List<AllStoriesResponse>? response;

  AllStoriesModel({this.success, this.message, this.response});

  AllStoriesModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    if (json['Response'] != null) {
      response = <AllStoriesResponse>[];
      json['Response'].forEach((v) {
        response!.add(AllStoriesResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Success'] = success;
    data['Message'] = message;
    if (response != null) {
      data['Response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllStoriesResponse {
  User? user;
  List<AllStories>? story;

  AllStoriesResponse({this.user, this.story});

  AllStoriesResponse.fromJson(Map<String, dynamic> json) {
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    if (json['Story'] != null) {
      story = <AllStories>[];
      json['Story'].forEach((v) {
        story!.add(AllStories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['User'] = user!.toJson();
    }
    if (story != null) {
      data['Story'] = story!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? photo;

  User({this.id, this.name, this.photo});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    return data;
  }
}

class AllStories {
  int? id;
  String? text;
  String? mediaType;
  String? mediaPath;
  bool? watched;

  AllStories({this.id, this.text, this.mediaType, this.mediaPath, this.watched});

  AllStories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    mediaType = json['media_type'];
    mediaPath = json['media_path'];
    watched = json['watched'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['media_type'] = mediaType;
    data['media_path'] = mediaPath;
    data['watched'] = watched;
    return data;
  }
}