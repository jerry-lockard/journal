// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:journal/models/post/post.dart';
import 'package:journal/screens/friends/friend_requests_screen.dart';
import 'package:journal/screens/profile/profile_screen.dart';
import 'package:journal/screens/search/search_users_screen.dart';
import 'package:journal/services/auth/auth_service.dart';
import 'package:journal/services/post/post_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();
  List<Post> posts = [];
  final TextEditingController _postController = TextEditingController();

  void _loadPosts() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user!;
    List<Post> fetchedPosts = await _postService.getPosts(user);

    setState(() {
      posts = fetchedPosts;
    });
  }

  void _createPost() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user!;
    await _postService.createPost(_postController.text.trim(), user);
    _postController.clear();
    _loadPosts();
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchUsersScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FriendRequestsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _postController,
            decoration: const InputDecoration(
              hintText: 'What\'s on your mind?',
              contentPadding: EdgeInsets.all(16),
            ),
          ),
          ElevatedButton(onPressed: _createPost, child: const Text('Post')),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.user.username ?? 'Unknown'),
                  subtitle: Text(post.content),
                  trailing: Text(
                    post.createdAt.toLocal().toString(),
                    style: const TextStyle(fontSize: 12),
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
