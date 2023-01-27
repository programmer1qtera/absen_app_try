import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String? nip;
  final String? address;
  final String? email;
  final String? name;
  final int? sisaCuti;

  UserModel(
      {required this.id,
      required this.nip,
      required this.sisaCuti,
      required this.address,
      required this.email,
      required this.name});

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final snap = snapshot.data()!;
    return UserModel(
        id: snapshot.id,
        address: snap["address"],
        name: snap['name'],
        email: snap["email"],
        sisaCuti: snap['sisa_cuti'],
        nip: snap['nip']);
  }

  // Map<String, dynamic> toJson() => {
  //     "_id": id,
  //     "name": name,
  // };
}
