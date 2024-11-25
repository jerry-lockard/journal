// lib/screens/friend_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:journal/screens/messages/chat_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/auth/auth_service.dart';
import '../../services/friends/friends_service.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  FriendRequestsScreenState createState() => FriendRequestsScreenState();
}

class FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final FriendService _friendService = FriendService();
  List<ParseObject> friendRequests = [];

  void _loadFriendRequests() async {
    final user = Provider.of<AuthService>(context, listen: false).user!;
    final requests = await _friendService.getPendingRequests(user);
    setState(() {
      friendRequests = requests;
    });
  }

  void _acceptRequest(ParseObject request) async {
    bool success = await _friendService.acceptFriendRequest(request);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend request accepted')));
      _loadFriendRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to accept friend request')));
    }
  }

  void _rejectRequest(ParseObject request) async {
    bool success = await _friendService.rejectFriendRequest(request);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend request rejected')));
      _loadFriendRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reject friend request')));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
      ),
      body: ListView.builder(
        itemCount: friendRequests.length,
        itemBuilder: (context, index) {
          final request = friendRequests[index];
          final fromUser = request.get<ParseUser>('fromUser')!;
          return ListTile(
            title: Text(fromUser.username ?? 'Unknown'),
            subtitle: const Text('Sent you a friend request'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => _acceptRequest(request),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _rejectRequest(request),
                ),
                IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(otherUser: fromUser),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
