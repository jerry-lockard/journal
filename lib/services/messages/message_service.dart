// lib/services/message_service.dart
import 'dart:async';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../models/messages/message.dart';

class MessageService {
  StreamController<List<Message>>? _messagesController;
  Timer? _refreshTimer;

  Future<bool> sendMessage(
      ParseUser fromUser, ParseUser toUser, String content) async {
    final message =
        Message(id: '', fromUser: fromUser, toUser: toUser, content: content);

    final response = await message.save();
    if (response.success) {
      _refreshMessages();
    }
    return response.success;
  }

  Future<List<Message>> getMessages(
      ParseUser currentUser, ParseUser otherUser) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Message'))
      ..whereMatchesKeyInQuery(
          'fromUser',
          'objectId',
          QueryBuilder(ParseObject('_User'))
            ..whereEqualTo('objectId', currentUser.objectId)
            ..whereEqualTo('objectId', otherUser.objectId))
      ..whereMatchesKeyInQuery(
          'toUser',
          'objectId',
          QueryBuilder(ParseObject('_User'))
            ..whereEqualTo('objectId', currentUser.objectId)
            ..whereEqualTo('objectId', otherUser.objectId))
      ..orderByDescending('createdAt')
      ..includeObject(['fromUser', 'toUser']);

    final response = await query.query();

    if (!response.success || response.results == null) {
      return [];
    }

    final messages =
        response.results!.map((e) => Message.fromParseObject(e)).toList();

    messages.sort((a, b) => (b.createdAt ?? DateTime.now())
        .compareTo(a.createdAt ?? DateTime.now()));

    return messages;
  }

  void subscribeToMessages(ParseUser currentUser, ParseUser otherUser,
      void Function(List<Message>) onMessagesUpdated) {
    _messagesController?.close();
    _refreshTimer?.cancel();

    _messagesController = StreamController<List<Message>>();
    _messagesController!.stream.listen(onMessagesUpdated);

    // Initial load
    _refreshMessages(currentUser: currentUser, otherUser: otherUser);

    // Set up periodic refresh
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _refreshMessages(currentUser: currentUser, otherUser: otherUser);
    });
  }

  Future<void> _refreshMessages({
    ParseUser? currentUser,
    ParseUser? otherUser,
  }) async {
    if (currentUser != null && otherUser != null && _messagesController != null) {
      final messages = await getMessages(currentUser, otherUser);
      _messagesController!.add(messages);
    }
  }

  void dispose() {
    _messagesController?.close();
    _refreshTimer?.cancel();
    _messagesController = null;
    _refreshTimer = null;
  }

  static Message fromParseObject(ParseObject object) {
    return Message(
      id: object.objectId!,
      fromUser: object.get<ParseUser>('fromUser')!,
      toUser: object.get<ParseUser>('toUser')!,
      content: object.get<String>('content')!,
      createdAt: object.createdAt,
    );
  }
}
