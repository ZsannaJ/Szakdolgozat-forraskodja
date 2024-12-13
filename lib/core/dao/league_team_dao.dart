import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/firebase/FirestoreService.dart';

class LeagueTeamDao {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createTeamLeague(Map<String, dynamic> leagueData) async {
    final db = await DBHelper().database;

    await db.insert('team_leagues', leagueData);

    await _firestoreService.addTeamLeague(leagueData);
  }

  Future<Map<String, dynamic>?> readTeamLeagueById(String leagueId) async {
    final db = await DBHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      'team_leagues',
      where: 'id = ?',
      whereArgs: [leagueId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> listAllTeamLeagues() async {
    final db = await DBHelper().database;
    return await db.query(
      'team_leagues',
      orderBy: 'creation_date ASC',
    );
  }

  Future<void> updateTeamLeague(String leagueId, Map<String, dynamic> updatedData) async {
    final db = await DBHelper().database;

    try {
      List<Map<String, dynamic>> existingTeam = await db.query(
        'team_leagues',
        where: 'id = ?',
        whereArgs: [leagueId],
      );

      if (existingTeam.isNotEmpty) {

        await db.update(
          'team_leagues',
          updatedData,
          where: 'id = ?',
          whereArgs: [leagueId],
        );
        print("Match data updated in local database.");

        await _firestoreService.updateLeagueInFirestore(leagueId, updatedData);
        print("League data updated in Firestore.");
      } else {
        print("No matching league found in local database.");
      }
    } catch (e) {
      print("Error updating league data: $e");
    }
  }

  Future<void> deleteTeamLeague(String leagueId) async {
    final db = await DBHelper().database;
    try {
      await db.delete(
        'match_teams',
        where: 'league_id = ?',
        whereArgs: [leagueId],
      );
      print('Csapat meccsek törölve a ligából: $leagueId');


      await db.delete(
        'teams',
        where: 'league_id = ?',
        whereArgs: [leagueId],
      );
      print('Csapatok törölve a ligából: $leagueId');


      await db.delete(
        'team_leagues',
        where: 'id = ?',
        whereArgs: [leagueId],
      );

      await _firestoreService.deleteMatchTeamFromFirestoreByLeagueId(leagueId);
      await _firestoreService.deleteTeamFromFirestoreByLeagueId(leagueId);
      await _firestoreService.deleteLeagueTeamFromFirestore(leagueId);

      print('Csapat liga törölve: $leagueId');
    } catch (e) {
      throw Exception('Hiba történt a csapat liga törlésénél: $e');
    }
  }


}