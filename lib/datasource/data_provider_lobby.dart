// ignore_for_file: sdk_version_since

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrise/datasource/data_provider_lover.dart';
import 'package:sunrise/model/model_lobby.dart';
import 'package:sunrise/model/model_lover.dart';

class DataProviderLobby {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Lobby> watch(Lobby lobby) async* {
    Stream<Lobby> lobbyStream = Stream<Lobby>.value(lobby);
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        _firestore.collection('lobby').doc(lobby.id).snapshots();
    stream.listen((event) async {
      if (event.exists) {
        lobby = Lobby.fromJson(event.data()!);
        lobby.id = event.id;
        lobby.lovers[0] = await DataProviderLover().get(lobby.lovers[0].id);
        lobby.lovers[1] = await DataProviderLover().get(lobby.lovers[1].id);
        lobbyStream = Stream<Lobby>.value(lobby);
      }
    });
    yield* lobbyStream;
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
    if (lobby.id.isEmpty) {
      return;
    }
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
        lobby.lovers[0] = await DataProviderLover().get(lobby.lovers[0].id);
      }
      if (lobby.lovers[1].id.isNotEmpty) {
        lobby.lovers[1] = await DataProviderLover().get(lobby.lovers[1].id);
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
        lobby.lovers[0] = await DataProviderLover().get(lobby.lovers[0].id);
      }
      if (lobby.lovers[1].id.isNotEmpty) {
        lobby.lovers[1] = await DataProviderLover().get(lobby.lovers[1].id);
      }
    }
    return lobby;
  }
}
