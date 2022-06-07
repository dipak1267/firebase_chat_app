import 'dart:developer';

import 'package:chat_demo/global.dart';
import 'package:chat_demo/models/chat_item.dart';
import 'package:chat_demo/models/firebase_user_item.dart';
import 'package:chat_demo/models/response_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

///Firebase Firestore Table Schema
///-users(collection)
///   -user_token(document)->set userId as document name
///       -email(string)
///       -first_name(string)
///       -last_name(string)
///       -profile_image(string)
///       -user_token(string)
///       -user_name(string)
///-Conversations(collection)
///   -userToken1_userToken2(document)
///       -chat_id(string)->same as document name userToken1_userToken2
///       -unReadCount(Map)
///         -userToken(String)->int ->used for manage unread count
///         -userToken(String)->int ->used for manage unread count
///       -timestamp(string)->used for sorting
///       -lastMessage(string)->last message of conversation
///       -userIDs(array)
///           -0(string)->userId1
///           -1(string)->userId2
///       -Messages(collection)
///           -list(documents)->chat saved in list of document between two users like userId1 and userId2
///               -message(string)
///               -timestamp(string)->used for sorting
///               -sent_by_id(string)->for future reference

class ChatRepo {
  String userToken = preferences.getString(SharedPreference.USER_TOKEN);
  final uuid = const Uuid();

