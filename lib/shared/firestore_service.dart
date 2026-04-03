import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Returns a list of the offers as a Map (key: value)
  static Future<List<Map<String, dynamic>>> _fetchOffers({
    String? storeId,
  }) async {
    try {
      Query query = _db.collection('offers');

      // Filter by storeId if provided
      if (storeId != null) {
        query = query.where('store', isEqualTo: storeId);
      }

      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final id = doc.id;
        final data = doc.data() as Map<String, dynamic>;
        debugPrint('fetched data: $id $data');
        return {'offerId': id, ...data};
      }).toList();
    } catch (e) {
      debugPrint("Error en Firebase: $e");
      return [];
    }
  }

  // Gets the list of offer maps and turns them to a list of offer objects
  static Future<List<Offer>> getOffersList({String? storeId}) async {
    List offersList = await _fetchOffers();
    if (storeId != null) {
      offersList = await _fetchOffers(storeId: storeId);
    }
    debugPrint(
      'offersList: $offersList ${offersList.map((map) => Offer.fromMapToOffer(map)).toList()}',
    );
    return offersList.map((map) => Offer.fromMapToOffer(map)).toList();
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
