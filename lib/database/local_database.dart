import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';
import 'package:proyecto_qpon/shared/globals.dart' show globalFavoriteIds;
import 'package:sqflite/sqflite.dart';

/// Local [Database] that handles persistent local storage
///
/// Handles favorited offers:
/// - [getSavedOfferCards] for retreving favorited [Offer]s as [Map]s
/// - [insertSavedOfferCard] to insert a single [Offer] to favorites
/// - [deleteSavedOfferCard] to delete a single [Offer] from local database
/// using its [localId]
///
/// - [deleteAllSavedOfferCards] self explanatory

class LocalDatabase {
  /// Opens the local database
  /// and creates the database on first execution
  ///
  /// The database holds a table for favorite [Offer]s

  static Future<Database> getLocalDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database
    final database = openDatabase(
      join(await getDatabasesPath(), 'local_database.db'),
      // Create the database
      onCreate: (db, version) {
        return db.execute(
          // Creates the table for favorite offers
          // "id" is the PK identifier on the DB - offerId is the identifire from firestore, is unique to avoid duplicate favorite offers
          'CREATE TABLE favorite_offers(id INTEGER PRIMARY KEY, offerId TEXT NOT NULL UNIQUE, productName TEXT, productPrice REAL, productDetails TEXT, imageUrl TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  /// Gets favorite offers as [List] of type [Map] from local [Database] and returns list of [Offer] objects

  static Future<List<Offer>> getSavedOfferCards() async {
    final Database db = await getLocalDatabase();

    final List<Map<String, Object?>> savedOfferCardMaps = await db.query(
      'favorite_offers',
    );
    debugPrint("Retrieved offers from Local DB: $savedOfferCardMaps");
    // save the IDs to global to know which are favorited when fetching from Firestore
    _updateFavoriteIdsOnGlobal(savedOfferCardMaps);
    return savedOfferCardMaps.map((map) => Offer.fromMapToOffer(map)).toList();
  }

  static void _updateFavoriteIdsOnGlobal(
    List<Map<String, Object?>> savedOfferCardMaps,
  ) {
    globalFavoriteIds.clear();
    for (Map localOfferMap in savedOfferCardMaps) {
      globalFavoriteIds[localOfferMap['offerId'] as String] =
          localOfferMap['id'] as int;
    }
  }

  /// Gets a single [Offer] object and inserts the [savedOffer] to favorites table as [Map]
  static Future<int> insertSavedOfferCard(Offer savedOffer) async {
    final Database db = await getLocalDatabase();

    int id = await db.insert(
      'favorite_offers',
      // Has to be a map so SQLite can accept it
      savedOffer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('Offer inserted to Local DB ${savedOffer.toString()}');
    return id;
  }

  /// Gets a [localId] and deletes the saved offer with that ID
  static Future<void> deleteSavedOfferCard(int localId) async {
    final Database db = await getLocalDatabase();

    await db.delete('favorite_offers', where: 'id = ?', whereArgs: [localId]);
  }

  /// Deletes every [Offer] saved on favorites
  static Future<void> deleteAllSavedOfferCards() async {
    final db = await getLocalDatabase();

    await db.rawDelete('DELETE FROM favorite_offers');
  }
}
