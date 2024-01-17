import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nadek/data/model/Challenger.dart';
import 'package:nadek/sheard/constante/cache_hleper.dart';

final stringToBase64 = utf8.fuse(base64);

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

Future<void> sendChallenge({
  required String channelName,
  required Challenger challenger,
}) async {
  await FirebaseFirestore.instance
      .collection('livestream')
      .doc(channelName)
      .collection('Challengers')
      .doc(challenger.challengerID)
      .set(challenger.toMap());
}

Future<bool> createVirtualTournment(String name, String userId) async {
  var result = false;
  final encodedChannelName = stringToBase64.encode(name);

  final doc = await FirebaseFirestore.instance
      .collection('livestream')
      .doc(encodedChannelName)
      .get();

  if (doc.exists) {
    Fluttertoast.showToast(
      msg: 'تم انشاء بطولة بهذا الاسم ',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  } else {
    FirebaseFirestore.instance
        .collection('livestream')
        .doc(encodedChannelName)
        .set(
      {'Owner': userId},
    );

    result = true;
  }

  return result;
}

Future<void> acceptChallenge({
  required String channelName,
  required Challenger challenger,
}) async {
  await FirebaseFirestore.instance
      .collection('livestream')
      .doc(channelName)
      .collection('AcceptedChallengers')
      .add(challenger.toMap());
}

Future<void> deleteCollectionDocs(String collectionPath) async {
  final instance = FirebaseFirestore.instance;
  final batch = instance.batch();
  var collection = instance.collection(collectionPath);
  var snapshots = await collection.get();
  for (var doc in snapshots.docs) {
    batch.delete(doc.reference);
  }

  await batch.commit();
}

Future<void> endChallenge(String channelName) async {
  await deleteCollectionDocs('livestream/$channelName/Chat');
  await deleteCollectionDocs('livestream/$channelName/AcceptedChallengers');
  await deleteCollectionDocs('livestream/$channelName/Challengers');

  await FirebaseFirestore.instance
      .collection('livestream')
      .doc(channelName)
      .delete();
}

Future<bool> isChannelAlive(String channelName) async {
  final result = await FirebaseFirestore.instance
      .collection('livestream')
      .doc(channelName)
      .get();

  return result.exists;
}

Future<DocumentReference> addChannelMessage(
  String message,
  String channelName,
) {
  final String name = CacheHelper.getString('username')!;
  final String id = CacheHelper.getString('Id')!;

  return FirebaseFirestore.instance
      .collection('livestream')
      .doc(channelName)
      .collection('Chat')
      .add(<String, dynamic>{
    'text': message,
    'timestamp': FieldValue.serverTimestamp(),
    'name': name,
    'userId': id,
  });
}
