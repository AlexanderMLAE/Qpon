import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';
import 'package:proyecto_qpon/shared/globals.dart' show globalFavoriteIds;
import 'package:proyecto_qpon/features/stores/data/store_class.dart';

/// Handles requests to [FirebaseFirestore]
class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Returns a list of the offers as a [Map] from Firestore
  static Future<List<Map<String, dynamic>>> _fetchOffers({
    /// Optional to filter by a specific store
    String? storeId,
  }) async {
    try {
      Query query = _db.collection('offers');
      // Filter by storeId if provided
      if (storeId != null) {
        query = query.where('store', isEqualTo: storeId);
      }
      final QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        return _handleDocument(doc);
      }).toList();
    } catch (e) {
      debugPrint("Error en Firebase: $e");
      return [];
    }
  }

  static Map<String, Object?> _handleDocument(
    QueryDocumentSnapshot<Object?> doc,
  ) {
    final String id = doc.id;
    final Map<String, Object?> data = doc.data() as Map<String, Object?>;
    debugPrint('fetched data: $id ${data.toString()}');
    // check with global if offer is favorited and add the appropriate localId to the data map
    if (globalFavoriteIds[id] != null) {
      data['id'] = globalFavoriteIds[data['offerId']];
    }
    final Map<String, Object?> offerMap = {'offerId': id, ...data};

    return offerMap;
  }

  /// Gets the list of offer maps and turns them to a list of offer objects
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

  /// Gets the list of stores from Firestore
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

  static Future<List<Store>> getStoresList() async {
    List locationsList = await fetchStores();

    debugPrint("Stores List: $locationsList");
    return locationsList.map((map) => Store.fromMaptoLocation(map)).toList();
  }
}
