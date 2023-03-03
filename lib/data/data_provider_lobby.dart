import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/data/data_provider_lover.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

class DataProviderLobby {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Lobby> watch(Lobby lobby) {
    return _firestore
        .collection('lobby')
        .doc(lobby.id)
        .snapshots()
        .map((event) {
      Lobby lobby = Lobby.fromJson(event.data()!);
      lobby.id = event.id;
      return lobby;
    });
  }

  //create lobby
  Future<Lobby> create(Lobby lobby) async {
    DocumentReference<Map<String, dynamic>> docRef =
        await _firestore.collection('lobby').add(lobby.toJson());
    lobby.id = docRef.id;
    await docRef.update(lobby.toJson());
    return lobby;
  }

  //update lobby
  Future<void> _update(Lobby lobby) async {
    if (lobby.isEmpty()) {
      delete(lobby);
    } else {
      await _firestore.collection('lobby').doc(lobby.id).update(lobby.toJson());
    }
  }

  //update lobby
  Future<void> updateLobbyLover(Lobby lobby, Lover lover) async {
    _update(lobby);
    await DataProviderLover().update(lover);
  }

  //delete lobby
  Future<void> delete(Lobby lobby) async {
    await _firestore.collection('lobby').doc(lobby.id).delete();
  }

  //get lobby
  Future<Lobby> getSimpleId(String simpleID) async {
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
        lobby.lovers[0] = await DataProviderLover().getId(lobby.lovers[0].id);
      }
      if (lobby.lovers[1].id.isNotEmpty) {
        lobby.lovers[1] = await DataProviderLover().getId(lobby.lovers[1].id);
      }
    }
    return lobby;
  }

  Future<Lobby> get(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lobby').doc(id).get();
    Lobby lobby = Lobby.empty();

    if (snapshot.data() != null) {
      lobby = Lobby.fromJson(snapshot.data()!);
      lobby.id = snapshot.id;
      if (lobby.lovers[0].id.isNotEmpty) {
        lobby.lovers[0] = await DataProviderLover().getId(lobby.lovers[0].id);
      }
      if (lobby.lovers[1].id.isNotEmpty) {
        lobby.lovers[1] = await DataProviderLover().getId(lobby.lovers[1].id);
      }
    }
    return lobby;
  }
}
