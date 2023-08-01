// ignore_for_file: sdk_version_since

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

class DataProviderLobby {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<LobbyEntity> watch(LobbyEntity lobby) async* {
    Stream<LobbyEntity> lobbyStream = Stream<LobbyEntity>.value(lobby);
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        _firestore.collection('lobby').doc(lobby.id).snapshots();
    stream.listen((event) async {
      if (event.exists) {
        lobby = LobbyEntity.fromJson(event.data()!);
        lobby.id = event.id;
        lobby.lovers[0] = await DataProviderLover().get(lobby.lovers[0].id);
        lobby.lovers[1] = await DataProviderLover().get(lobby.lovers[1].id);
        lobbyStream = Stream<LobbyEntity>.value(lobby);
      }
    });
    yield* lobbyStream;
  }

  //create lobby
  Future<LobbyEntity> create(LobbyEntity lobby) async {
    DocumentReference<Map<String, dynamic>> docRef =
        await _firestore.collection('lobby').add(lobby.toJson());
    lobby.id = docRef.id;
    await docRef.update(lobby.toJson());
    return lobby;
  }

  //update lobby
  Future<void> _update(LobbyEntity lobby) async {
    if (lobby.isEmpty()) {
      delete(lobby);
    } else {
      await _firestore.collection('lobby').doc(lobby.id).update(lobby.toJson());
    }
  }

  //update lobby
  Future<void> updateLobbyLover(LobbyEntity lobby, Lover lover) async {
    _update(lobby);
    await DataProviderLover().update(lover);
  }

  //delete lobby
  Future<void> delete(LobbyEntity lobby) async {
    if (lobby.id.isEmpty) {
      return;
    }
    await _firestore.collection('lobby').doc(lobby.id).delete();
  }

  //get lobby
  Future<LobbyEntity> getSimpleId(String simpleID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('lobby')
        .where('simpleID', isEqualTo: simpleID.toUpperCase())
        .get();
    LobbyEntity lobby = LobbyEntity.empty();
    if (snapshot.docs.isEmpty) {
      return lobby;
    }
    QueryDocumentSnapshot<Map<String, dynamic>> doc = snapshot.docs.first;
    if (doc.exists) {
      lobby = LobbyEntity.fromJson(doc.data());
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

  Future<LobbyEntity> get(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lobby').doc(id).get();
    LobbyEntity lobby = LobbyEntity.empty();

    if (snapshot.data() != null) {
      lobby = LobbyEntity.fromJson(snapshot.data()!);
      lobby.id = snapshot.id;
      if (lobby.lovers[0].id.isNotEmpty) {
        lobby.lovers[0] = await DataProviderLover().get(lobby.lovers[0].id);
      }
      if (lobby.lovers[1].id.isNotEmpty) {
        lobby.lovers[1] = await DataProviderLover().get(lobby.lovers[1].id);
      }
    }
    return lobby;
  }
}
