import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<Map<String, dynamic>>> getOfertasReal() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection("offers").get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        return {
          'productName': data['product_name'] ?? 'Sin nombre',
          'productPrice': (data['product_price'] as num?)?.toDouble() ?? 0.0,
          'productDetails': data['product_details'] ?? '',
          'imageURL': data['image_url'] ?? '',
          'localName': data['store'] ?? 'Establecimiento', 
          'storeId': data['store'], // ID
        };
      }).toList();
    } catch (e) {
      ("Error en Firebase: $e");
      return [];
    }
  }
}