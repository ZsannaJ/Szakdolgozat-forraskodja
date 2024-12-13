import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/firebase/FirestoreService.dart';
import 'package:ranker/firebase/FirestoreService_Search.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ranker/core/dao/league_individual_dao.dart';
import 'package:ranker/core/dao/league_team_dao.dart';

class LeagueDao {
  final FirestoreService _firestoreService = FirestoreService();
  final LeagueIndividualDao individualDao = LeagueIndividualDao();
  final LeagueTeamDao teamDao = LeagueTeamDao();

  Future<bool> isTeamLeague(String leagueId) async {
    final db = await DBHelper().database;

    final result = await db.query(
      'team_leagues',
      where: 'id = ?',
      whereArgs: [leagueId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<int> countLeagueParticipants(String leagueId) async {
    final db = await DBHelper().database;
    bool isTeamBased = await isTeamLeague(leagueId);

    if (isTeamBased) {
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count FROM teams WHERE league_id = ?
      ''', [leagueId]);
      return Sqflite.firstIntValue(result) ?? 0;
    }
    else {
      final result = await db.rawQuery('''
        SELECT COUNT(*) as count FROM players WHERE league_id = ?
      ''', [leagueId]);
      return Sqflite.firstIntValue(result) ?? 0;
    }
  }

  Future<String?> readDescription(String leagueId) async {
    final db = await DBHelper().database;

    bool isTeamBased = await isTeamLeague(leagueId);
    List<Map<String, dynamic>> result;

    if (isTeamBased) {
      result = await db.query(
        'team_leagues',
        columns: ['description'],
        where: 'id = ?',
        whereArgs: [leagueId],
      );
    } else {
      result = await db.query(
        'individual_leagues',
        columns: ['description'],
        where: 'id = ?',
        whereArgs: [leagueId],
      );
    }

    if (result.isNotEmpty) {
      return result.first['description'];
    } else {
      return 'Description not found';
    }
  }

  Future<void> updateDescription(String leagueId, String newDescription) async {
    final db = await DBHelper().database;
    var batch = db.batch();

    bool isTeamBased = await isTeamLeague(leagueId);

    if (isTeamBased) {
      batch.update(
        'team_leagues',
        {'description': newDescription},
        where: 'id = ?',
        whereArgs: [leagueId],
      );
    } else {
      batch.update(
        'individual_leagues',
        {'description': newDescription},
        where: 'id = ?',
        whereArgs: [leagueId],
      );
    }

    await _firestoreService.updateDescriptionInFirestore(leagueId, newDescription);

    await batch.commit(noResult: true);
  }


  Future<String?> getLeagueNameById(String leagueId) async {
    final individualLeague = await individualDao.readIndividualLeagueById(leagueId);
    if (individualLeague != null) {
      return individualLeague['name'] as String?;
    }

    final teamLeague = await teamDao.readTeamLeagueById(leagueId);
    return teamLeague?['name'] as String?;
  }

  Future<Map<String, dynamic>?> getLeagueData(String leagueId) async {
    final db = await DBHelper().database;

    bool isTeamLeague = await LeagueDao().isTeamLeague(leagueId);
    String table = isTeamLeague ? 'team_leagues' : 'individual_leagues';

    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [leagueId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      print('Nincs találat a ligával kapcsolatban.');
      return null;
    }
  }

  Future<bool> isLeagueExist(String leagueId) async {
    final db = await DBHelper().database;

    bool isTeamLeague = await LeagueDao().isTeamLeague(leagueId);
    String table = isTeamLeague ? 'team_leagues' : 'individual_leagues';

    final result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [leagueId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }




  Future<bool> findLeagueInLocalDatabase(String leagueId, String password) async {
    final db = await DBHelper().database;

    try {
      var result = await db.query(
        'individual_leagues',
        where: 'id = ? AND password = ?',
        whereArgs: [leagueId, password],
      );

      if (result.isNotEmpty) {
        print("Found league in individual_leagues table.");
        return false;
      }

      result = await db.query(
        'team_leagues',
        where: 'id = ? AND password = ?',
        whereArgs: [leagueId, password],
      );

      if (result.isNotEmpty) {
        print("Found league in team_leagues table.");
        return false;
      }

      print("No league found in local database.");
      bool eredmeny = await FirestoreServiceSearch().findLeagueByIdAndPassword(leagueId, password);
      return eredmeny;

    } catch (e) {
      print("Error checking local database for league: $e");
      return false;
    }
  }

}