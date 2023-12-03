import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BaseDataSource {
  // MARK: - FireStore
  FirebaseFirestore _fireStore() {
    return FirebaseFirestore.instance;
  }

  CollectionReference userCollection() {
    return _fireStore().collection("User");
  }

  DocumentReference userReference(String userId) {
    return userCollection().doc(userId);
  }

  CollectionReference sportCollection() {
    return _fireStore().collection("User");
  }

  DocumentReference sportReference(String sportId) {
    return sportCollection().doc(sportId);
  }

  // MARK: - FireStorage
  FirebaseStorage _fireStorage() {
    return FirebaseStorage.instance;
  }

  Reference userStorage() {
    return _fireStorage().ref('User');
  }
}
