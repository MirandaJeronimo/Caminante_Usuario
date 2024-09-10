import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPeople() async {
  List people = [];
  CollectionReference collectionReferencePeople = db.collection('prueba');

  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  queryPeople.docs.forEach((documento) {
    people.add(documento.data());
  });

  return people;
}


/*import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getPeople() async {
  List<Map<String, dynamic>> people = [];
  CollectionReference collectionReferencePeople = db.collection('prueba');

  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  queryPeople.docs.forEach((documento) {
    people.add(documento.data() as Map<String, dynamic>);
  });

  return people;
}
*/