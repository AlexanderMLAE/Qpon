import 'package:flutter/foundation.dart';

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

class SavedOfferUpdateModel with ChangeNotifier {
  int? _localId;
  int? get localId => _localId;
  String? _offerId;
  String? get offerId => _offerId;
  void updateSavedOffer({int? localId, String? offerId}) {
    if (offerId != null) {
      _localId = localId;
      _offerId = offerId;
    } else {
      _offerId = null;
      _localId = null;
    }

    notifyListeners();
  }
}

/// [ValueNotifier] that is called whenever an offer is saved to favorites, updating the favorites screen
final SavedOfferUpdateModel savedOfferUpdateNotifier = SavedOfferUpdateModel();

final SearchNotifierModel storeSearchUpdateNotifier = SearchNotifierModel();

/// Key is Firestore id, value is local id
Map<String, int> globalFavoriteIds = {};
bool isLocalDatabaseReady = false;
