import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileOfUserModel {
  bool? status;
  String? errNum;
  String? msg;
  Data? data;

  ProfileOfUserModel({this.status, this.errNum, this.msg, this.data});

  ProfileOfUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<MyVideos>? myVideos;
  Owner? myData;
  List<MySports>? sports;
  List<MyFollowers>? myFollowers;
  List<MyFollows>? myFollows;

  Data({this.myVideos, this.myData, this.myFollows, this.myFollowers});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['my_videos'] != null) {
      myVideos = <MyVideos>[];
      json['my_videos'].forEach((v) {
        myVideos!.add(MyVideos.fromJson(v));
      });
    }

    myData = json['my_data'] != null ? Owner.fromJson(json['my_data']) : null;

    if (json['my_follows'] != null) {
      myFollows = <MyFollows>[];
      json['my_follows'].forEach((v) {
        myFollows!.add(MyFollows.fromJson(v));
      });
    }
    if (json['my_followers'] != null) {
      myFollowers = <MyFollowers>[];
      json['my_followers'].forEach((v) {
        myFollowers!.add(MyFollowers.fromJson(v));
      });
    }
    if (json['sports'] != null) {
      sports = <MySports>[];
      json['sports'].forEach((v) {
        sports!.add(MySports.fromJson(v));
      });
    }
  }
}

class MySports {
  int? id;
  String? title;
  MySports({
    this.id,
    this.title,
  });

  factory MySports.fromJson(Map<String, dynamic> json) {
    return MySports(
      id: json['id'] != null ? json['id'] as int : null,
      title: json['title'] != null ? json['title'] as String : null,
    );
  }
}

class MyFollowers {
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
  dynamic createdAt;
  dynamic updatedAt;
  dynamic photo;
  dynamic long;
  dynamic lat;
  dynamic best;

  MyFollowers({
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
    this.long,
    this.lat,
    this.best,
  });

  MyFollowers.fromJson(Map<String, dynamic> json) {
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
    long = json['long'];
    lat = json['lat'];
    best = json['best'];
  }
}

class MyFollows {
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
  dynamic photo;
  dynamic long;
  dynamic lat;
  dynamic best;

  MyFollows(
      {this.id,
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
      this.long,
      this.lat,
      this.best});

  MyFollows.fromJson(Map<String, dynamic> json) {
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
    long = json['long'];
    lat = json['lat'];
    best = json['best'];
  }
}

class MyVideos {
  int? id;
  String? title;
  String? description;
  String? path;
  String? location;
  dynamic userId;
  dynamic sportId;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  bool? userLike;
  Owner? owner;
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
      this.userLike,
      this.owner,
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
    userLike = json['user_like'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }
}

class Owner {
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
  String? player_type;

  dynamic long;
  dynamic lat;
  dynamic best;
  bool? user_follow;

  Owner(
      {this.id,
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
      this.long,
      this.lat,
      this.player_type,
      this.best,
      this.user_follow});

  Owner.fromJson(Map<String, dynamic> json) {
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
    long = json['long'];
    lat = json['lat'];
    best = json['best'];
    user_follow = json['user_follow'];
    player_type = json['player_type'];
  }
}

class Comments {
  int? id;
  String? comment;
  dynamic userId;
  String? videoId;
  String? createdAt;
  String? updatedAt;

  Comments(
      {this.id,
      this.comment,
      this.userId,
      this.videoId,
      this.createdAt,
      this.updatedAt});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['user_id'];
    videoId = json['video_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
