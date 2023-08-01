import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sunrise/entity/lover_entity.dart';

class DataProviderLover {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create lover
  Future<LoverEntity> create(LoverEntity lover) async {
    DocumentReference<Map<String, dynamic>> docRef =
        await _firestore.collection('lovers').add(lover.toJson());
    lover.id = docRef.id;
    return lover;
  }

  //set
  Future<LoverEntity> set(LoverEntity lover) async {
    await _firestore.collection('lovers').doc(lover.id).set(lover.toJson());
    return lover;
  }

  //update lover
  Future<void> update(LoverEntity lover) async {
    await _firestore.collection('lovers').doc(lover.id).update(lover.toJson());
  }

  //delete lover
  Future<void> delete(LoverEntity lover) async {
    await _firestore.collection('lovers').doc(lover.id).delete();
  }

  //get lover
  Future<LoverEntity> getUser(User user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lovers').doc(user.uid).get();
    if (snapshot.exists) {
      LoverEntity lover = LoverEntity.fromJson(snapshot.data()!);
      lover.id = snapshot.id;
      return lover;
    } else {
      LoverEntity lover = await set(LoverEntity.fromUser(user));
      return lover;
    }
  }

  Future<LoverEntity> get(String id) async {
    if (id.isEmpty) return LoverEntity.empty();
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lovers').doc(id).get();
    if (snapshot.exists) {
      LoverEntity lover = LoverEntity.fromJson(snapshot.data()!);
      lover.id = snapshot.id;
      return lover;
    }
    return LoverEntity.empty();
  }

  //remove lobby
  Future<void> removeLobby(LoverEntity lover) async {
    lover.lobbyId = '';
    await update(lover);
  }
}
