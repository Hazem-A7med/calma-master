class MyPostsModel {
  bool? success;
  String? message;
  PostsResponse? postsResponse;

  MyPostsModel({this.success, this.message, this.postsResponse});

  MyPostsModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    postsResponse = json['Response'] != null
        ? PostsResponse.fromJson(json['Response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Success'] = success;
    data['Message'] = message;
    if (postsResponse != null) {
      data['Response'] = postsResponse!.toJson();
    }
    return data;
  }
}

class PostsResponse {
  List<MyPost>? post;

  PostsResponse({this.post});

  PostsResponse.fromJson(Map<String, dynamic> json) {
    if (json['Post'] != null) {
      post = <MyPost>[];
      json['Post'].forEach((v) {
        post!.add(MyPost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (post != null) {
      data['Post'] = post!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyPost {
  int? id;
  String? content;
  String? mediaPath;
  String? mediaType;

  MyPost({this.id, this.content, this.mediaPath, this.mediaType});

  MyPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    mediaPath = json['media_path'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['media_path'] = mediaPath;
    data['media_type'] = mediaType;
    return data;
  }
}