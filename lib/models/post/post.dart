// lib/models/post.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Post {
  String id;
  String content;
  ParseUser user;
  DateTime createdAt;

  Post({
    required this.id,
    required this.content,
    required this.user,
    required this.createdAt,
  });

  factory Post.fromParseObject(ParseObject object) {
    return Post(
      id: object.objectId!,
      content: object.get<String>('content')!,
      user: object.get<ParseUser>('user')!,
      createdAt: object.createdAt!,
    );
  }
}
