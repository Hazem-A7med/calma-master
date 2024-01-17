// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Challenger {
  final String challengerID;
  final String challenger;
  Challenger({
    required this.challengerID,
    required this.challenger,
  });

  Map<String, dynamic> toMap() {
    return {
      'ChallengerID': challengerID,
      'Challenger': challenger,
    };
  }

  factory Challenger.fromMap(Map<String, dynamic> map) {
    return Challenger(
      challengerID: map['ChallengerID'] as String,
      challenger: map['Challenger'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Challenger.fromJson(String source) =>
      Challenger.fromMap(json.decode(source) as Map<String, dynamic>);
}
