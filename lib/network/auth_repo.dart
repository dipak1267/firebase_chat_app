import 'package:chat_demo/constants/extras.dart';
import 'package:chat_demo/models/response_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_repo.dart';

class AuthRepo {
  FirebaseAuth auth = FirebaseAuth.instance;

  /// this function register new user using email
  Future<ResponseItem> registerUserInFirebase({
    required String userFirstName,
    required String userLastName,
    required String userProfile,
    required String password,
    required String userBio,
    required String loginType,
    required String email,
  }) async {
    try {
      var response = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (response.user != null) {
        return await userRepo.addUserToFireStore(
            userFirstName: userFirstName,
            userToken: response.user!.uid,
            userLastName: userLastName,
            userProfile: userProfile,
            userBio: userBio,
            loginType: loginType,
            email: email);
      } else {
        return ResponseItem(data: null, message: errorText, status: false);
      }
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }

  /// this function authenticate userUser using email
  Future<ResponseItem> loginUserInFirebase({
    required String password,
    required String email,
  }) async {
    try {
      var response = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (response.user != null) {
        return await userRepo.getUserFromToken(userToken: response.user!.uid);
      } else {
        return ResponseItem(data: null, message: errorText, status: false);
      }
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }
}
