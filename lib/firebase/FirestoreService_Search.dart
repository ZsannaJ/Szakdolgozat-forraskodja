import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/core/service/pagerank.dart';
import 'package:sqflite/sqflite.dart';

class FirestoreServiceSearch {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // Liga keresése az id és password alapján
  Future<bool> findLeagueByIdAndPassword(String id, String password) async {
    try {
      final db = await DBHelper().database;

      // Először a team_leagues gyűjteményt nézzük
      QuerySnapshot teamLeaguesSnapshot = await _db
          .collection('team_leagues')
          .where('id', isEqualTo: id)
          .where('password', isEqualTo: password)
          .get();

      // Ha találunk olyan dokumentumot, akkor kiírjuk a találatokat
      if (teamLeaguesSnapshot.docs.isNotEmpty) {
        print("Found team league:");
        for (var doc in teamLeaguesSnapshot.docs) {
          print(doc.data());

          // Átalakítjuk az adatokat, ha szükséges
          Map<String, dynamic> leagueData = doc.data() as Map<String, dynamic>;

          await db.insert('team_leagues', leagueData,conflictAlgorithm: ConflictAlgorithm.replace);
          print("League saved to local database.");
          findTeamLeagueDataById(id);

          return true;
        }
      }

      // Most az individual_leagues gyűjteményt nézzük
      QuerySnapshot individualLeaguesSnapshot = await _db
          .collection('individual_leagues')
          .where('id', isEqualTo: id)
          .where('password', isEqualTo: password)
          .get();

      // Ha találunk olyan dokumentumot, akkor kiírjuk a találatokat
      if (individualLeaguesSnapshot.docs.isNotEmpty) {
        print("Found individual league:");
        for (var doc in individualLeaguesSnapshot.docs) {
          print(doc.data());

          Map<String, dynamic> leagueData = doc.data() as Map<String, dynamic>;

          await db.insert('individual_leagues', leagueData,conflictAlgorithm: ConflictAlgorithm.replace);
          print("League saved to local database.");
          findIndividualLeagueDataById(id);

          return true;
        }
      }

      // Ha nem találtunk semmit
      if (teamLeaguesSnapshot.docs.isEmpty && individualLeaguesSnapshot.docs.isEmpty) {
        print("No league found with the given ID and password.");
        return false;
      }
    } catch (e) {
      print("Error finding league: $e");
      return false;
    }

    return false;
  }



  Future<void> findIndividualLeagueDataById(String leagueId,) async {
    try {
      final db = await DBHelper().database;

      QuerySnapshot teamLeaguesSnapshot = await _db
          .collection('players')
          .where('league_id', isEqualTo: leagueId)
          .get();

      // Ha találunk olyan dokumentumot, akkor kiírjuk a találatokat
      if (teamLeaguesSnapshot.docs.isNotEmpty) {
        print("Found players in league:");
        for (var doc in teamLeaguesSnapshot.docs) {
          print(doc.data());

          Map<String, dynamic> playerData = doc.data() as Map<String, dynamic>;

          await db.insert('players', playerData,conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      QuerySnapshot individualLeaguesSnapshot = await _db
          .collection('match_individuals')
          .where('league_id', isEqualTo: leagueId)
          .get();

      // Ha találunk olyan dokumentumot, akkor kiírjuk a találatokat
      if (individualLeaguesSnapshot.docs.isNotEmpty) {
        print("Found individual matches in league:");
        for (var doc in individualLeaguesSnapshot.docs) {
          print(doc.data());

          Map<String, dynamic> matchData = doc.data() as Map<String, dynamic>;

          await db.insert('match_individuals', matchData,conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      PageRank().PageRankAlgorithm(leagueId);

      // Ha nem találtunk semmit
      if (teamLeaguesSnapshot.docs.isEmpty && individualLeaguesSnapshot.docs.isEmpty) {
        print("No data found in the league.");
      }
    } catch (e) {
      print("Error finding league data: $e");
    }
  }



  Future<void> findTeamLeagueDataById(String leagueId,) async {
    try {
      final db = await DBHelper().database;

      QuerySnapshot teamLeaguesSnapshot = await _db
          .collection('teams')
          .where('league_id', isEqualTo: leagueId)
          .get();

      // Ha találunk olyan dokumentumot, akkor kiírjuk a találatokat
      if (teamLeaguesSnapshot.docs.isNotEmpty) {
        print("Found teams in league:");
        for (var doc in teamLeaguesSnapshot.docs) {
          print(doc.data());

          Map<String, dynamic> teamData = doc.data() as Map<String, dynamic>;

          await db.insert('teams', teamData,conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      QuerySnapshot individualLeaguesSnapshot = await _db
          .collection('match_teams')
          .where('league_id', isEqualTo: leagueId)
          .get();

      // Ha találunk olyan dokumentumot, akkor kiírjuk a találatokat
      if (individualLeaguesSnapshot.docs.isNotEmpty) {
        print("Found team matches in league:");
        for (var doc in individualLeaguesSnapshot.docs) {
          print(doc.data());

          Map<String, dynamic> matchData = doc.data() as Map<String, dynamic>;

          await db.insert('match_teams', matchData,conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }

      PageRank().PageRankAlgorithm(leagueId);

      // Ha nem találtunk semmit
      if (teamLeaguesSnapshot.docs.isEmpty && individualLeaguesSnapshot.docs.isEmpty) {
        print("No data found in the league.");
      }
    } catch (e) {
      print("Error finding league data: $e");
    }
  }

}