import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/dao/match_individual_dao.dart';
import 'package:ranker/core/dao/match_team_dao.dart';
import 'package:ranker/core/dao/league_individual_dao.dart';
import 'package:ranker/core/dao/league_team_dao.dart';
import 'package:ranker/core/service/pagerank.dart';

class FirestoreServiceLissen {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void listenToPlayerChanges() {
    // Figyelés a players gyűjteményre
    _db.collection('players').snapshots().listen((snapshot) async {
      for (var docChange in snapshot.docChanges) {

        if (docChange.type == DocumentChangeType.added) {
          // Új játékos hozzáadása
          Map<String, dynamic> newPlayerData = docChange.doc.data()!;
          int playerId = newPlayerData['id'];
          String leagueId = newPlayerData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            // Frissítjük a helyi adatbázist új játékos hozzáadásával
            _addPlayerToLocalDatabase(newPlayerData, leagueId);
            print("New player added: ${newPlayerData['name']}");
          }

        }

        if (docChange.type == DocumentChangeType.modified) {
          // Játékos módosítása
          Map<String, dynamic> updatedPlayerData = docChange.doc.data()!;
          int playerId = updatedPlayerData['id'];
          String leagueId = updatedPlayerData['league_id'];


          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            // Frissítjük a helyi adatbázist a változásokkal
            _updateLocalPlayerDatabase(playerId, updatedPlayerData, leagueId);
            print("Player updated: ${updatedPlayerData['name']}");
          }
        }

        if (docChange.type == DocumentChangeType.removed) {
          // Játékos törlése
          Map<String, dynamic> removedPlayerData = docChange.doc.data()!;
          int playerId = removedPlayerData['id'];
          String leagueId = removedPlayerData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            // Töröljük a helyi adatbázisból a játékost
            _removePlayerFromLocalDatabase(playerId, leagueId);
            print("Player removed: ${removedPlayerData['name']}");
          }
        }
      }
    });
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal
  Future<void> _updateLocalPlayerDatabase(int playerId, Map<String, dynamic> updatedData, String leagueId) async {
    try {
      // Használjuk a PlayerDAO-t a helyi adatbázis frissítésére

      await PlayerDao().updateLocalPlayerDatabase(playerId, updatedData);
      PageRank().PageRankAlgorithm(leagueId);
      print("Player data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Helyi adatbázisba új játékos hozzáadása
  Future<void> _addPlayerToLocalDatabase(Map<String, dynamic> playerData, String leagueId) async {
    try {
      await PlayerDao().createPlayer(playerData);
      PageRank().PageRankAlgorithm(leagueId);
      print("Player added to local database.");
    } catch (e) {
      print("Error adding player to local database: $e");
    }
  }

  // Helyi adatbázisba új játékos hozzáadása
  Future<void> _removePlayerFromLocalDatabase(int playerId, String leagueId) async {
    try {
      await PlayerDao().deletePlayer(playerId);
      PageRank().PageRankAlgorithm(leagueId);
      print("Player added to local database.");
    } catch (e) {
      print("Error adding player to local database: $e");
    }
  }

  // Az adatok figyelése a Firestore-ból (Teams)
  void listenToTeamChanges() {
    _db.collection('teams').snapshots().listen((snapshot) async {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          // Új csapat hozzáadása
          Map<String, dynamic> newTeamData = docChange.doc.data()!;
          String leagueId = newTeamData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _addTeamToLocalDatabase(newTeamData, leagueId);
            print("New team added: ${newTeamData['name']}");
          }
        }

        if (docChange.type == DocumentChangeType.modified) {
          // Csapat módosítása
          Map<String, dynamic> updatedTeamData = docChange.doc.data()!;
          String leagueId = updatedTeamData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _updateLocalTeamDatabase(updatedTeamData['id'], updatedTeamData, leagueId);
            print("Team updated: ${updatedTeamData['name']}");
          }
        }

        if (docChange.type == DocumentChangeType.removed) {
          // Csapat törlése
          Map<String, dynamic> removedTeamData = docChange.doc.data()!;
          String leagueId = removedTeamData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _removeTeamFromLocalDatabase(removedTeamData['id'],leagueId);
            print("Team removed: ${removedTeamData['name']}");
          }
        }
      }
    });
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Teams)
  Future<void> _updateLocalTeamDatabase(int teamId, Map<String, dynamic> updatedData, String leagueId) async {
    try {
      // Használjuk a TeamDAO-t a helyi adatbázis frissítésére
      await TeamDao().updateTeam(teamId, updatedData);
      PageRank().PageRankAlgorithm(leagueId);
      print("Team data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Teams)
  Future<void> _addTeamToLocalDatabase(Map<String, dynamic> updatedData, String leagueId) async {
    try {
      // Használjuk a TeamDAO-t a helyi adatbázis frissítésére
      await TeamDao().createTeam(updatedData);
      PageRank().PageRankAlgorithm(leagueId);
      print("Team data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Teams)
  Future<void> _removeTeamFromLocalDatabase(int teamId, String leagueId) async {
    try {
      // Használjuk a TeamDAO-t a helyi adatbázis frissítésére
      await TeamDao().deleteTeam(teamId);
      PageRank().PageRankAlgorithm(leagueId);
      print("Team data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }


  // Az adatok figyelése a Firestore-ból (Match Individuals)
  void listenToMatchIndividualChanges() {
    _db.collection('match_individuals').snapshots().listen((snapshot) async {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          // Új egyéni mérkőzés hozzáadása
          Map<String, dynamic> newMatchData = docChange.doc.data()!;
          String leagueId = newMatchData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _addMatchIndividualToLocalDatabase(newMatchData, leagueId);
            print("New individual match added");
          }
        }

        if (docChange.type == DocumentChangeType.modified) {
          // Egyéni mérkőzés módosítása
          Map<String, dynamic> updatedMatchData = docChange.doc.data()!;
          String leagueId = updatedMatchData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _updateLocalMatchIndividualDatabase(updatedMatchData['id'], updatedMatchData, leagueId);
            print("Individual match updated");
          }
        }

        if (docChange.type == DocumentChangeType.removed) {
          // Egyéni mérkőzés törlése
          Map<String, dynamic> removedMatchData = docChange.doc.data()!;
          String leagueId = removedMatchData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _removeMatchIndividualFromLocalDatabase(removedMatchData['id'], leagueId);
            print("Individual match removed");
          }
        }
      }
    });
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Individual Match)
  Future<void> _updateLocalMatchIndividualDatabase(int matchId, Map<String, dynamic> updatedData, String leagueId) async {
    try {
      await MatchIndividualDao().updateIndividualMatch(matchId, updatedData, leagueId);
      PageRank().PageRankAlgorithm(leagueId);
      print("Match data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Individual Match)
  Future<void> _addMatchIndividualToLocalDatabase(Map<String, dynamic> updatedData, String leagueId) async {
    try {
      await MatchIndividualDao().createMatchIndividual(updatedData);
      PageRank().PageRankAlgorithm(leagueId);
      print("Match data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Individual Match)
  Future<void> _removeMatchIndividualFromLocalDatabase(int matchId, String leagueId) async {
    try {
      await MatchIndividualDao().deleteIndividualMatch(matchId);
      PageRank().PageRankAlgorithm(leagueId);
      print("Match data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Az adatok figyelése a Firestore-ból (Match Teams)
  void listenToMatchTeamChanges() {
    _db.collection('match_teams').snapshots().listen((snapshot) async {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          // Új csapat mérkőzés hozzáadása
          Map<String, dynamic> newMatchData = docChange.doc.data()!;
          String leagueId = newMatchData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _addMatchTeamToLocalDatabase(newMatchData, leagueId);
            print("New team match added");
          }
        }

        if (docChange.type == DocumentChangeType.modified) {
          // Csapat mérkőzés módosítása
          Map<String, dynamic> updatedMatchData = docChange.doc.data()!;
          String leagueId = updatedMatchData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _updateLocalMatchTeamDatabase(updatedMatchData['id'], updatedMatchData, leagueId);
            print("Team match updated");
          }
        }

        if (docChange.type == DocumentChangeType.removed) {
          // Csapat mérkőzés törlése
          Map<String, dynamic> removedMatchData = docChange.doc.data()!;
          String leagueId = removedMatchData['league_id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _removeMatchTeamFromLocalDatabase(removedMatchData['id'], leagueId);
            print("Team match removed");
          }
        }
      }
    });
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Team Match)
  Future<void> _updateLocalMatchTeamDatabase(int matchId, Map<String, dynamic> updatedData, String leagueId) async {
    try {
      await MatchTeamDao().updateTeamMatch(matchId, updatedData, leagueId);
      PageRank().PageRankAlgorithm(leagueId);
      print("Match data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Team Match)
  Future<void> _addMatchTeamToLocalDatabase(Map<String, dynamic> updatedData, String leagueId) async {
    try {
      await MatchTeamDao().createMatchTeam(updatedData);
      PageRank().PageRankAlgorithm(leagueId);
      print("Match data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Team Match)
  Future<void> _removeMatchTeamFromLocalDatabase(int matchId, String leagueId) async {
    try {
      await MatchTeamDao().deleteTeamMatch(matchId);
      PageRank().PageRankAlgorithm(leagueId);
      print("Match data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Az adatok figyelése a Firestore-ból (Individual League)
  void listenToLeagueIndividualChanges() {

    _db.collection('individual_leagues').snapshots().listen((snapshot) async {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.modified) {
          Map<String, dynamic> updatedTeamData = docChange.doc.data()!;
          String leagueId = updatedTeamData['id'];
          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _updateLocalLeagueIndividualDatabase(leagueId, updatedTeamData);
          }
        }
        if (docChange.type == DocumentChangeType.removed) {
          Map<String, dynamic> removedMatchData = docChange.doc.data()!;
          String leagueId = removedMatchData['id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _removeLeagueIndividualFromLocalDatabase(removedMatchData['id']);
            print("Individual league removed");
          }
        }
      }
    });
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Team Match)
  Future<void> _updateLocalLeagueIndividualDatabase(String leagueId, Map<String, dynamic> updatedData) async {
    try {

      await LeagueIndividualDao().updateLeague(leagueId, updatedData);
      PageRank().PageRankAlgorithm(leagueId);
      print("League data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  Future<void> _removeLeagueIndividualFromLocalDatabase(String leagueId) async {
    try {

      await LeagueIndividualDao().deleteLeague(leagueId);
      print("League data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  // Az adatok figyelése a Firestore-ból (Team League)
  void listenToLeagueTeamChanges() {

    _db.collection('team_leagues').snapshots().listen((snapshot) async {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.modified) {
          Map<String, dynamic> updatedTeamData = docChange.doc.data()!;
          String leagueId = updatedTeamData['id'];
          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _updateLocalLeagueTeamDatabase(leagueId, updatedTeamData);
          }
        }
        if (docChange.type == DocumentChangeType.removed) {
          Map<String, dynamic> removedMatchData = docChange.doc.data()!;
          String leagueId = removedMatchData['id'];

          bool isLeagueExist = await LeagueDao().isLeagueExist(leagueId);
          if(isLeagueExist){
            _removeLeagueTeamFromLocalDatabase(removedMatchData['id']);
          }
        }
      }
    });
  }

  // Helyi adatbázis frissítése a Firebase-ből érkező adatokkal (Team Match)
  Future<void> _updateLocalLeagueTeamDatabase(String leagueId, Map<String, dynamic> updatedData) async {
    try {

      await LeagueTeamDao().updateTeamLeague(leagueId, updatedData);
      print("League data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

  Future<void> _removeLeagueTeamFromLocalDatabase(String leagueId) async {
    try {

      await LeagueTeamDao().deleteTeamLeague(leagueId);
      print("League data updated in local database.");
    } catch (e) {
      print("Error updating local database: $e");
    }
  }

}
