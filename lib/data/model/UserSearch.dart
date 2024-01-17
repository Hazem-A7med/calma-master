class UserSearch {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? data;

  UserSearch({this.status, this.errNum, this.msg, this.data});

  UserSearch.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errNum'] = this.errNum;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? iD;
  String? name;
  String? berthDay;
  String? gender;
  String? photo;
  dynamic phoneNumber;
  dynamic firebaseToken;
  dynamic facebook;
  dynamic twitter;
  dynamic instagram;
  dynamic youtube;
  dynamic snapchat;
  dynamic telegram;
  dynamic whatsapp;
  dynamic playerType;
  dynamic description;
  dynamic apiKey;
  List<Clubs>? clubs;
  List<Sports>? sports;

  Data(
      {this.iD,
        this.name,
        this.berthDay,
        this.gender,
        this.photo,
        this.phoneNumber,
        this.firebaseToken,
        this.facebook,
        this.twitter,
        this.instagram,
        this.youtube,
        this.snapchat,
        this.telegram,
        this.whatsapp,
        this.playerType,
        this.description,
        this.apiKey,
        this.clubs,
        this.sports});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    berthDay = json['BerthDay'];
    gender = json['Gender'];
    photo = json['Photo'];
    phoneNumber = json['PhoneNumber'];
    firebaseToken = json['FirebaseToken'];
    facebook = json['Facebook'];
    twitter = json['Twitter'];
    instagram = json['Instagram'];
    youtube = json['Youtube'];
    snapchat = json['Snapchat'];
    telegram = json['Telegram'];
    whatsapp = json['Whatsapp'];
    playerType = json['PlayerType'];
    description = json['Description'];
    apiKey = json['ApiKey'];
    if (json['clubs'] != null) {
      clubs = <Clubs>[];
      json['clubs'].forEach((v) {
        clubs!.add(new Clubs.fromJson(v));
      });
    }
    if (json['sports'] != null) {
      sports = <Sports>[];
      json['sports'].forEach((v) {
        sports!.add(new Sports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['BerthDay'] = this.berthDay;
    data['Gender'] = this.gender;
    data['Photo'] = this.photo;
    data['PhoneNumber'] = this.phoneNumber;
    data['FirebaseToken'] = this.firebaseToken;
    data['Facebook'] = this.facebook;
    data['Twitter'] = this.twitter;
    data['Instagram'] = this.instagram;
    data['Youtube'] = this.youtube;
    data['Snapchat'] = this.snapchat;
    data['Telegram'] = this.telegram;
    data['Whatsapp'] = this.whatsapp;
    data['PlayerType'] = this.playerType;
    data['Description'] = this.description;
    data['ApiKey'] = this.apiKey;
    if (this.clubs != null) {
      data['clubs'] = this.clubs!.map((v) => v.toJson()).toList();
    }
    if (this.sports != null) {
      data['sports'] = this.sports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Clubs {
  int? id;
  dynamic name;
  dynamic photo;
  dynamic gender;
  dynamic countMembers;
  dynamic typeClub;
  dynamic sportTypeId;
  dynamic typeSubscribe;
  dynamic createdAt;
  dynamic updatedAt;

  Clubs(
      {this.id,
        this.name,
        this.photo,
        this.gender,
        this.countMembers,
        this.typeClub,
        this.sportTypeId,
        this.typeSubscribe,
        this.createdAt,
        this.updatedAt});

  Clubs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    gender = json['gender'];
    countMembers = json['count_members'];
    typeClub = json['type_club'];
    sportTypeId = json['sport_type_id'];
    typeSubscribe = json['type_subscribe'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['gender'] = this.gender;
    data['count_members'] = this.countMembers;
    data['type_club'] = this.typeClub;
    data['sport_type_id'] = this.sportTypeId;
    data['type_subscribe'] = this.typeSubscribe;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Sports {
  int? id;
  dynamic title;
  dynamic photo;
  dynamic createdAt;
  dynamic updatedAt;

  Sports({this.id, this.title, this.photo, this.createdAt, this.updatedAt});

  Sports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    photo = json['photo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}