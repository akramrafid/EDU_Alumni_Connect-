import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../features/auth/data/sources/auth_remote_source.dart';
import '../../features/auth/data/sources/user_remote_source.dart';
import '../../features/auth/data/models/user_model.dart';

class DummyAuthRemoteSource implements IAuthRemoteSource {
  @override
  Future<fb.UserCredential> signInWithEmail(String email, String password) => throw UnimplementedError('Firebase not configured');

  @override
  Future<fb.UserCredential> registerWithEmail(String email, String password) => throw UnimplementedError('Firebase not configured');

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendVerificationEmail() async {}

  @override
  fb.User? getCurrentUser() => null;

  @override
  Stream<fb.User?> authStateChanges() => Stream.value(null);

  @override
  Future<fb.IdTokenResult?> getIdTokenResult(fb.User user) => throw UnimplementedError('Firebase not configured');
}

class DummyUserRemoteSource implements IUserRemoteSource {
  @override
  Future<void> createUserDocument(UserModel user) async {}

  @override
  Future<UserModel?> getUserDocument(String uid) async => null;

  @override
  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {}

  @override
  Future<String> uploadCertificate(String uid, File file) async => '';

  @override
  Future<String> uploadProfileImage(String uid, File file) async => file.path;

  @override
  Future<String> uploadCoverImage(String uid, File file) async => file.path;
}
