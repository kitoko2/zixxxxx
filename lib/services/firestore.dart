import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xiz/model/userxiz.dart';

class FirestoreServie {
  var userCollection = FirebaseFirestore.instance.collection("users");

  getIfDocumentUserExist(String uid) async {
    var result = await userCollection.doc(uid).get();
    print("le document $uid exist :  $result");
    return result.exists;
  }

  addPositionData(String uid, Userzix userzix) {
    userCollection.doc(uid).set({
      "uid": userzix.uid,
      "email": userzix.email,
      "latlng": userzix.latlong,
      "pseudo": userzix.pseudo,
      "age": userzix.age,
      "type rechercher": userzix.typeRechercher,
      "description": userzix.description,
      "item": userzix.items,
      "photoUrl": userzix.photoUrl,
      "connections": [],
    });
  }

  updatePosition(String uid, String latlng) {
    userCollection.doc(uid).update({
      "latlng": latlng,
    });
  }

  updateProfile(String uid, Userzix userzix) {
    userCollection.doc(uid).update({
      "pseudo": userzix.pseudo,
      "age": userzix.age,
      "type rechercher": userzix.typeRechercher,
      "description": userzix.description,
      "item": userzix.items,
      "photoUrl": userzix.photoUrl,
    });
  }

  List<Userzix> userszixx(QuerySnapshot<Map<String, dynamic>> querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Userzix(
        uid: doc.data()["uid"],
        email: doc.data()["email"],
        age: doc.data()["age"],
        description: doc.data()["description"],
        items: doc.data()["item"],
        latlong: doc.data()["latlng"],
        pseudo: doc.data()["pseudo"],
        typeRechercher: doc.data()["type rechercher"],
        photoUrl: doc.data()["photoUrl"],
      );
    }).toList();
  }

  Userzix userzixx(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Userzix(
      uid: doc.data()!["uid"],
      email: doc.data()!["email"],
      age: doc.data()!["age"],
      description: doc.data()!["description"],
      items: doc.data()!["item"],
      latlong: doc.data()!["latlng"],
      pseudo: doc.data()!["pseudo"],
      typeRechercher: doc.data()!["type rechercher"],
      photoUrl: doc.data()!["photoUrl"],
    );
  }

  Stream<List<Userzix>> getuserxzixx() {
    return userCollection.snapshots().map(userszixx);
  }

  Stream<Userzix> getoneuser(String uid) {
    return userCollection.doc(uid).snapshots().map(userzixx);
  }
}
