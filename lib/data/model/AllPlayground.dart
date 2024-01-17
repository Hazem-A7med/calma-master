class AllPlayground {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? data;

  AllPlayground({this.status, this.errNum, this.msg, this.data});

  AllPlayground.fromJson(Map<String, dynamic> json) {
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
  dynamic price;
  dynamic mobile;
  dynamic lat;
  dynamic lang;
  Images? images;
  List<ReservationTimeOpen>? reservationTimeOpen;

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
      this.images,
      this.reservationTimeOpen});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'] ?? 0;
    title = json['title'] ?? '';
    sportTypeId = json['sport_type_id'] ?? '';
    expanse = json['expanse'] ?? '';
    details = json['details'] ?? '';
    location = json['location'] ?? '';
    ownerName = json['owner_name'] ?? '';
    status = json['status'] ?? '';
    price = json['price'] ?? '';
    mobile = json['mobile'] ?? '';
    lat = json['lat'] ?? '';
    lang = json['lang'] ?? '';
    images =
        json['images'] != null ? new Images.fromJson(json['images']) : null;
    if (json['reservation_time_open'] != null) {
      reservationTimeOpen = <ReservationTimeOpen>[];
      json['reservation_time_open'].forEach((v) {
        reservationTimeOpen!.add(new ReservationTimeOpen.fromJson(v));
      });
    }
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
    if (this.reservationTimeOpen != null) {
      data['reservation_time_open'] =
          this.reservationTimeOpen!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  String? image;

  Images({this.id, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    image = json['image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class ReservationTimeOpen {
  int? id;
  int? playGroundId;
  String? date;
  String? timeFrom;
  String? timeTo;
  String? createdAt;
  String? updatedAt;

  ReservationTimeOpen(
      {this.id,
      this.playGroundId,
      this.date,
      this.timeFrom,
      this.timeTo,
      this.createdAt,
      this.updatedAt});

  ReservationTimeOpen.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    playGroundId = json['play_ground_id'] ?? 0;
    date = json['date'] ?? '';
    timeFrom = json['time_from'] ?? '';
    timeTo = json['time_to'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['play_ground_id'] = this.playGroundId;
    data['date'] = this.date;
    data['time_from'] = this.timeFrom;
    data['time_to'] = this.timeTo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
