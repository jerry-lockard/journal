// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth/auth_service.dart';
import '../../services/profile/profile_service.dart';
import '../../models/profile/profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  Profile? profile;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  void _loadProfile() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user!;
    Profile? fetchedProfile = await _profileService.getProfile(user);

    if (fetchedProfile == null) {
      await _profileService.createProfile(user);
      fetchedProfile = await _profileService.getProfile(user);
    }

    setState(() {
      profile = fetchedProfile;
      _fullNameController.text = profile?.fullName ?? '';
      _bioController.text = profile?.bio ?? '';
    });
  }

  void _saveProfile() async {
    if (profile != null) {
      profile!.fullName = _fullNameController.text.trim();
      profile!.bio = _bioController.text.trim();
      await _profileService.updateProfile(profile!);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile updated')));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(profile!.username)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add profile picture handling here
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(labelText: 'Bio'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProfile, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
