class Userzix {
  String? uid;
  String? email;
  String? pseudo;
  String? age;
  String? typeRechercher;
  String? description;
  List<dynamic>? items;
  String? latlong;
  List<dynamic>? photoUrl;
  Userzix({
    required this.uid,
    required this.email,
    required this.age,
    required this.description,
    required this.items,
    required this.latlong,
    required this.pseudo,
    required this.typeRechercher,
    required this.photoUrl,
  });
}
