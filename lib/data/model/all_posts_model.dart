class AllPostsModel {
  bool? success;
  String? message;
  List<AllPostsResponse>? allPostsResponse;

  AllPostsModel({this.success, this.message, this.allPostsResponse});

  AllPostsModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    if (json['Response'] != null) {
      allPostsResponse = <AllPostsResponse>[];
      json['Response'].forEach((v) {
        allPostsResponse!.add(AllPostsResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Success'] = success;
    data['Message'] = message;
    if (allPostsResponse != null) {
      data['Response'] = allPostsResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllPostsResponse {
  User? user;
  List<AllPost>? allPost;

  AllPostsResponse({this.user, this.allPost});

  AllPostsResponse.fromJson(Map<String, dynamic> json) {
    user = json['User'] != null ? User.fromJson(json['User']) : null;
    if (json['Post'] != null) {
      allPost = <AllPost>[];
      json['Post'].forEach((v) {
        allPost!.add(AllPost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['User'] = user!.toJson();
    }
    if (allPost != null) {
      data['Post'] = allPost!.map((v) => v.toJson()).toList();
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

class AllPost {
  int? id;
  String? post;
  String? mediaPath;
  String? mediaType;

  AllPost({this.id, this.post, this.mediaPath, this.mediaType});

  AllPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    post = json['post'];
    mediaPath = json['media_path'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post'] = post;
    data['media_path'] = mediaPath;
    data['media_type'] = mediaType;
    return data;
  }
}