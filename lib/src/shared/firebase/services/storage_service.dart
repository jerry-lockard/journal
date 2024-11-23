import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_config.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<String?> uploadFile({
    required File file,
    required String path,
    String? customFileName,
  }) async {
    try {
      if (_userId.isEmpty) throw Exception('User must be logged in');

      final fileName = customFileName ?? '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final ref = _storage.ref().child('$path/$_userId/$fileName');
      
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  Future<String?> uploadJournalImage(File imageFile) async {
    return uploadFile(
      file: imageFile,
      path: FirebaseConfig.journalImagesPath,
    );
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    return uploadFile(
      file: imageFile,
      path: FirebaseConfig.userProfileImagesPath,
    );
  }
}
