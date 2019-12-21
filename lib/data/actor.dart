import 'package:cloud_firestore/cloud_firestore.dart';

class Actor {
  final String id;
  final String name;
  final String description;
  final String cost;
  final bool isAvailable;
  Actor({this.id, this.name, this.description, this.cost, this.isAvailable});
  factory Actor.fromMap(Map data) {
    // print('cost-->' + data['cost']);
    return Actor(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        cost: data['cost'] != null ? data['cost'].toString() : '',
        isAvailable: data['isAvailable']);
  }
  factory Actor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    data['id'] = doc.documentID;
    return Actor.fromMap(data);
  }

  static List<Actor> actorsList(QuerySnapshot doc) {
    return doc.documents
        .map((documentSnapshot) => Actor.fromFirestore(documentSnapshot))
        .toList();
  }
}
