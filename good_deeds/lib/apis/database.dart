import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:good_deeds/constants/categories.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserData(String uid, String email, String name) async {
    try {
      await _db.collection('users').get().then((value) async {
        await _db.collection('users').doc(uid).set({
          'id': value.docs.length + 1,
          'email': email,
          'name': name,
          'uid': uid,
          'review': 5,
          'chats': [],
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    try {
      return await _db.collection('users').doc(uid).get();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> addCurrentUserToService(String serviceId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await _db.collection('service').doc(serviceId).update({
        'availableUsers': FieldValue.arrayUnion([user!.uid]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<DocumentSnapshot>> getUsersByIds(List<String> userIds) {
    if (userIds.isEmpty) {
      return const Stream.empty();
    }
    try {
      return _db
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> addRequest(
    String uid,
    Map<String, dynamic> userData,
    String taskName,
    String serviceDescription,
    String category,
    String location,
  ) async {
    try {
      await _db.collection('service').add({
        'id': userData['id'],
        'personName': userData['name'],
        'taskName': taskName,
        'serviceDescription': serviceDescription,
        'category': categoriesMap[category],
        'isOpen': true,
        'isAccepted': false,
        'requestedUser': uid,
        'acceptedUser': '',
        'availableUsers': [],
        'chatId': '',
        'contactInfo': userData['email'],
        'dateOfRequest': Timestamp.now(),
        'location': location,
        'review': 3,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<DocumentSnapshot> getUserDetailsById(String userId) {
    if (userId.isEmpty) {
      return const Stream.empty();
    }
    try {
      return _db.collection('users').doc(userId).snapshots();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> acceptServiceRequest(
    String serviceId,
    String acceptedUserId,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Update the service request to mark it as accepted
      await _db.collection('service').doc(serviceId).update({
        'isAccepted': true,
        'acceptedUser': acceptedUserId,
      });

      // Create a new chat collection for the accepted service request
      DocumentReference chatRef = await _db
          .collection('service')
          .doc(serviceId)
          .collection('chats')
          .add({
        'serviceId': serviceId,
        'requestUser': acceptedUserId,
        'messages': [],
        'serviceUser': user!.uid,
      });

      // Update the service request with the chatId
      await _db.collection('service').doc(serviceId).update({
        'chatId': chatRef.id,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendMessage(
    String serviceId,
    String chatId,
    String senderId,
    String message,
  ) async {
    try {
      await _db
          .collection('service')
          .doc(serviceId)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'message': message,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<DocumentSnapshot>> getMessages(String serviceId, String chatId) {
    try {
      return _db
          .collection('service')
          .doc(serviceId)
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
