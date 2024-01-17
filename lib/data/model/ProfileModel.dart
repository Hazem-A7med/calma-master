class ProfileModel {
  bool? status;
  String? errNum;
  String? msg;
  Data? data;

  ProfileModel({this.status, this.errNum, this.msg, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['errNum'] = errNum;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<MyVideos>? myVideos;
  User? myData;

  Data({this.myVideos, this.myData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['my_videos'] != null) {
      myVideos = <MyVideos>[];
      json['my_videos'].forEach((v) {
        myVideos!.add(MyVideos.fromJson(v));
      });
    }
    myData = json['my_data'] != null ? User.fromJson(json['my_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (myVideos != null) {
      data['my_videos'] = myVideos!.map((v) => v.toJson()).toList();
    }
    if (myData != null) {
      data['my_data'] = myData!.toJson();
    }
    return data;
  }
}

class MyVideos {
  int? id;
  String? title;
  String? description;
  String? path;
  String? location;
  String? userId;
  String? sportId;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<Comments>? comments;

  MyVideos(
      {this.id,
      this.title,
      this.description,
      this.path,
      this.location,
      this.userId,
      this.sportId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.comments});

  MyVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    path = json['path'];
    location = json['location'];
    userId = json['user_id'];
    sportId = json['sport_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['path'] = path;
    data['location'] = location;
    data['user_id'] = userId;
    data['sport_id'] = sportId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  int? id;
  String? comment;
  String? userId;
  String? videoId;
  String? createdAt;
  String? updatedAt;
  User? user;

  Comments(
      {this.id,
      this.comment,
      this.userId,
      this.videoId,
      this.createdAt,
      this.updatedAt,
      this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['user_id'];
    videoId = json['video_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['user_id'] = userId;
    data['video_id'] = videoId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? fcmToken;
  String? phone;
  String? berthDay;
  String? gender;
  String? facebook;
  String? twitter;
  String? instagram;
  String? youtube;
  String? snapchat;
  String? telegram;
  String? whatsapp;
  String? createdAt;
  String? updatedAt;
  String? photo;
  String? playerType;

  User({
    this.id,
    this.name,
    this.fcmToken,
    this.phone,
    this.berthDay,
    this.gender,
    this.facebook,
    this.twitter,
    this.instagram,
    this.youtube,
    this.snapchat,
    this.telegram,
    this.whatsapp,
    this.createdAt,
    this.updatedAt,
    this.photo,
    this.playerType,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fcmToken = json['fcm_token'];
    phone = json['phone'];
    berthDay = json['berth_day'];
    gender = json['gender'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    youtube = json['youtube'];
    snapchat = json['snapchat'];
    telegram = json['telegram'];
    whatsapp = json['whatsapp'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    photo = json['photo'];
    playerType = json['player_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fcm_token'] = fcmToken;
    data['phone'] = phone;
    data['berth_day'] = berthDay;
    data['gender'] = gender;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['instagram'] = instagram;
    data['youtube'] = youtube;
    data['snapchat'] = snapchat;
    data['telegram'] = telegram;
    data['whatsapp'] = whatsapp;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['photo'] = photo;
    data['player_type'] = playerType;
    return data;
  }
}
