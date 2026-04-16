import 'package:flutter/material.dart';

final ValueNotifier<int> savedOfferUpdateNotifier = ValueNotifier(0);

final ValueNotifier<int> locationSearchUpdateNotifier = ValueNotifier(0);


class StoreSearchModel with ChangeNotifier {
  String _query = "";
  String get query => _query;

  void changeSearchQuery(String query) {
    _query = query;
  }
}

final StoreSearchModel storeSearch = StoreSearchModel();