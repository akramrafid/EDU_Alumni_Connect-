import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  final ImagePicker _picker = ImagePicker();

  @override
  FutureOr<void> build() {}

  /// Pick profile picture from Gallery or Camera and update Firestore
  Future<bool> updateProfilePhoto(ImageSource source) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    try {
      state = const AsyncLoading();

      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        state = const AsyncData(null);
        return false;
      }

      final file = File(pickedFile.path);
      final userRemote = ref.read(userRemoteSourceProvider);
      final firestore = ref.read(firebaseFirestoreProvider);

      // Upload image to Storage (or fallback base64)
      final photoUrl = await userRemote.uploadProfileImage(user.uid, file);

      // Update Firestore user document
      await firestore.collection('users').doc(user.uid).update({
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Remove profile picture
  Future<bool> removeProfilePhoto() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    try {
      state = const AsyncLoading();
      final firestore = ref.read(firebaseFirestoreProvider);

      await firestore.collection('users').doc(user.uid).update({
        'photoUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Pick cover photo from Gallery or Camera and update Firestore
  Future<bool> updateCoverPhoto(ImageSource source) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    try {
      state = const AsyncLoading();

      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        state = const AsyncData(null);
        return false;
      }

      final file = File(pickedFile.path);
      final userRemote = ref.read(userRemoteSourceProvider);
      final firestore = ref.read(firebaseFirestoreProvider);

      // Upload cover image to Storage (or fallback base64)
      final coverPhotoUrl = await userRemote.uploadCoverImage(user.uid, file);

      // Update Firestore user document
      await firestore.collection('users').doc(user.uid).update({
        'coverPhotoUrl': coverPhotoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Remove cover photo
  Future<bool> removeCoverPhoto() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    try {
      state = const AsyncLoading();
      final firestore = ref.read(firebaseFirestoreProvider);

      await firestore.collection('users').doc(user.uid).update({
        'coverPhotoUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Update profile photo directly from a File (e.g. dragged from PC)
  Future<bool> updateProfilePhotoFromFile(File file) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    try {
      state = const AsyncLoading();
      final userRemote = ref.read(userRemoteSourceProvider);
      final firestore = ref.read(firebaseFirestoreProvider);

      final photoUrl = await userRemote.uploadProfileImage(user.uid, file);

      await firestore.collection('users').doc(user.uid).update({
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Update cover photo directly from a File (e.g. dragged from PC)
  Future<bool> updateCoverPhotoFromFile(File file) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    try {
      state = const AsyncLoading();
      final userRemote = ref.read(userRemoteSourceProvider);
      final firestore = ref.read(firebaseFirestoreProvider);

      final coverUrl = await userRemote.uploadCoverImage(user.uid, file);

      await firestore.collection('users').doc(user.uid).update({
        'coverPhotoUrl': coverUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Update profile photo from direct URL/Preset
  Future<bool> updateProfilePhotoFromUrl(String photoUrl) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    try {
      state = const AsyncLoading();
      final firestore = ref.read(firebaseFirestoreProvider);

      await firestore.collection('users').doc(user.uid).update({
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Update cover photo from direct URL/Preset
  Future<bool> updateCoverPhotoFromUrl(String coverUrl) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return false;

    try {
      state = const AsyncLoading();
      final firestore = ref.read(firebaseFirestoreProvider);

      await firestore.collection('users').doc(user.uid).update({
        'coverPhotoUrl': coverUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
