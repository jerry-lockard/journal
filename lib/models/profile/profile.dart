// lib/models/profile.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Profile {
  String id;
  String username;
  String? fullName;
  String? bio;
  ParseFileBase? profilePicture;

  Profile({
    required this.id,
    required this.username,
    this.fullName,
    this.bio,
    this.profilePicture,
  });

  factory Profile.fromParseObject(ParseObject object) {
    return Profile(
      id: object.objectId!,
      username: object.get<String>('username')!,
      fullName: object.get<String>('fullName'),
      bio: object.get<String>('bio'),
      profilePicture: object.get<ParseFileBase>('profilePicture'),
    );
  }
}
