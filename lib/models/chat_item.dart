import 'package:get/get.dart';

class ChatItem {
  ChatItem({
    required this.email,
    required this.chatId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.profileImage,
    required this.userToken,
    required this.messagesDate,
  });

  String email;
  String chatId;
  String firstName;
  String lastName;
  String userName;
  String profileImage;
  String userToken;
  DateTime messagesDate;
  RxString lastMessage = "".obs;
  var lastMessageTime = DateTime.now().obs;
  RxInt unreadCount = 0.obs;
  RxBool isYou = false.obs;
}
