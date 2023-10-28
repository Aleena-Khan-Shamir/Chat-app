import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:we_chat/pages/auth/model.dart';
import 'package:we_chat/pages/chat/model.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirestoreService extends GetxService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  // to return current user info
  static User get user => auth.currentUser!;
// for storing self information
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create CollectionRefence called users that refrences the firestore collection
  static CollectionReference users = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserData>(
          fromFirestore: (snapshot, _) =>
              UserData.fromFirestore(snapshot.data()!),
          toFirestore: (userData, _) => userData.toFirestore());

  final time = DateTime.now().millisecondsSinceEpoch.toString();
  // for storing self information
  static UserData userData = UserData(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      photoUrl: user.photoURL.toString(),
      fcmtoken: '',
      about: 'I am feeling happy',
      isOnline: false,
      lastActive: '');
  //to add the data in user collection

  static Future<void> addUsers() async {
    try {
      await users.doc(userData.id).set(userData);
    } on FirebaseException catch (e) {
      log('FirestoreSerivice  $e.');
    }
  }

  // static UserData? userData;
  // to get data of current user
  static Future<void> selfInfo() async {
    try {
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        // final userDataMap = userDoc.data();
        // if (userDataMap != null) {
        userData = UserData.fromFirestore(userDoc.data()!);
        await getFirebaseMessagingToken();
        //   log('Document data is $userDataMap');
        // } else {
        //   log('Document data is null.');
        // }
      } else {
        log('Document does not exist in the database');
      }
    } catch (e) {
      log(e.toString());
    }
  }

// push notification
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static Future<void> getFirebaseMessagingToken() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await messaging.getToken().then((value) {
      if (value != null) {
        userData.fcmtoken = value;
        log('push token : $value');
      }
    });
  }

  // for sending push notiifcation
  static Future<void> sendPushNotification(
      UserData chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.fcmtoken,
        "notification": {'title': userData.name, "body": msg},
        "android_channel_id": "chats"
      };
      var resp = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAa6baXDE:APA91bHDG3lNsFKUnIwvf1rcAk_jM9LYXrr5yy3nms0mMh2HHFfJ6stWNrch5o3POTTQxxTZUYGFhE_-bVOsss3tKm6D_PywQWMtGcBt6qACJn1q6aEbJAK84-rqrr9GGHBYxHRxWqJ3'
          },
          body: jsonEncode(body));
      log('Response time: ${resp.statusCode}');

      log('Response body: ${resp.body}');
    } catch (e, stackTrace) {
      log('Send Notification $e');
      log('Stack Trace: $stackTrace');
    }
  }

  Future uploadPhoto(File photo) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('image').child(user.uid);
      await ref.putFile(photo).then(
          (p0) => log('Data Transferred: ${p0.bytesTransferred / 1000}kb'));

      // for storing photoURL in firestore
      userData.photoUrl = await ref.getDownloadURL();
      await firestore
          .collection('users')
          .doc(user.uid)
          .update({"photoUrl": userData.photoUrl})
          .then((value) => log("User Updated: ${userData.photoUrl}"))
          .catchError((error) => log("Failed to update user: $error"));
    } catch (e) {
      log('Upload image error $e');
    }
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists
      return false;
    }
  }

// to get id's frm known users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersIds() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

// to get data
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return firestore
        .collection('users')
        .where('id', whereIn: userIds.isEmpty ? [''] : userIds)
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserData chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

// update online or last active status of user
  static Future<void> updataActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch,
      'fcmtoken': userData.fcmtoken,
    });
  }

  // to update data
  static Future<void> updataUsersData(UserData user) async {
    await firestore
        .collection('users')
        .doc(user.id)
        .update({
          "name": user.name,
          "about": user.about,
        })
        .then((value) => log("User Updated "))
        .catchError((error) => log("Failed to update user: $error"));
  }

  ///*******************For Chatting **************************** */

// chat(collection)-->conversation_id(doc)-->messages(collection)-->message(doc)

//getting conversation id
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // to getting all the messages of specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      UserData userData) {
    return firestore
        .collection('chats/${getConversationId(userData.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }
  // for adding a user to my user when first message is send

  static Future<void> sendFirstMessages(
      UserData chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessages(chatUser, msg, type));
  }

  // for sending messages
  static Future<void> sendMessages(
      UserData chatUser, String msg, Type type) async {
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // message to send
    final Message message = Message(
        toId: chatUser.id,
        fromId: user.uid,
        msg: msg,
        read: '',
        sent: time,
        type: type);
    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(userData, type == Type.text ? msg : "Photo"));
  }

  // update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get only last message of specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      UserData userData) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationId(userData.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // send image in chat
  static Future sendImageWithChat(UserData user, File photo) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
          'chat Images/${getConversationId(user.id)}/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(photo).then(
          (p0) => log('Data Transferred: ${p0.bytesTransferred / 1000}kb'));

      // for storing photoURL in firestore
      final imageUrl = await ref.getDownloadURL();
      await sendMessages(user, imageUrl, Type.image);
    } catch (e) {
      log('Upload image error $e');
    }
  }
}
