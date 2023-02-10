import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

class DataProviderLobby {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create lobby
  Future<Lobby> create(Lobby lobby) async {
    DocumentReference<Map<String, dynamic>> docRef =
        await _firestore.collection('lobby').add(lobby.toJson());
    lobby.id = docRef.id;
    await docRef.update(lobby.toJson());
    return lobby;
  }

  //update lobby
  Future<void> update(Lobby lobby) async {
    await _firestore.collection('lobby').doc(lobby.id).update(lobby.toJson());
  }

  //delete lobby
  Future<void> delete(Lobby lobby) async {
    await _firestore.collection('lobby').doc(lobby.id).delete();
  }

  //get lobby
  Future<Lobby> get(String simpleID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('lobby')
        .where('simpleID', isEqualTo: simpleID.toUpperCase())
        .get();
    Lobby lobby = Lobby.empty();
    if (snapshot.docs.isEmpty) {
      return lobby;
    }
    QueryDocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;
    if (doc.exists) {
      lobby = Lobby.fromJson(doc.data());
      lobby.id = doc.id;
      if (lobby.lovers[0].id.isNotEmpty) {
        lobby.lovers[0] = await DataProviderLover().get(lobby.lovers[0].id);
      }
      if (lobby.lovers[1].id.isNotEmpty) {
        lobby.lovers[1] = await DataProviderLover().get(lobby.lovers[1].id);
      }
    }
    return lobby;
  }

  //remove lover from lobby
  Future<void> removeLover(Lobby lobby, Lover lover) async {
    if (lobby.lovers[0].id == lover.id) {
      lobby.lovers[0].lobbyId = '';
    } else {
      lobby.lovers[1].lobbyId = '';
    }
    await update(lobby);
  }
}
