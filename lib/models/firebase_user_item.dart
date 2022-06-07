import '../global.dart';

class UserItemFirebase {
  UserItemFirebase({
    required this.userToken,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
  });

  String userToken;
  String userName;
  String firstName;
  String lastName;
  String email;
  String profileImage;

  factory UserItemFirebase.fromJson(Map<String, dynamic> json) =>
      UserItemFirebase(
        userToken: json[FirebaseStrings.userToken] ?? "",
        userName: json[FirebaseStrings.userName] ?? "",
        email: json[FirebaseStrings.userEmail] ?? "",
        profileImage: json[FirebaseStrings.userProfileImage] ?? "",
        firstName: json[FirebaseStrings.userFirstName] ?? "",
        lastName: json[FirebaseStrings.userLastName] ?? "",
      );

  Map<String, dynamic> toJson() => {
        FirebaseStrings.userToken: userToken,
        FirebaseStrings.userName: userName,
        FirebaseStrings.userEmail: email,
        FirebaseStrings.userLastName: FirebaseStrings.userLastName,
        FirebaseStrings.userFirstName: firstName,
        FirebaseStrings.userProfileImage: profileImage,
      };
}
