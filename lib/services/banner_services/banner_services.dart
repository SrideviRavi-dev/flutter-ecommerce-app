import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/features/shop/models/banner_model/banner_model.dart';

class BannerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Banner>> fetchBanners() async {
    QuerySnapshot snapshot = await _db.collection('promotions').get();
    return snapshot.docs.map((doc) => Banner.fromFirestore(doc)).toList();
  }
}
