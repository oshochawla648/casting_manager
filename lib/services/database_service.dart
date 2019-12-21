import 'package:casting_manager/data/actor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<Actor>> get availableActors {
    return _db
        .collection('actor')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snap) => Actor.actorsList(snap));
  }

  Stream<List<Actor>> roster(String user) {
    if (user == '' || user == null) return Stream<List<Actor>>.empty();
    return _db
        .collection('actor')
        .where(
          'user',
          isEqualTo: user,
        )
        .snapshots()
        .map((snap) => Actor.actorsList(snap));
  }

  void addToRoster(String actorID, String user) async {
    await _db
        .collection('actor')
        .document(actorID)
        .updateData({'user': user, 'isAvailable': false});
  }

  void removeFromRoster(String actorID) async {
    await _db
        .collection('actor')
        .document(actorID)
        .updateData({'user': '', 'isAvailable': true});
  }

  Future<void> addNewActor(Actor actor) async {
    await _db.collection('actor').add({
      'name': actor.name ?? '',
      'user': '',
      'cost': actor.cost != null && actor.cost != ''
          ? double.parse(actor.cost).round()
          : 0,
      'description': actor.description ?? '',
      'isAvailable': actor.isAvailable ?? '',
    });
  }

  Future<String> login(String username) async {
    if (!await doesNameAlreadyExist(username)) {
      return ('Error');
    }
    return 'Success';
  }

  Future<String> register(String username) async {
    if (await doesNameAlreadyExist(username)) {
      return ('Error');
    }
    await _db.collection('user').add({'name': username});
    return 'Success';
  }

  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await _db
        .collection('user')
        .where('name', isEqualTo: name)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }
}
