//this is copied wholesale from https://medium.com/@adityadroid/60-days-of-flutter-building-a-messenger-day-15-17-implementing-registration-screen-using-d3a708d866a9
//i didn't write this!!!!

abstract class BaseAuthenticationProvider {
  Future<FirebaseUser> signInWithGoogle();

  Future<void> signOutUser();

  Future<FirebaseUser> getCurrentUser();

  Future<bool> isLoggedIn();
}

abstract class BaseUserDataProvider {
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);

  Future<User> saveProfileDetails(
      String uid, String profileImageUrl, int age, String username);

  Future<bool> isProfileComplete(String uid);
}

abstract class BaseStorageProvider {
  Future<String> uploadImage(File file, String path);
}

abstract class BaseMessageProvider {
  Future<String> uploadImage(File file, String path);
}
