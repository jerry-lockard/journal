// lib/services/friend_service.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class FriendService {
  Future<bool> sendFriendRequest(ParseUser fromUser, ParseUser toUser) async {
    final friendRequest = ParseObject('FriendRequest')
      ..set('fromUser', fromUser)
      ..set('toUser', toUser)
      ..set('status', 'pending');

    final response = await friendRequest.save();

    if (response.success) {
      // Send push notification
      final pushQuery =
          QueryBuilder<ParseInstallation>(ParseInstallation.forQuery())
            ..whereEqualTo('user', toUser);

      final push = ParseObject('_PushStatus')
        ..set('title', 'New Friend Request')
        ..set('alert', '${fromUser.username} sent you a friend request')
        ..set('query', pushQuery);

      await push.save();
    }

    return response.success;
  }

  Future<List<ParseObject>> getPendingRequests(ParseUser user) async {
    final query = QueryBuilder<ParseObject>(ParseObject('FriendRequest'))
      ..whereEqualTo('toUser', user)
      ..whereEqualTo('status', 'pending')
      ..includeObject(['fromUser']);

    final response = await query.query();
    if (response.success && response.results != null) {
      return response.results!.cast<ParseObject>();
    }
    return <ParseObject>[];
  }

  Future<bool> acceptFriendRequest(ParseObject friendRequest) async {
    friendRequest.set('status', 'accepted');
    final response = await friendRequest.save();

    if (response.success) {
      // Add each user to the other's friends relation
      final fromUser = friendRequest.get<ParseUser>('fromUser')!;
      final toUser = friendRequest.get<ParseUser>('toUser')!;

      final fromUserRelation = fromUser.getRelation<ParseUser>('friends');
      final toUserRelation = toUser.getRelation<ParseUser>('friends');

      fromUserRelation.add(toUser);
      toUserRelation.add(fromUser);

      await fromUser.save();
      await toUser.save();

      return true;
    }
    return false;
  }

  Future<bool> rejectFriendRequest(ParseObject friendRequest) async {
    friendRequest.set('status', 'rejected');
    final response = await friendRequest.save();
    return response.success;
  }

  Future<List<ParseUser>> getFriends(ParseUser user) async {
    final relation = user.getRelation<ParseUser>('friends');
    final query = relation.getQuery();

    final response = await query.query();
    if (response.success && response.results != null) {
      return response.results!.cast<ParseUser>();
    }
    return [];
  }
}
