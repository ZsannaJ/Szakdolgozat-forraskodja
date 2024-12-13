import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/firebase/FirestoreService.dart';
import 'package:sqflite/sqflite.dart';

class TeamDao {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> createTeam(Map<String, dynamic> teamData) async {
    final db = await DBHelper().database;
    await db.insert('teams', teamData);
    await _firestoreService.addTeam(teamData);
  }

  Future<Map<String, dynamic>?> readTeamById(int teamId) async {
    final db = await DBHelper().database;
    List<Map<String, dynamic>> result = await db.query(
      'teams',
      where: 'id = ?',
      whereArgs: [teamId],
      orderBy: 'name ASC',
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> readTeamsByLeague(String leagueId) async {
    final db = await DBHelper().database;
    print("itt vagyok");
    return await db.query(
      'teams',
      where: 'league_id = ?',
      whereArgs: [leagueId],
      orderBy: 'name ASC',
    );
  }

  Future<List<Map<String, dynamic>>> readTeamsByLeagueRank(String leagueId) async {
    final db = await DBHelper().database;
    print("itt vagyok");
    return await db.query(
      'teams',
      where: 'league_id = ?',
      whereArgs: [leagueId],
      orderBy: 'rank ASC',
    );
  }

  Future<String> getTeamNameById(int teamId) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> results = await db.query(
      'teams',
      where: 'id = ?',
      whereArgs: [teamId],
    );

    if (results.isNotEmpty) {
      return results.first['name'] as String;
    }
    return '';
  }

  Future<bool> checkTeamExists(dynamic leagueId) async {
    return Future.value(leagueId is int);
  }

  Future<Map<int, Map<String, dynamic>>> getTeamsForMap(String leagueId) async {
    final db = await DBHelper().database;


    final List<Map<String, dynamic>> teamsData = await db.query(
      'teams',
      where: 'league_id = ?',
      whereArgs: [leagueId],
    );


    Map<int, Map<String, dynamic>> teamsMap = {};

    for (var team in teamsData) {
      int teamId = team['id'];
      teamsMap[teamId] = {
        'name': team['name'],
        'rank': team['rank'],
        'points': team['points'],
        'loss_count': team['loss_count'],
      };
    }

    return teamsMap;
  }

  Future<void> updateTeamStats( int teamId) async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> winsResult = await db.rawQuery('''
    SELECT COUNT(*) as win_count
    FROM match_teams
    WHERE winner_id = ?
  ''', [teamId]);

    int winCount = winsResult.isNotEmpty ? winsResult.first['win_count'] : 0;

    final List<Map<String, dynamic>> lossesResult = await db.rawQuery('''
    SELECT COUNT(*) as loss_count
    FROM match_teams
    WHERE (team1_id = ? OR team2_id = ?)
      AND winner_id != ?
  ''', [teamId, teamId, teamId]);

    int lossCount = lossesResult.isNotEmpty ? lossesResult.first['loss_count'] : 0;

    await db.rawUpdate('''
    UPDATE teams
    SET win_count = ?, loss_count = ?
    WHERE id = ?
  ''', [winCount, lossCount, teamId]);

    print('Team $teamId win count: $winCount, loss count: $lossCount');
  }


  Future<void> updateTeamPoints(String leagueId, int teamId, double points) async {
    final db = await DBHelper().database;
    await db.update(
        'teams',
        {'points': points},
        where: 'id = ?',
        whereArgs: [teamId]
    );
    updateTeamRanks(leagueId);
  }

  Future<void> updateTeamRanks(String leagueId) async {
    Database db = await DBHelper().database;

    List<Map<String, dynamic>> teams = await db.query(
      'teams',
      where: 'league_id = ?',
      whereArgs: [leagueId],
    );

    List<Map<String, dynamic>> teamsCopy = List.from(teams);

    teamsCopy.sort((a, b) {
      double pointsA = a['points'] ?? 0.0;
      double pointsB = b['points'] ?? 0.0;
      return pointsB.compareTo(pointsA);
    });

    int rank = 1;  // Az első csapat kapja az 1-es rangot
    for (int i = 0; i < teamsCopy.length; i++) {
      // Ha az aktuális csapat pontszáma ugyanaz, mint az előző csapaté,
      // akkor ugyanazt a rangot kapja
      if (i > 0 && teamsCopy[i]['points'] == teamsCopy[i - 1]['points']) {
        // Ha ugyanaz a pontszám, ne változtassuk a rangot
        await db.update(
          'teams',
          {'rank': rank},    // Ugyanaz a rang
          where: 'id = ?',    // Az id alapján frissítjük
          whereArgs: [teamsCopy[i]['id']],
        );
      } else {
        // Ha nem ugyanaz a pontszám, akkor új rangot adunk
        rank = i + 1;  // Az új rang az i+1 lesz
        await db.update(
          'teams',
          {'rank': rank},    // Az új rang frissítése
          where: 'id = ?',    // Az id alapján frissítjük
          whereArgs: [teamsCopy[i]['id']],
        );
      }
    }
  }

  Future<void> updateTeam(int teamId, Map<String, dynamic> updatedData) async {
    final db = await DBHelper().database;

    try {
      List<Map<String, dynamic>> existingTeam = await db.query(
        'teams',
        where: 'id = ?',
        whereArgs: [teamId],
      );

      // Ha létezik a csapat a helyi adatbázisban, akkor frissítjük
      if (existingTeam.isNotEmpty) {
        await db.update(
          'teams',
          updatedData,
          where: 'id = ?',
          whereArgs: [teamId],
        );
        print("Team data updated in local database.");

        // Frissítjük a csapatot a Firestore adatbázisban is
        await _firestoreService.updateTeamFirestore(teamId, updatedData);
        print("Team data updated in Firestore.");
      } else {
        print("No matching team found in local database.");
      }
    } catch (e) {
      print("Error updating team data: $e");
    }
  }


  Future<void> deleteTeam(int teamId) async{
    final db = await DBHelper().database;
    try {
      await db.delete(
        'match_teams',
        where: 'team1_id = ? OR team2_id = ?',
        whereArgs: [teamId, teamId],
      );
      print('Meccsek törölve a ligából: $teamId');

      await db.delete(
        'teams',
        where: 'id = ?',
        whereArgs: [teamId],
      );
      print('Csapat törölve a ligából: $teamId');

      await _firestoreService.deleteMatchesByTeamId(teamId);
      await _firestoreService.deleteTeamFromFirestore(teamId);

    } catch (e) {
      throw Exception('Hiba történt a játékos törlésénél: $e');
    }
  }



}
