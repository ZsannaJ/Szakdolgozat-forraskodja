import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/firebase/FirestoreService.dart';
import 'package:sqflite/sqflite.dart';

class PlayerDao {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createPlayer(Map<String, dynamic> playerData) async {
    final db = await DBHelper().database;
    await db.insert('players', playerData);
    await _firestoreService.addPlayer(playerData);
  }

  Future<Map<String, dynamic>?> readPlayerById(int playerId) async {
    final db = await DBHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      'players',
      where: 'id = ?',
      whereArgs: [playerId],
      orderBy: 'name ASC',
    );
    return result.isNotEmpty ? result.first : null;
  }


  Future<List<Map<String, dynamic>>> readPlayersByLeague(String leagueId) async {
    final db = await DBHelper().database;
    return await db.query(
      'players',
      where: 'league_id = ?',
      whereArgs: [leagueId],
      orderBy: 'name ASC',
    );
  }

  Future<List<Map<String, dynamic>>> readPlayersByLeagueRank(String leagueId) async {
    final db = await DBHelper().database;
    return await db.query(
      'players',
      where: 'league_id = ?',
      whereArgs: [leagueId],
      orderBy: 'rank ASC',
    );
  }


  Future<String> getPlayerNameById(int playerId) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> results = await db.query(
      'players',
      where: 'id = ?',
      whereArgs: [playerId],
    );

    if (results.isNotEmpty) {
      return results.first['name'] as String;
    }
    return '';
  }

  Future<Map<int, Map<String, dynamic>>> getPlayersForMap(String leagueId) async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> playersData = await db.query(
      'players',
      where: 'league_id = ?',
      whereArgs: [leagueId],
    );

    Map<int, Map<String, dynamic>> playersMap = {};

    for (var player in playersData) {
      int playerId = player['id'];
      playersMap[playerId] = {
        'name': player['name'],
        'rank': player['rank'],
        'points': player['points'],
        'loss_count': player['loss_count'],
      };
    }

    return playersMap;
  }

  Future<void> updatePlayerStats(int playerId) async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> winsResult = await db.rawQuery('''
    SELECT COUNT(*) as win_count
    FROM match_individuals
    WHERE winner_id = ?
  ''', [playerId]);

    int winCount = winsResult.isNotEmpty ? winsResult.first['win_count'] : 0;
    print('win count: $winCount');

    final List<Map<String, dynamic>> lossesResult = await db.rawQuery('''
    SELECT COUNT(*) as loss_count
    FROM match_individuals
    WHERE (player1_id = ? OR player2_id = ?)
      AND winner_id != ?
  ''', [playerId, playerId, playerId]);

    int lossCount = lossesResult.isNotEmpty ? lossesResult.first['loss_count'] : 0;
    print('loss count: $lossCount');

    await db.rawUpdate('''
    UPDATE players
    SET win_count = ?, loss_count = ?
    WHERE id = ?
  ''', [winCount, lossCount, playerId]);

    print('Player $playerId win count: $winCount, loss count: $lossCount');
  }



  Future<void> updatePlayerPoints(String leagueId, int playerId, double points) async {
    final db = await DBHelper().database;
    await db.update(
        'players',
        {'points': points},
        where: 'id = ?',
        whereArgs: [playerId]
    );

    updatePlayerRanks(leagueId);
  }

  Future<void> updatePlayerRanks(String leagueId) async {
    Database db = await DBHelper().database;

    List<Map<String, dynamic>> players = await db.query(
      'players',
      where: 'league_id = ?',
      whereArgs: [leagueId],
    );

    List<Map<String, dynamic>> playersCopy = List.from(players);

    // Rendezés a pontok alapján csökkenő sorrendbe
    playersCopy.sort((a, b) {
      double pointsA = a['points'] ?? 0.0;
      double pointsB = b['points'] ?? 0.0;
      return pointsB.compareTo(pointsA);
    });

    int rank = 1;  // Az első játékos kapja az 1-es rangot
    for (int i = 0; i < playersCopy.length; i++) {
      // Ha az aktuális játékos pontszáma ugyanaz, mint az előző játékosé,
      // akkor ugyanazt a rangot kapja
      if (i > 0 && playersCopy[i]['points'] == playersCopy[i - 1]['points']) {
        // Ha ugyanaz a pontszám, ne változtassuk a rangot
        await db.update(
          'players',
          {'rank': rank},    // Ugyanaz a rang
          where: 'id = ?',    // Az id alapján frissítjük
          whereArgs: [playersCopy[i]['id']],
        );
      } else {
        // Ha nem ugyanaz a pontszám, akkor új rangot adunk
        rank = i + 1;  // Az új rang az i+1 lesz
        await db.update(
          'players',
          {'rank': rank},    // Az új rang frissítése
          where: 'id = ?',    // Az id alapján frissítjük
          whereArgs: [playersCopy[i]['id']],
        );
      }
    }
  }

  Future<void> updatePlayer(int playerId, Map<String, dynamic> updatedData) async{
    final db = await DBHelper().database;
    try {
      const leagueTable = 'players';
      await db.update(
        leagueTable,
        updatedData,
        where: 'id = ?',
        whereArgs: [playerId],
      );

      await _firestoreService.updatePlayerFirestore(playerId, updatedData);
    } catch (e) {
      print("Hiba történt az adat frissítése közben: $e");
      rethrow;
    }
  }

  Future<void> updateLocalPlayerDatabase(int playerId, Map<String, dynamic> updatedData) async {
    final db = await DBHelper().database;

    try {

      List<Map<String, dynamic>> existingPlayer = await db.query(
        'players',
        where: 'id = ?',
        whereArgs: [playerId],
      );

      if (existingPlayer.isNotEmpty) {
        await db.update(
          'players',
          updatedData,
          where: 'id = ?',
          whereArgs: [playerId],
        );
        print("Player data updated in local database.");
      } else {
        print("No matching player found in local database.");
      }
    } catch (e) {
      print("Error updating player data in local database: $e");
    }
  }


  Future<void> deletePlayer(int playerId) async {
    final db = await DBHelper().database;
    try {
      await db.delete(
        'match_individuals',
        where: 'player1_id = ? OR player2_id = ?',
        whereArgs: [playerId, playerId],
      );
      print('Egyéni meccsek törölve a ligából: $playerId');


      await db.delete(
        'players',
        where: 'id = ?',
        whereArgs: [playerId],
      );

      await _firestoreService.deleteMatchesByPlayerId(playerId);
      await _firestoreService.deletePlayerFromFirestore(playerId);

      print('Játékos törölve a ligából: $playerId');

    } catch (e) {
      throw Exception('Hiba történt a játékos törlésénél: $e');
    }
  }




}