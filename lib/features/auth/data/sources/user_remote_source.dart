import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_storage/firebase_storage.dart' as st;
import '../models/user_model.dart';

abstract class IUserRemoteSource {
  Future<void> createUserDocument(UserModel user);
  Future<UserModel?> getUserDocument(String uid);
  Future<void> updateUserDocument(String uid, Map<String, dynamic> data);
  Future<String> uploadCertificate(String uid, File file);
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
    // Save as certificates/{uid} with its extension or default to jpg/pdf depending on selection
    final fileExtension = file.path.split('.').last;
    final ref = _storage.ref().child('certificates/$uid.$fileExtension');
    final uploadTask = await ref.putFile(file);
    return uploadTask.ref.getDownloadURL();
  }
}
