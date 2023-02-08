import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/model/model_lover.dart';

class DataProviderLover {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create lover
  Future<Lover> create(Lover lover) async {
    DocumentReference<Map<String, dynamic>> docRef =
        await _firestore.collection('lover').add(lover.toJson());
    lover.id = docRef.id;
    return lover;
  }

  //update lover
  Future<void> update(Lover lover) async {
    await _firestore.collection('lover').doc(lover.id).update(lover.toJson());
  }

  //delete lover
  Future<void> delete(Lover lover) async {
    await _firestore.collection('lover').doc(lover.id).delete();
  }

  //get lover
  Future<Lover> get(String id) async {
    if (id.isEmpty) {
      return Lover(id: id);
    }
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lover').doc(id).get();
    if (snapshot.exists) {
      Lover lover = Lover.fromJson(snapshot.data()!);
      lover.id = id;
      return lover;
    } else {
      return Lover(id: id);
    }
  }

  //remove lobby
  Future<void> removeLobby(Lover lover) async {
    lover.lobbyId = '';
    await update(lover);
  }
}
