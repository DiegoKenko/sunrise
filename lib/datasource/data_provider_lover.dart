import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sunrise/model/model_lover.dart';

class DataProviderLover {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create lover
  Future<Lover> create(Lover lover) async {
    DocumentReference<Map<String, dynamic>> docRef =
        await _firestore.collection('lovers').add(lover.toJson());
    lover.id = docRef.id;
    return lover;
  }

  //set
  Future<Lover> set(Lover lover) async {
    await _firestore.collection('lovers').doc(lover.id).set(lover.toJson());
    return lover;
  }

  //update lover
  Future<void> update(Lover lover) async {
    await _firestore.collection('lovers').doc(lover.id).update(lover.toJson());
  }

  //delete lover
  Future<void> delete(Lover lover) async {
    await _firestore.collection('lovers').doc(lover.id).delete();
  }

  //get lover
  Future<Lover> getUser(User user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lovers').doc(user.uid).get();
    if (snapshot.exists) {
      Lover lover = Lover.fromJson(snapshot.data()!);
      lover.id = snapshot.id;
      return lover;
    } else {
      Lover lover = await set(Lover.fromUser(user));
      return lover;
    }
  }

  Future<Lover> get(String id) async {
    if (id.isEmpty) return Lover.empty();
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lovers').doc(id).get();
    if (snapshot.exists) {
      Lover lover = Lover.fromJson(snapshot.data()!);
      lover.id = snapshot.id;
      return lover;
    }
    return Lover.empty();
  }

  //remove lobby
  Future<void> removeLobby(Lover lover) async {
    lover.lobbyId = '';
    await update(lover);
  }
}
