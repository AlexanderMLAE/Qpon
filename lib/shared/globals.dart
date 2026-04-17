import 'package:flutter/material.dart';

/// Global variables and notifiers.

/// [ChangeNotifier] enables live update on search
class SearchNotifierModel with ChangeNotifier {
  String _query = "";
  String get query => _query;

  void changeSearchQuery(String query) {
    _query = query;
    notifyListeners();
  }
}

final ValueNotifier<int> savedOfferUpdateNotifier = ValueNotifier(0);

final SearchNotifierModel storeSearchUpdateNotifier = SearchNotifierModel();
