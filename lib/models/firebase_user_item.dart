import '../global.dart';

class UserItemFirebase {
  UserItemFirebase({
    required this.userToken,
    required this.userFirstName,
    required this.userLastName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.loginType,
    required this.profileImage,
  });

  String userToken;
  String userFirstName;
  String userLastName;
  String firstName;
  String lastName;
  String email;
  String profileImage;
  String loginType;

  factory UserItemFirebase.fromJson(Map<String, dynamic> json) =>
      UserItemFirebase(
        userToken: json[FirebaseStrings.userToken] ?? "",
        userFirstName: json[FirebaseStrings.userFirstName] ?? "",
        userLastName: json[FirebaseStrings.userLastName] ?? "",
        email: json[FirebaseStrings.userEmail] ?? "",
        profileImage: json[FirebaseStrings.userProfileImage] ?? "",
        firstName: json[FirebaseStrings.userFirstName] ?? "",
        loginType: json[FirebaseStrings.loinType] ?? "",
        lastName: json[FirebaseStrings.userLastName] ?? "",
      );

  Map<String, dynamic> toJson() => {
        FirebaseStrings.userToken: userToken,
        FirebaseStrings.userEmail: email,
        FirebaseStrings.userLastName: lastName,
        FirebaseStrings.loinType: loginType,
        FirebaseStrings.userFirstName: firstName,
        FirebaseStrings.userProfileImage: profileImage,
      };
}
