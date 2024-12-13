import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/firebase/FirestoreService.dart';

class LeagueIndividualDao {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createIndividualLeague(Map<String, dynamic> leagueData) async {
    final db = await DBHelper().database;

    await db.insert('individual_leagues', leagueData);

    await _firestoreService.addIndividualLeague(leagueData);
  }

  Future<Map<String, dynamic>?> readIndividualLeagueById(String leagueId) async {
    final db = await DBHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      'individual_leagues',
      where: 'id = ?',
      whereArgs: [leagueId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> listAllIndividualLeagues() async {
    final db = await DBHelper().database;
    return await db.query(
      'individual_leagues',
      orderBy: 'creation_date ASC',
    );
  }

  Future<void> updateLeague(String leagueId, Map<String, dynamic> updatedData) async {
    final db = await DBHelper().database;
    try {
      List<Map<String, dynamic>> existingTeam = await db.query(
        'individual_leagues',
        where: 'id = ?',
        whereArgs: [leagueId],
      );

      if (existingTeam.isNotEmpty) {

        await db.update(
          'individual_leagues',
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

  Future<void> deleteLeague(String leagueId) async {
    final db = await DBHelper().database;
    try {
      await db.delete(
        'match_individuals',
        where: 'league_id = ?',
        whereArgs: [leagueId],
      );
      print('Egyéni meccsek törölve a ligából: $leagueId');

      await db.delete(
        'players',
        where: 'league_id = ?',
        whereArgs: [leagueId],
      );
      print('Játékosok törölve a ligából: $leagueId');

      await db.delete(
        'individual_leagues',
        where: 'id = ?',
        whereArgs: [leagueId],
      );

      await _firestoreService.deleteMatchIndiFromFirestoreByLeagueId(leagueId);
      await _firestoreService.deletePlayerFromFirestoreByLeagueId(leagueId);
      await _firestoreService.deleteLeagueIndividualFromFirestore(leagueId);

      print('Egyéni liga törölve: $leagueId');
    } catch (e) {
      throw Exception('Hiba történt az egyéni liga törlésénél: $e');
    }
  }

}