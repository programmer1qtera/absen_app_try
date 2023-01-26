import 'package:cloud_firestore/cloud_firestore.dart';

class IzinModel {
  final String id;
  final String? date;
  final String? address;
  final String? description;
  final String? nameFile;
  final bool? proved;
  final String? satus;
  final String? tanggalCuti;

  IzinModel({
    required this.id,
    required this.date,
    required this.address,
    required this.description,
    required this.nameFile,
    required this.proved,
    required this.satus,
    required this.tanggalCuti,
  });

  factory IzinModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final snap = snapshot.data()!;
    return IzinModel(
        id: snapshot.id,
        date: snap['date'],
        address: snap['address'],
        description: snap['description'],
        nameFile: snap['nameFile'],
        proved: snap['proved'],
        satus: snap['satus'],
        tanggalCuti: snap['tanggal_cuti']);
  }
}
