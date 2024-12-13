import 'dart:async';
import 'dart:math';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBHelper {
  // Singleton pattern
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Adatbázis inicializálása
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("onCreate");
    // Player tábla létrehozása
    await db.execute('''
    CREATE TABLE players (
      id INTEGER PRIMARY KEY,
      name TEXT,
      theme TEXT,
      points REAL,
      rank INTEGER,
      win_count INTEGER,
      loss_count INTEGER,
      league_id TEXT,
      skin_color INTEGER DEFAULT 0,
      hair INTEGER DEFAULT 0,
      hair_color INTEGER DEFAULT 0,
      top INTEGER DEFAULT 1,
      top_color INTEGER DEFAULT 3,
      beard INTEGER DEFAULT 0,
      beard_color INTEGER DEFAULT 0,
      glasses INTEGER DEFAULT 0,
      glasses_color INTEGER DEFAULT 0,
      FOREIGN KEY (league_id) REFERENCES individual_leagues (id)
    )
    ''');

    // Team tábla létrehozásaA
    await db.execute('''
    CREATE TABLE teams (
      id INTEGER PRIMARY KEY,
      name TEXT,
      theme TEXT,
      points REAL,
      rank INTEGER, 
      win_count INTEGER, 
      loss_count INTEGER, 
      league_id TEXT, 
      icon INTEGER DEFAULT 0,
      icon_color INTEGER DEFAULT 0,
      FOREIGN KEY (league_id) REFERENCES team_leagues (id)
    )

    ''');

    // Egyéni meccsek tábla
    await db.execute('''
    CREATE TABLE match_individuals (
      id INTEGER PRIMARY KEY,  
      player1_id INTEGER, 
      player2_id INTEGER,
      player1_score INTEGER,
      player2_score INTEGER,
      player1_theme TEXT,
      player2_theme TEXT,
      winner_id INTEGER,
      date TEXT,  
      league_id TEXT,
      FOREIGN KEY (player1_id) REFERENCES players(id),
      FOREIGN KEY (player2_id) REFERENCES players(id),
      FOREIGN KEY (winner_id) REFERENCES players(id),  
      FOREIGN KEY (league_id) REFERENCES individual_leagues(id)  
    )
    ''');

    // Csapat meccsek tábla
    await db.execute('''
    CREATE TABLE match_teams (
      id INTEGER PRIMARY KEY,
      team1_id INTEGER, 
      team2_id INTEGER, 
      team1_score INTEGER,  
      team2_score INTEGER, 
      team1_theme TEXT,
      team2_theme TEXT,
      winner_id INTEGER,  
      date TEXT, 
      league_id TEXT,  
      FOREIGN KEY (team1_id) REFERENCES teams(id),  
      FOREIGN KEY (team2_id) REFERENCES teams(id), 
      FOREIGN KEY (winner_id) REFERENCES teams(id),  
      FOREIGN KEY (league_id) REFERENCES team_leagues(id) 
    )
    ''');

    // Egyéni ligák tábla
    await db.execute('''
    CREATE TABLE individual_leagues (
      id TEXT PRIMARY KEY,
      name TEXT,
      password TEXT,
      beta REAL DEFAULT 0,
      theme TEXT,
      icon TEXT,
      creation_date TEXT,
      description TEXT
    )
    ''');

    // Csapat ligák tábla
    await db.execute('''
    CREATE TABLE team_leagues (
      id TEXT PRIMARY KEY,
      name TEXT,
      password TEXT,
      beta REAL DEFAULT 0,
      theme TEXT,
      icon TEXT,
      creation_date TEXT,
      description TEXT
    )
    ''');

    print("All tables created successfully");
  }


  Future<void> clearAllLeagues() async {
    final db = await database;
    print('in the function');
    try {
      // Először töröljük a táblákat
      await db.transaction((txn) async {
        print('object');
        await txn.execute('DROP TABLE IF EXISTS individual_leagues');
        await txn.execute('DROP TABLE IF EXISTS team_leagues');
        await txn.execute('DROP TABLE IF EXISTS match_individuals');
        await txn.execute('DROP TABLE IF EXISTS match_teams');
        await txn.execute('DROP TABLE IF EXISTS players');
        await txn.execute('DROP TABLE IF EXISTS teams');
        await txn.execute('DROP TABLE IF EXISTS avatars');
      });

      await db.close();

      // Töröld az adatbázisfájlt
      String path = join(await getDatabasesPath(), 'my_database.db');
      await deleteDatabase(path);

      // Újra inicializáld az adatbázist
      _database = await _initDatabase();
      print("Database cleared and recreated successfully");

      printTableNames();

    }catch(e){}
  }

  Future<void> printTableNames() async {
    final db = await database;
    final List<Map<String, dynamic>> tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table";');
    print("Current tables:");
    for (var table in tables) {
      print(table['name']);
    }
  }

  // =============================
  //     ID GENERATE METHODS
  // =============================


  // Az azonosító generáló függvény
  Future<String> generateUniqueId(String leagueType) async {
    String newId;
    bool idExists;

    // Az azonosító hossza fixen 6
    int idLength = 6;

    do {
      newId = _generateRandomString(idLength);
      idExists = await _checkIdExists(newId, leagueType);
    } while (idExists); // Amíg a generált ID létezik, folytasd az új generálást

    return newId; // Visszaadja az új, egyedi ID-t
  }

  // Véletlenszerű string generáló
  String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  // Ellenőrizd, hogy létezik-e már a generált ID a Firestore-ban
  Future<bool> _checkIdExists(String id, String leagueType) async {
    try {
      QuerySnapshot querySnapshot;

      if (leagueType == 'individual') {
        querySnapshot = await FirebaseFirestore.instance
            .collection('individual_leagues')
            .where('id', isEqualTo: id)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('team_leagues')
            .where('id', isEqualTo: id)
            .get();
      }

      return querySnapshot.docs.isNotEmpty; // Ha van találat, akkor létezik az ID
    } catch (e) {
      print("Error checking ID existence: $e");
      return true;  // Ha hiba történik, feltételezhetjük, hogy létezik az ID
    }
  }



  Future<int> generateUniquePlayerId() async {
    return await generateUniqueIdFromFirestore('players');
  }

  Future<int> generateUniqueTeamId() async {
    return await generateUniqueIdFromFirestore('teams');
  }

  Future<int> generateUniqueIndividualMatchId() async {
    return await generateUniqueIdFromFirestore('match_individuals');
  }

  Future<int> generateUniqueTeamMatchId() async {
    return await generateUniqueIdFromFirestore('match_teams');
  }



  // Közös metódus az azonosítók generálására

  Future<int> generateUniqueIdFromFirestore(String collectionName) async {
    try {
      // Lekérjük a legnagyobb id-t a Firestore-ból
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      int newId = 1;  // Alapértelmezett ID

      if (querySnapshot.docs.isNotEmpty) {
        // Lekérjük az első dokumentumot, amely a legnagyobb id-t tartalmazza
        int maxId = querySnapshot.docs.first['id'];
        newId = maxId + 1;  // Új ID, amely az előző legnagyobb ID-t növeli
      }

      return newId;  // Visszaadjuk az új ID-t
    } catch (e) {
      print("Error generating ID from Firestore: $e");
      return 1;  // Ha valami hiba történik, az első ID-t adja vissza
    }
  }




  // =============================
  //         CONVERT METHODS
  // =============================

  PlayerTheme convertStringToPlayerTheme(String themeString) {
    // Megpróbáljuk megtalálni a megfelelő enum értéket
    return PlayerTheme.values.firstWhere(
          (theme) => theme.toString().split('.').last == themeString,
      orElse: () => PlayerTheme.blue, // Alapértelmezett érték, ha nem található
    );
  }

}
