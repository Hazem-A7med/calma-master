class TournamentDetailsModel {
  bool? status;
  String? errNum;
  String? msg;
  Data? data;

  TournamentDetailsModel({this.status, this.errNum, this.msg, this.data});

  TournamentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errNum = json['errNum'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errNum'] = this.errNum;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? iD;
  String? type;
  String? title;
  String? sportTypeId;
  int? minimumAge;
  String? gender;
  String? dateStart;
  String? gift;
  dynamic status;
  String? payment;
  int? price;
  String? description;

  Data(
      {this.iD,
        this.type,
        this.title,
        this.sportTypeId,
        this.minimumAge,
        this.gender,
        this.dateStart,
        this.gift,
        this.status,
        this.payment,
        this.price,
        this.description});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['type'];
    title = json['title'];
    sportTypeId = json['sport_type_id'];
    minimumAge = json['minimum_age'];
    gender = json['gender'];
    dateStart = json['date_start'];
    gift = json['gift'];
    status = json['status'];
    payment = json['payment'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['type'] = this.type;
    data['title'] = this.title;
    data['sport_type_id'] = this.sportTypeId;
    data['minimum_age'] = this.minimumAge;
    data['gender'] = this.gender;
    data['date_start'] = this.dateStart;
    data['gift'] = this.gift;
    data['status'] = this.status;
    data['payment'] = this.payment;
    data['price'] = this.price;
    data['description'] = this.description;
    return data;
  }
}