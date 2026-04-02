import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:proyecto_qpon/features/offers/data/saved_offer_model.dart';
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
          'CREATE TABLE favorite_offers(id INTEGER PRIMARY KEY, offerId TEXT NOT NULL UNIQUE, productName TEXT, productPrice REAL, productDetails TEXT, imageUrl TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<List<Map<String, Object?>>> getSavedOfferCards() async {
    final Database db = await getLocalDatabase();

    final List<Map<String, Object?>> savedOfferCardMaps = await db.query(
      'favorite_offers',
    );

    return savedOfferCardMaps;
  }

  static Future<void> insertSavedOfferCard(SavedOfferCard savedOffer) async {
    final Database db = await getLocalDatabase();

    await db.insert(
      'favorite_offers',
      savedOffer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('Oferta guardada en DB $savedOffer');
  }

  static Future<void> deleteSavedOfferCards() async {
    final db = await getLocalDatabase();

    await db.rawDelete('DELETE FROM favorite_offers');
  }
}
