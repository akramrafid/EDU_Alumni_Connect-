import 'package:firebase_auth/firebase_auth.dart' as fb;

abstract class IAuthRemoteSource {
  Future<fb.UserCredential> signInWithEmail(String email, String password);
  Future<fb.UserCredential> registerWithEmail(String email, String password);
  Future<void> signOut();
  Future<void> sendVerificationEmail();
  fb.User? getCurrentUser();
  Stream<fb.User?> authStateChanges();
  Future<fb.IdTokenResult?> getIdTokenResult(fb.User user);
}

class FirebaseAuthRemoteSource implements IAuthRemoteSource {
  final fb.FirebaseAuth _firebaseAuth;

  FirebaseAuthRemoteSource(this._firebaseAuth);

  @override
  Future<fb.UserCredential> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<fb.UserCredential> registerWithEmail(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  @override
  fb.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Stream<fb.User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<fb.IdTokenResult?> getIdTokenResult(fb.User user) {
    return user.getIdTokenResult(true);
  }
}
