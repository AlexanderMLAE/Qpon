import 'package:flutter/foundation.dart' show ValueNotifier;

final ValueNotifier<int> savedOfferUpdateNotifier = ValueNotifier(0);

/// Key is Firestore id, value is local id
Map<String, int> globalFavoriteIds = {};
bool isLocalDatabaseReady = false;
