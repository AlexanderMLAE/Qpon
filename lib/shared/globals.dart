import 'package:flutter/foundation.dart';

final SavedOfferUpdateModel savedOfferUpdateNotifier = SavedOfferUpdateModel();

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

/// Key is Firestore id, value is local id
Map<String, int> globalFavoriteIds = {};
bool isLocalDatabaseReady = false;
