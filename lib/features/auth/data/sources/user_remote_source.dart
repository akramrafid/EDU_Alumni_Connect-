import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_storage/firebase_storage.dart' as st;
import '../models/user_model.dart';

abstract class IUserRemoteSource {
  Future<void> createUserDocument(UserModel user);
  Future<UserModel?> getUserDocument(String uid);
  Future<void> updateUserDocument(String uid, Map<String, dynamic> data);
  Future<String> uploadCertificate(String uid, File file);
  Future<String> uploadProfileImage(String uid, File file);
  Future<String> uploadCoverImage(String uid, File file);
}

class FirestoreUserRemoteSource implements IUserRemoteSource {
  final fs.FirebaseFirestore _firestore;
  final st.FirebaseStorage _storage;

  FirestoreUserRemoteSource(this._firestore, this._storage);

  @override
  Future<void> createUserDocument(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toFirestore());
  }

  @override
  Future<UserModel?> getUserDocument(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (doc.exists && data != null) {
      return UserModel.fromFirestore(data, doc.id);
    }
    return null;
  }

  @override
  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update({
      ...data,
      'updatedAt': fs.FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<String> uploadCertificate(String uid, File file) async {
    final fileExtension = file.path.split('.').last;
    final ref = _storage.ref().child('certificates/$uid.$fileExtension');
    final uploadTask = await ref.putFile(file);
    return uploadTask.ref.getDownloadURL();
  }

  @override
  Future<String> uploadProfileImage(String uid, File file) async {
    try {
      final fileExtension = file.path.split('.').last;
      final ref = _storage.ref().child('profiles/$uid/avatar.$fileExtension');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (_) {
      // Storage fallback: use base64 if small (< 350KB), otherwise file path
      // to avoid exceeding Firestore's 1MB document size limit.
      final bytes = await file.readAsBytes();
      if (bytes.length < 350000) {
        final base64String = base64Encode(bytes);
        final mimeType = file.path.endsWith('.png') ? 'image/png' : 'image/jpeg';
        return 'data:$mimeType;base64,$base64String';
      }
      return file.path;
    }
  }

  @override
  Future<String> uploadCoverImage(String uid, File file) async {
    try {
      final fileExtension = file.path.split('.').last;
      final ref = _storage.ref().child('profiles/$uid/cover.$fileExtension');
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (_) {
      // Storage fallback: use base64 if small (< 350KB), otherwise file path
      // to avoid exceeding Firestore's 1MB document size limit.
      final bytes = await file.readAsBytes();
      if (bytes.length < 350000) {
        final base64String = base64Encode(bytes);
        final mimeType = file.path.endsWith('.png') ? 'image/png' : 'image/jpeg';
        return 'data:$mimeType;base64,$base64String';
      }
      return file.path;
    }
  }
}
