// lib/screens/search_users_screen.dart
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/auth/auth_service.dart';
import '../../services/friends/friends_service.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  SearchUsersScreenState createState() => SearchUsersScreenState();
}

class SearchUsersScreenState extends State<SearchUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ParseUser> users = [];
  final FriendService _friendService = FriendService();

  void _searchUsers() async {
    final query = QueryBuilder<ParseUser>(ParseUser.forQuery())
      ..whereContains('username', _searchController.text.trim())
      ..whereNotEqualTo('objectId',
          Provider.of<AuthService>(context, listen: false).user!.objectId);

    final response = await query.query();
    if (response.success && response.results != null) {
      setState(() {
        users = response.results!.cast<ParseUser>();
      });
    } else {
      setState(() {
        users = [];
      });
    }
  }

  void _sendFriendRequest(ParseUser toUser) async {
    final fromUser = Provider.of<AuthService>(context, listen: false).user!;
    bool success = await _friendService.sendFriendRequest(fromUser, toUser);
    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Friend request sent')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send friend request')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchUsers,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.username ?? 'Unknown'),
                  trailing: ElevatedButton(
                    onPressed: () => _sendFriendRequest(user),
                    child: const Text('Add Friend'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
