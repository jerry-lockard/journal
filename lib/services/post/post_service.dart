// lib/services/post_service.dart
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../models/post/post.dart';

class PostService {
  Future<void> createPost(String content, ParseUser user) async {
    final post = ParseObject('Post')
      ..set('user', user)
      ..set('content', content);

    await post.save();
  }

  Future<List<Post>> getPosts(ParseUser user) async {
    // Get friends
    final relation = user.getRelation<ParseUser>('friends');
    final friendsQuery = relation.getQuery();

    final friendsResponse = await friendsQuery.query();

    List<String> userIds = [user.objectId!];
    if (friendsResponse.success && friendsResponse.results != null) {
      final friends = friendsResponse.results!.cast<ParseUser>();
      userIds.addAll(friends.map((friend) => friend.objectId!));
    }

    // Fetch posts from user and friends
    final query = QueryBuilder<ParseObject>(ParseObject('Post'))
      ..whereContainedIn(
          'user',
          userIds
              .map((id) => ParseUser(null, null, null)..objectId = id)
              .toList())
      ..orderByDescending('createdAt')
      ..includeObject(['user']);

    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.map((e) => Post.fromParseObject(e)).toList();
    } else {
      return [];
    }
  }
}
