import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseService {
  Future<QuerySnapshot> getCollection(String collectionPath);
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId);
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data);
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data);
  Future<void> deleteDocument(String collectionPath, String docId);
  Stream<DocumentSnapshot> streamDocument(String collectionPath, String docId);
  Future<QuerySnapshot> queryCollection(String collectionPath, {String? field, dynamic isEqualTo});
}

class FirebaseServiceImpl implements FirebaseService {
  final FirebaseFirestore _firestore;

  FirebaseServiceImpl(this._firestore);

  @override
  Future<QuerySnapshot> getCollection(String collectionPath) async {
    return await _firestore.collection(collectionPath).get();
  }

  @override
  Future<DocumentSnapshot> getDocument(String collectionPath, String docId) async {
    return await _firestore.collection(collectionPath).doc(docId).get();
  }

  @override
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).add(data);
  }

  @override
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(docId).update(data);
  }

  @override
  Future<void> deleteDocument(String collectionPath, String docId) async {
    await _firestore.collection(collectionPath).doc(docId).delete();
  }

  @override
  Stream<DocumentSnapshot> streamDocument(String collectionPath, String docId) {
    return _firestore.collection(collectionPath).doc(docId).snapshots();
  }

  @override
  Future<QuerySnapshot> queryCollection(
    String collectionPath, {
    String? field,
    dynamic isEqualTo,
  }) async {
    CollectionReference ref = _firestore.collection(collectionPath);
    Query query = ref;
    
    if (field != null && isEqualTo != null) {
      query = ref.where(field, isEqualTo: isEqualTo);
    }
    
    return await query.get();
  }
}