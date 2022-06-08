import 'package:chat_demo/models/firebase_user_item.dart';
import 'package:chat_demo/models/response_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../global.dart';

final UserRepo userRepo = UserRepo();

class UserRepo {
  /// this function use when user authenticate in this app
  /// this function store user data in fireStore
  Future<ResponseItem> addUserToFireStore({
    required String userFirstName,
    required String userToken,
    required String userLastName,
    required String userProfile,
    required String userBio,
    required String loginType,
    required String email,
  }) async {
    try {
      Map<String, dynamic> userData = {
        FirebaseStrings.userToken: userToken,
        FirebaseStrings.userEmail: email,
        FirebaseStrings.userFirstName: userFirstName,
        FirebaseStrings.userLastName: userLastName,
        FirebaseStrings.userBio: userBio,
        FirebaseStrings.userProfileImage: "",
        FirebaseStrings.loinType: loginType,
      };

      await FirebaseFirestore.instance
          .collection(FirebaseStrings.userTBL)
          .add(userData);
      UserItemFirebase userItemFirebase = UserItemFirebase.fromJson(userData);
      return ResponseItem(
          data: userItemFirebase,
          message: "Add user successfully.",
          status: true);
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }

  /// this function get user data from user_token
  Future<ResponseItem> getUserFromToken({
    required String userToken,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userResponseData =
          await FirebaseFirestore.instance
              .collection(FirebaseStrings.userTBL)
              .doc(userToken)
              .get();

      UserItemFirebase userItemFirebase =
          UserItemFirebase.fromJson(userResponseData as Map<String, dynamic>);

      return ResponseItem(
          data: userItemFirebase,
          message: "Add user successfully.",
          status: true);
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }

  /// this function update user data in fireStore
  Future<ResponseItem> updateUserToFireStore({
    required String userFirstName,
    required String userToken,
    required String userLastName,
    required String userProfile,
    required String userBio,
    required String loginType,
    required String email,
  }) async {
    try {
      Map<String, dynamic> userData = {
        FirebaseStrings.userToken: userToken,
        FirebaseStrings.userEmail: email,
        FirebaseStrings.userFirstName: userFirstName,
        FirebaseStrings.userLastName: userLastName,
        FirebaseStrings.userBio: userBio,
        FirebaseStrings.userProfileImage: "",
        // FirebaseStrings.loinType: loginType,
      };

      await FirebaseFirestore.instance
          .collection(FirebaseStrings.userTBL)
          .doc(userToken)
          .update(userData);

      return ResponseItem(
          data: userData,
          message: "Update user detail successfully.",
          status: true);
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }
}
