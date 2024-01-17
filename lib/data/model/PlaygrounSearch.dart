class PlaygrounSearch {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? data;

  PlaygrounSearch({this.status, this.errNum, this.msg, this.data});

  PlaygrounSearch.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? sportTypeId;
  String? expanse;
  String? details;
  String? location;
  String? ownerName;
  String? status;
  int? price;
  int? mobile;
  int? lat;
  int? lang;
  Images? images;

  Data(
      {this.iD,
        this.title,
        this.sportTypeId,
        this.expanse,
        this.details,
        this.location,
        this.ownerName,
        this.status,
        this.price,
        this.mobile,
        this.lat,
        this.lang,
        this.images});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['title'];
    sportTypeId = json['sport_type_id'];
    expanse = json['expanse'];
    details = json['details'];
    location = json['location'];
    ownerName = json['owner_name'];
    status = json['status'];
    price = json['price'];
    mobile = json['mobile'];
    lat = json['lat'];
    lang = json['lang'];
    images =
    json['images'] != null ? new Images.fromJson(json['images']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['title'] = this.title;
    data['sport_type_id'] = this.sportTypeId;
    data['expanse'] = this.expanse;
    data['details'] = this.details;
    data['location'] = this.location;
    data['owner_name'] = this.ownerName;
    data['status'] = this.status;
    data['price'] = this.price;
    data['mobile'] = this.mobile;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    if (this.images != null) {
      data['images'] = this.images!.toJson();
    }

    return data;
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}