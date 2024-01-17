class AllClubs {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? data;

  AllClubs({this.status, this.errNum, this.msg, this.data});

  AllClubs.fromJson(Map<String, dynamic> json) {
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
  String? type;
  String? photo;
  String? sportTypeId;
  String? gender;
  String? countMembers;
  Null? dateStart;
  String? typeClub;
  String? typeSubscribe;
  bool regitserClub=false;

  Data(
      {this.iD,
        this.type,
        this.photo,
        this.sportTypeId,
        this.gender,
        this.countMembers,
        this.dateStart,
        this.typeClub,
        this.typeSubscribe,
        required this.regitserClub});

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    type = json['type'];
    photo = json['photo'];
    sportTypeId = json['sport_type_id'];
    gender = json['gender'];
    countMembers = json['count_members'];
    dateStart = json['date_start'];
    typeClub = json['type_club'];
    typeSubscribe = json['type_subscribe'];
    regitserClub = json['regitser_club'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['type'] = this.type;
    data['photo'] = this.photo;
    data['sport_type_id'] = this.sportTypeId;
    data['gender'] = this.gender;
    data['count_members'] = this.countMembers;
    data['date_start'] = this.dateStart;
    data['type_club'] = this.typeClub;
    data['type_subscribe'] = this.typeSubscribe;
    data['regitser_club'] = this.regitserClub;
    return data;
  }
}