import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<Map<String, dynamic>>> fetchOffers() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection("offers").get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return {
          'productName': data['product_name'] ?? 'Sin nombre',
          'productPrice': (data['product_price'] as num?)?.toDouble() ?? 0.0,
          'productDetails': data['product_details'] ?? 'Placeholder Details',
          'imageUrl': data['image_url'] ?? 'https://i.imgur.com/vs8QJQY.png',
          'localName': data['store'] ?? 'Establecimiento',
          'storeId': data['store'], // ID
        };
      }).toList();
    } catch (e) {
      ("Error en Firebase: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchStoreOffers(
    String storeId,
  ) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection("offers")
          .where("store", isEqualTo: storeId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return {
          'productName': data['product_name'] ?? 'Sin nombre',
          'productPrice': (data['product_price'] as num?)?.toDouble() ?? 0.0,
          'productDetails': data['product_details'] ?? '',
          'imageUrl': data['image_url'] ?? 'https://i.imgur.com/vs8QJQY.png',
          'localName': data['store'] ?? 'Establecimiento',
          'storeId': data['store'], // ID
        };
      }).toList();
    } catch (e) {
      ("Error en Firebase: $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchStores() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .get();
      debugPrint('Successfully read stores from DB');

      return querySnapshot.docs.map((doc) {
        return {"id": doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      debugPrint('Error on fetchStores: $e');
    }
    return [];
  }
}