  /// Get users list with except current logged in user
  /// after this get those user's last message weather it is sent by current
  /// logged in user or other user. check _generateLastMessageList().
  Future<ResponseItem> getUserList() async {
    try {
      var docs = FirebaseFirestore.instance
          .collection(FirebaseStrings.conversationTBL);
      docs.get();
      QuerySnapshot conversations = await docs
          .where(FirebaseStrings.userIDs, arrayContains: userToken)
          .get();

      List<ChatItem> chatItems = [];
      for (int i = 0; i < conversations.docs.length; i++) {
        var conversation = conversations.docs[i];

        String opoUserToken = "";
        if (conversation[FirebaseStrings.userIDs][0] != userToken) {
          opoUserToken = conversation[FirebaseStrings.userIDs][0];
        } else {
          opoUserToken = conversation[FirebaseStrings.userIDs][1];
        }

        UserItemFirebase? opoUserItem =
            await getUserData(userToken: opoUserToken);

        if (opoUserItem != null) {
          var chatItem = ChatItem(
            messagesDate: DateTime.now(),
            email: opoUserItem.email,
            firstName: opoUserItem.firstName,
            lastName: opoUserItem.lastName,
            profileImage: opoUserItem.profileImage,
            userToken: opoUserItem.userToken,
            userName: opoUserItem.userName,
            chatId: conversation[FirebaseStrings.chatId],
          );
          chatItem.lastMessage.value =
              conversation[FirebaseStrings.lastMessage];

          chatItem.messagesDate = DateTime.fromMillisecondsSinceEpoch(
              conversation[FirebaseStrings.timestamp]);
          chatItem.lastMessageTime.value = chatItem.messagesDate;

          // chatItem.unreadCount.value =
          //     conversation[FirebaseStrings.unreadCount];
          chatItems.add(chatItem);
        }
      }
      return ResponseItem(
          data: chatItems, message: "Get users successfully.", status: true);
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }

  Future<ResponseItem> getUserListStream() async {
    try {
      var docs = FirebaseFirestore.instance
          .collection(FirebaseStrings.conversationTBL);
      docs.get();
      Stream<QuerySnapshot<Map<String, dynamic>>> conversations = docs
          .where(FirebaseStrings.userIDs, arrayContains: userToken)
          .snapshots();
      return ResponseItem(
          data: conversations,
          message: "Get users successfully.",
          status: true);
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }

  /// Get chats between two users
  /// First check userId2_userId1 chatRoom is already available or not if it is
  /// get all chats and sort it on the basis of message sent time.
  /// otherwise consider userId1_userId2 as chatId and start conversation.
  Future<ResponseItem> getChatList(String opoUSerToken) async {
    try {
      var chatRoomId = "${userToken}_$opoUSerToken";
      bool isExist =
          await _checkIfChatRoomDocExists("${opoUSerToken}_$userToken");
      if (isExist) chatRoomId = "${opoUSerToken}_$userToken";

      bool isChatExist = await _checkIfChatRoomDocExists(chatRoomId);

      if (!isChatExist) {
        return ResponseItem(
            data: null, message: "No data available", status: false);
      }

      Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore
          .instance
          .collection(FirebaseStrings.conversationTBL)
          .doc(chatRoomId)
          .collection(FirebaseStrings.messageCollection)
          .orderBy(FirebaseStrings.timestamp, descending: true)
          .snapshots();

      return ResponseItem(data: snapshot, message: "Chat list", status: true);
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }

  /// Add chat in selected user chatRoom
  /// First check userId2_userId1 chatRoom is already available or not
  /// if it is available chat_id of this two user is userId1_userId2 other vice chat_id of this two user is userId2_userId1
  /// then add chat data in Messages collection inside conversation collection  document on chat_id
  /// then last_messages data inside conversation collection where documentId is chat_room_id with last_message, messageTime,unReadCount and more.
  Future<ResponseItem> addChat(
      {required String opoUSerToken, required String message}) async {
    try {
      var chatRoomId = "${userToken}_$opoUSerToken";
      bool isExist =
          await _checkIfChatRoomDocExists("${opoUSerToken}_$userToken");
      if (isExist) chatRoomId = "${opoUSerToken}_$userToken";

      int messageTime = DateTime.now().millisecondsSinceEpoch;
      String uniqueId = uuid.v1();

      int unreadCount =
          await getUnreadCount(chatId: chatRoomId, userToken: opoUSerToken);
      Map<String, dynamic> chatData = {
        FirebaseStrings.contentType: 1,
        FirebaseStrings.messageId: uniqueId,
        FirebaseStrings.senderId: userToken,
        FirebaseStrings.timestamp: messageTime,
        FirebaseStrings.message: message,
      };
      DocumentReference documentReference = await FirebaseFirestore.instance
          .collection(FirebaseStrings.conversationTBL)
          .doc(chatRoomId)
          .collection(FirebaseStrings.messageCollection)
          .add(chatData);

      await FirebaseFirestore.instance
          .collection(FirebaseStrings.conversationTBL)
          .doc(chatRoomId)
          .set({
        FirebaseStrings.chatId: chatRoomId,
        FirebaseStrings.userIDs: [opoUSerToken, userToken],
        FirebaseStrings.lastMessage: message,
        FirebaseStrings.timestamp: messageTime,
        FirebaseStrings.senderId: userToken,
        FirebaseStrings.unReadCount: {
          opoUSerToken: unreadCount + 1,
          userToken: 0
        }
      });

      return ResponseItem(
          data: documentReference,
          message: "Add message successfully.",
          status: true);
    } catch (exception) {
      return ResponseItem(data: null, message: errorText, status: false);
    }
  }

  /// Will check if chatRoomId is available or not in chat_room collection
  Future<bool> _checkIfChatRoomDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance
          .collection(FirebaseStrings.conversationTBL);

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  /// This function return stream of data using given chatId
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>?> receiveMessageChat(
      String chatId) async {
    try {
      bool isExist = await _checkIfChatRoomDocExists(chatId);
      if (isExist) {
        Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot =
            FirebaseFirestore.instance
                .collection(FirebaseStrings.conversationTBL)
                .doc(chatId)
                .snapshots();

        return snapshot;
      } else {
        return null;
      }
    } catch (exception) {
      return null;
    }
  }

  /// This function return Last message data of given chatId
  Future<DocumentSnapshot?> getLatestMessageData(
      {required String chatId}) async {
    var collection =
        FirebaseFirestore.instance.collection(FirebaseStrings.conversationTBL);
    DocumentSnapshot data = await collection
        .doc(chatId) // <-- Doc ID where data should be updated.
        .get();

    if (data.exists) {
      return data;
    } else {
      return null;
    }
  }

  /// This function return unReadCount of user in specific chatRoom
  Future<int> getUnreadCount(
      {required String chatId, required String userToken}) async {
    try {
      var collection = FirebaseFirestore.instance
          .collection(FirebaseStrings.conversationTBL);
      DocumentSnapshot data = await collection
          .doc(chatId) // <-- Doc ID where data should be updated.
          .get();
      if (data.exists) {
        return data[FirebaseStrings.unReadCount][userToken];
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  /// This function clear unread count of current user when user chat with other user
  clearUnreadCount({required String opoUserToken}) async {
    try {
      var chatRoomId = "${userToken}_$opoUserToken";
      bool isExist =
          await _checkIfChatRoomDocExists("${opoUserToken}_$userToken");
      if (isExist) chatRoomId = "${opoUserToken}_$userToken";

      int unreadCount =
          await getUnreadCount(chatId: chatRoomId, userToken: opoUserToken);

      var collection = FirebaseFirestore.instance
          .collection(FirebaseStrings.conversationTBL);

      var a = await collection.doc(chatRoomId).get();
      if (a.exists) {
        await collection
            .doc(chatRoomId) // <-- Doc ID where data should be updated.
            .update({
          FirebaseStrings.unReadCount: {
            userToken: 0,
            opoUserToken: unreadCount
          },
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Get userData
  Future<UserItemFirebase?> getUserData({required String userToken}) async {
    var collection =
        FirebaseFirestore.instance.collection(FirebaseStrings.userTBL);
    DocumentSnapshot userdata = await collection
        .doc(userToken) // <-- Doc ID where data should be updated.
        .get();
    if (userdata.exists) {
      Map<String, dynamic> data = userdata.data() as Map<String, dynamic>;
      UserItemFirebase user = UserItemFirebase.fromJson(data);

      return user;
    } else {
      return null;
    }
  }
}
