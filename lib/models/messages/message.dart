// lib/models/message.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Message extends ParseObject implements ParseCloneable {
  Message(
      {required String id,
      required ParseUser fromUser,
      required ParseUser toUser,
      required String content,
      DateTime? createdAt})
      : super('Message');

  Message.clone()
      : this(
            id: '',
            fromUser: ParseUser(null, null, null),
            toUser: ParseUser(null, null, null),
            content: '',
            createdAt: null);

  @override
  clone(Map<String, dynamic> map) => Message.clone()..fromJson(map);

  ParseUser? get fromUser => get<ParseUser>('fromUser');
  set fromUser(ParseUser? user) => set('fromUser', user);

  ParseUser? get toUser => get<ParseUser>('toUser');
  set toUser(ParseUser? user) => set('toUser', user);

  String? get content => get<String>('content');
  set content(String? value) => set('content', value);

  DateTime? get createdAt => super.createdAt;

  static Message fromParseObject(ParseObject object) {
    final message = Message(
        id: '',
        fromUser: ParseUser(null, null, null),
        toUser: ParseUser(null, null, null),
        content: '')
      ..fromUser = object.get<ParseUser>('fromUser')
      ..toUser = object.get<ParseUser>('toUser')
      ..content = object.get<String>('content');
    message.objectId = object.objectId;
    return message;
  }
}
