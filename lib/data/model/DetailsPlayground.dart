class DetailsPlayground {
  bool? status;
  String? errNum;
  String? msg;
  Data? data;

  DetailsPlayground({this.status, this.errNum, this.msg, this.data});

  DetailsPlayground.fromJson(Map<String, dynamic> json) {
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
  Images? images;
  List<ReservationTimeOpen>? reservationTimeOpen;
  List<void>? reservationTimeRefus;

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
      this.images,
      this.reservationTimeOpen,
      this.reservationTimeRefus});

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
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    if (json['reservation_time_open'] != null) {
      reservationTimeOpen = <ReservationTimeOpen>[];
      json['reservation_time_open'].forEach((v) {
        reservationTimeOpen!.add(ReservationTimeOpen.fromJson(v));
      });
    }
    if (json['reservation_time_refus'] != null) {
      reservationTimeRefus = <Null>[];
      json['reservation_time_refus'].forEach((v) {
        // reservationTimeRefus!.add(new Null.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['title'] = title;
    data['sport_type_id'] = sportTypeId;
    data['expanse'] = expanse;
    data['details'] = details;
    data['location'] = location;
    data['owner_name'] = ownerName;
    data['status'] = status;
    data['price'] = price;
    data['mobile'] = mobile;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    if (reservationTimeOpen != null) {
      data['reservation_time_open'] =
          reservationTimeOpen!.map((v) => v.toJson()).toList();
    }
    if (reservationTimeRefus != null) {
      // data['reservation_time_refus'] =
      //     this.reservationTimeRefus!.map((v) => v.toJson()).toList();toList
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
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
    id = json['id'];
    playGroundId = json['play_ground_id'];
    date = json['date'];
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['play_ground_id'] = playGroundId;
    data['date'] = date;
    data['time_from'] = timeFrom;
    data['time_to'] = timeTo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
