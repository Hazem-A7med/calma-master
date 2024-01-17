// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LiveChannelToken {
  final String token;
  final int user_id;

  LiveChannelToken({
    required this.token,
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'user_id': user_id,
    };
  }

  factory LiveChannelToken.fromMap(Map<String, dynamic> map) {
    return LiveChannelToken(
      token: map['token'] as String,
      user_id: map['user_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory LiveChannelToken.fromJson(String source) =>
      LiveChannelToken.fromMap(json.decode(source) as Map<String, dynamic>);
}
