import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Future<Database> getLocalDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    // open the database
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

  // Gets favorite offer cards as map from local db and returns list of offer objects
  static Future<List<Offer>> getSavedOfferCards() async {
    final Database db = await getLocalDatabase();

    final List<Map<String, Object?>> savedOfferCardMaps = await db.query(
      'favorite_offers',
    );
    debugPrint("Retrieved offers from Local DB: $savedOfferCardMaps");
    return savedOfferCardMaps.map((map) => Offer.fromMapToOffer(map)).toList();
  }

  // Gets a single offer object and inserts it to favorites table as map
  static Future<void> insertSavedOfferCard(Offer savedOffer) async {
    final Database db = await getLocalDatabase();

    await db.insert(
      'favorite_offers',
      savedOffer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('Offer inserted to Local DB ${savedOffer.toMap()}');
  }

  // Deletes every offer saved on favorites
  static Future<void> deleteSavedOfferCards() async {
    final db = await getLocalDatabase();

    await db.rawDelete('DELETE FROM favorite_offers');
  }
}
