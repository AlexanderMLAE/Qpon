import 'package:flutter/material.dart';

/// Global variables and notifiers.

/// [ChangeNotifier] allows live update on search
class SearchNotifierModel with ChangeNotifier {
  String _query = "";
  String get query => _query;

  void changeSearchQuery(String query) {
    _query = query.toLowerCase().trim();
    notifyListeners();
  }
}

/// [ValueNotifier] that is called whenever an offer is saved to favorites, updating the favorites screen
final ValueNotifier<int> savedOfferUpdateNotifier = ValueNotifier(0);

final SearchNotifierModel storeSearchUpdateNotifier = SearchNotifierModel();

/// Key is Firestore id, value is local id
Map<String, int> globalFavoriteIds = {};
bool isLocalDatabaseReady = false;
