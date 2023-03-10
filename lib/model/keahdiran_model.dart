import 'package:cloud_firestore/cloud_firestore.dart';

// class AllKehadiranModel {
//   final List<KehadiranModel> dataKehadiran;
//   AllKehadiranModel({required this.dataKehadiran});
//   factory AllKehadiranModel.fromSnap(
//       QuerySnapshot<Map<String, dynamic>> snapshot) {
//     return AllKehadiranModel(
//         dataKehadiran:
//             snapshot.docs.map((e) => KehadiranModel.fromDoc(e)).toList());
//   }
// }

class KehadiranModel {
  final String id;
  final String? date;
  final String? address;
  final String? image;
  final String? inn;
  final String? out;
  final String? isProve;
  final String? place;
  final bool? isFakeGps;
  final String? lamaKeterlambatan;
  final String? statusKeterlambatan;
  final String? status;

  KehadiranModel(
      {required this.id,
      required this.date,
      required this.address,
      required this.image,
      required this.inn,
      required this.out,
      required this.isProve,
      required this.isFakeGps,
      required this.place,
      required this.lamaKeterlambatan,
      required this.statusKeterlambatan,
      required this.status});

  factory KehadiranModel.fromDoc(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final snap = snapshot.data()!;
    return KehadiranModel(
        id: snapshot.id,
        date: snap['date'],
        address: snap['address'],
        image: snap['image'],
        inn: snap['in'],
        out: snap['out'],
        isFakeGps: snap['isFakeGps'],
        isProve: snap['isProve'],
        place: snap['place'],
        lamaKeterlambatan: snap['range_keterlambatan'] != snap['']
            ? snap['range_keterlambatan']
            : snap[''],
        statusKeterlambatan: snap['satus_keterlambatan'] != snap['']
            ? snap['satus_keterlambatan']
            : snap[''],
        status: snap['status']);
  }
}
