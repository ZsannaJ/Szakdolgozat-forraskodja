import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/firebase/FirestoreService.dart';

class MatchTeamDao {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createMatchTeam(Map<String, dynamic> matchData) async {
    final db = await DBHelper().database;
    await db.insert('match_teams', matchData);

    await _firestoreService.addMatchTeam(matchData);
  }

  Future<Map<String, dynamic>?> readMatchTeamById(int matchId) async {
    final db = await DBHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      'match_teams',
      where: 'id = ?',
      whereArgs: [matchId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> readMatchesTeamByLeague(String leagueId) async {
    final db = await DBHelper().database;
    return await db.query(
      'match_teams',
      where: 'league_id = ?',
      whereArgs: [leagueId],
      orderBy: 'date DESC',
    );
  }

  Future<Map<int, Map<String, dynamic>>> getMatchTeamResultsForMap(String leagueId) async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> matches = await db.query(
      'match_teams',
      where: 'league_id = ?',
      whereArgs: [leagueId],
    );

    Map<int, Map<String, dynamic>> matchResults = {};

    for (var match in matches) {
      int id = match['id'];
      int winnerId = match['winner_id'];


      int loserId = match['team1_id'] == winnerId ? match['team2_id'] : match['team1_id'];

      int scoreW = match['team1_score'] < match['team2_score'] ? match['team2_score'] : match['team1_score'];
      int scoreL = match['team1_score'] > match['team2_score'] ? match['team2_score'] : match['team1_score'];

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
      'match_teams',
      where: 'league_id = ?',
      whereArgs: [leagueId],
    );

    List<Map<String, String>> matchResults = [];

    for (var match in matches) {
      int winnerId = match['winner_id'];
      int loserId = (winnerId == match['team1_id']) ? match['team2_id'] : match['team1_id'];

      String winnerName = await TeamDao().getTeamNameById(winnerId);
      String loserName = await TeamDao().getTeamNameById(loserId);

      matchResults.add({
        'winner': winnerName,
        'loser': loserName,
      });
    }

    return matchResults;
  }


  Future<void> deleteTeamMatch(int matchId) async {
    final db = await DBHelper().database;
    try {
      await db.delete(
        'match_teams',
        where: 'id = ?',
        whereArgs: [matchId],
      );

      await _firestoreService.deleteMatchTeamFromFirestore(matchId);

    } catch (e) {
      throw Exception('Hiba történt a csapat liga törlésénél: $e');
    }
  }

  Future<void> updateTeamMatch(int matchId, Map<String, dynamic> updatedData, String leagueId) async{
    final db = await DBHelper().database;
    try {
      List<Map<String, dynamic>> existingTeam = await db.query(
        'match_teams',
        where: 'id = ?',
        whereArgs: [matchId],
      );

      if (existingTeam.isNotEmpty) {

        await db.update(
          'match_teams',
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

  Future<void> updateMatchThemesForTeam(int teamId, String newTheme) async {
    final db = await DBHelper().database;
    Map<String, String> updatedData;
    try {
      const matchTable = 'match_teams';

      final matches = await db.query(
        matchTable,
        where: 'team1_id = ? OR team2_id = ?',
        whereArgs: [teamId, teamId],
      );

      for (var match in matches) {
        int matchId = match['id'] as int;

        if (match['team1_id'] == teamId) {
          await db.update(
            matchTable,
            {'team1_theme': newTheme},
            where: 'id = ?',
            whereArgs: [matchId],
          );


          print("Updated team1_theme for match ID: $matchId");
        }
        if (match['team2_id'] == teamId) {
          await db.update(
            matchTable,
            {'team2_theme': newTheme},
            where: 'id = ?',
            whereArgs: [matchId],
          );



          print("Updated team2_theme for match ID: $matchId");
        }

        await _firestoreService.updateMatchThemesForTeamInFirestore(teamId, newTheme);

      }
    } catch (e) {
      print("Error updating match theme: $e");
    }
  }
}