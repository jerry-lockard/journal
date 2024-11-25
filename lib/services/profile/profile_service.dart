// lib/services/profile_service.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../models/profile/profile.dart';

class ProfileService {
  Future<void> createProfile(ParseUser user) async {
    final profile = ParseObject('Profile')
      ..set('user', user)
      ..set('username', user.username);

    await profile.save();
  }

  Future<Profile?> getProfile(ParseUser user) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Profile'))
      ..whereEqualTo('user', user);

    final response = await query.query();

    if (response.success && response.results != null) {
      final profileObject = response.results!.first;
      return Profile.fromParseObject(profileObject);
    } else {
      return null;
    }
  }

  Future<void> updateProfile(Profile profile) async {
    final profileObject = ParseObject('Profile')
      ..objectId = profile.id
      ..set('fullName', profile.fullName)
      ..set('bio', profile.bio);

    await profileObject.save();
  }
}
