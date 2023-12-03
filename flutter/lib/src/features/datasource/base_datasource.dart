import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BaseDataSource {
  FirebaseFirestore _fireStore() {
    return FirebaseFirestore.instance;
  }

  CollectionReference exampleCollection() {
    return _fireStore().collection("Example");
  }

  DocumentReference exampleReference(String exampleId) {
    return exampleCollection().doc(exampleId);
  }

  FirebaseStorage _fireStorage() {
    return FirebaseStorage.instance;
  }

  Reference examplesStorage() {
    return _fireStorage().ref('Example');
  }
}
