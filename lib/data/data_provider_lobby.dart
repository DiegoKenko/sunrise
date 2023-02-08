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
  Future<Lobby?> get(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('lobby').doc(id).get();
    if (snapshot.exists) {
      Lobby lobby = Lobby.fromJson(snapshot.data()!);
      lobby.id = id;
      lobby.lover1 = await DataProviderLover().get(lobby.lover1.id);
      if (lobby.lover2 != null) {
        lobby.lover2 = await DataProviderLover().get(lobby.lover2!.id);
      }
      return lobby;
    } else {
      return null;
    }
  }

  //remove lover from lobby
  Future<void> removeLover(Lobby lobby, Lover lover) async {
    if (lobby.lover1.id == lover.id) {
      lobby.lover1.lobbyId = '';
    } else {
      lobby.lover2!.lobbyId = '';
    }
    await update(lobby);
  }
}
