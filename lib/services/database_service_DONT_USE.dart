import 'package:casting_manager/data/actor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final user = 'jXdi22qjHuCfkikHA9EZ';

  Stream<List<Actor>> get availableActors {
    return _db
        .collection('actor')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snap) => Actor.actorsList(snap));
  }

  Stream<List<Actor>> get rosters {
    return _db
        .collection('actor')
        .where('inUser', isEqualTo: user)
        .snapshots()
        .map((snap) => Actor.actorsList(snap));
  }

  Stream<List<Actor>> get roster {
    return _db
        .collection('user')
        .document(user)
        .snapshots()
        .asyncMap((snap) async {
      var actorsList = <Actor>[];
      List<dynamic> actorsIdList = snap.data['roster'];
      for (String actorsPath in actorsIdList) {
        actorsList.add(Actor.fromFirestore(
            await _db.collection('actor').document(actorsPath).get()));
      }
      return actorsList;
    });
  }

  void addToRoster(String actorID) async {
    await _db.collection('user').document(user).updateData({
      'roster': FieldValue.arrayUnion([actorID])
    });

    await _db.collection('actor').document(actorID).updateData(
      {'isAvailable': false},
    );
  }

  void removeFromRoster(String actorID) async {
    await _db.collection('user').document(user).updateData({
      'roster': FieldValue.arrayRemove([actorID])
    });

    await _db.collection('actor').document(actorID).updateData(
      {'isAvailable': true},
    );
  }

  void addNewActor(Actor actor) async {
    await _db.collection('actor').add({
      'name': actor.name ?? '',
      'cost': actor.cost ?? int.parse(actor.cost) ?? 0,
      'description': actor.description ?? '',
      "isAvailable": actor.isAvailable ?? '',
    });
  }
}
