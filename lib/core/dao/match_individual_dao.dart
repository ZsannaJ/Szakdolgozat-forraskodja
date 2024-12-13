import 'package:flutter/cupertino.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/firebase/FirestoreService.dart';

class MatchIndividualDao {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createMatchIndividual(Map<String, dynamic> matchData) async {
    final db = await DBHelper().database;
    await db.insert('match_individuals', matchData);
    await _firestoreService.addMatchIndividual(matchData);
    print("match");
  }

  Future<Map<String, dynamic>?> readMatchIndividualById(int matchId) async {
    final db = await DBHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      'match_individuals',
      where: 'id = ?',
      whereArgs: [matchId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> readMatchesIndividualByLeague(String leagueId) async {
    final db = await DBHelper().database;
    return await db.query(
      'match_individuals',
      where: 'league_id = ?',
      whereArgs: [leagueId],
      orderBy: 'date DESC',
    );
  }

  Future<Map<int, Map<String, dynamic>>> getMatchIndividualForMap(String leagueId) async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> matches = await db.query(
      'match_individuals',
      where: 'league_id = ?',
      whereArgs: [leagueId],
    );

    Map<int, Map<String, dynamic>> matchResults = {};

    for (var match in matches) {
      int id = match['id'];
      int winnerId = match['winner_id'];

      int loserId = match['player1_id'] == winnerId ? match['player2_id'] : match['player1_id'];
      int scoreW = match['player1_score'] < match['player2_score'] ? match['player2_score'] : match['player1_score'];
      int scoreL = match['player1_score'] > match['player2_score'] ? match['player2_score'] : match['player1_score'];

      matchResults[id] = {
        'score_w': scoreW,
        'score_l': scoreL,
        'loser_id': loserId,
        'winner_id': winnerId,
      };
    }

    return matchResults;
  }

  Future<List<Map<String, String>>> getMatchResultsByLeagueId(String leagueId) async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> matches = await db.query(
      'match_individuals',
      where: 'league_id = ?',
      whereArgs: [leagueId],
    );

    List<Map<String, String>> matchResults = [];

    for (var match in matches) {
      int winnerId = match['winner_id'];
      int loserId = (winnerId == match['player1_id']) ? match['player2_id'] : match['player1_id'];

      String winnerName = await PlayerDao().getPlayerNameById(winnerId);
      String loserName = await PlayerDao().getPlayerNameById(loserId);

      matchResults.add({
        'winner': winnerName,
        'loser': loserName,
      });
    }

    return matchResults;
  }


  Future<void> deleteIndividualMatch(int matchId) async{
    final db = await DBHelper().database;
    try {

      await db.delete(
        'match_individuals',
        where: 'id = ?',
        whereArgs: [matchId],
      );

      await _firestoreService.deleteMatchIndividualFromFirestore(matchId);

    } catch (e) {
      throw Exception('Hiba történt az egyéni liga törlésénél: $e');
    }
  }

  Future<void> updateIndividualMatch(int matchId, Map<String, dynamic> updatedData, String leagueId) async{
    final db = await DBHelper().database;
    try {
      List<Map<String, dynamic>> existingTeam = await db.query(
        'match_individuals',
        where: 'id = ?',
        whereArgs: [matchId],
      );

      if (existingTeam.isNotEmpty) {

        await db.update(
          'match_individuals',
          updatedData,
          where: 'id = ?',
          whereArgs: [matchId],
        );
        print("Match data updated in local database.");

        await _firestoreService.updateIndividualMatchFirestore(matchId, updatedData, leagueId);
        print("Match data updated in Firestore.");
      } else {
        print("No matching match found in local database.");
      }
    } catch (e) {
      print("Error updating match data: $e");
    }
  }

  Future<void> updateMatchThemesForPlayer(int playerId, String newTheme) async {
    final db = await DBHelper().database;
    Map<String, String> updatedData;
    try {
      const matchTable = 'match_individuals';

      final matches = await db.query(
        matchTable,
        where: 'player1_id = ? OR player2_id = ?',
        whereArgs: [playerId, playerId],
      );

      for (var match in matches) {
        int matchId = match['id'] as int;

        if (match['player1_id'] == playerId) {
          await db.update(
            matchTable,
            {'player1_theme': newTheme},
            where: 'id = ?',
            whereArgs: [matchId],
          );


          print("Updated player1_theme for match ID: $matchId");
        }
        if (match['player2_id'] == playerId) {
          await db.update(
            matchTable,
            {'player2_theme': newTheme},
            where: 'id = ?',
            whereArgs: [matchId],
          );



          print("Updated player2_theme for match ID: $matchId");
        }

        await _firestoreService.updateMatchThemesForPlayerInFirestore(playerId, newTheme);

      }
    } catch (e) {
      print("Error updating match theme: $e");
    }
  }

}

