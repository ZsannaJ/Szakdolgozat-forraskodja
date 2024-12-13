import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ranker/core/dao/league_dao.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Player hozzáadása
  Future<void> addPlayer(Map<String, dynamic> playerData) async {
    try {
      await _db.collection('players').add(playerData);
      print("Player added successfully!");
    } catch (e) {
      print("Error adding player: $e");
    }
  }

  // Csapat hozzáadása
  Future<void> addTeam(Map<String, dynamic> teamData) async {
    try {
      // A Firestore automatikusan létrehozza a gyűjteményt ('teams')
      await _db.collection('teams').add(teamData);
      print("Team added successfully!");
    } catch (e) {
      print("Error adding team: $e");
    }
  }

  // Match egyéni hozzáadása
  Future<void> addMatchIndividual(Map<String, dynamic> matchData) async {
    try {
      await _db.collection('match_individuals').add(matchData);
      print("Match added successfully!");
    } catch (e) {
      print("Error adding match: $e");
    }
  }

  // Match csapat hozzáadása
  Future<void> addMatchTeam(Map<String, dynamic> matchData) async {
    try {
      await _db.collection('match_teams').add(matchData);
      print("Match team added successfully!");
    } catch (e) {
      print("Error adding match: $e");
    }
  }

  // Egyéni liga hozzáadása a Firestore-hoz
  Future<void> addIndividualLeague(Map<String, dynamic> leagueData) async {
    try {
      await _db.collection('individual_leagues').add(leagueData);
      print("Individual league added to Firestore");
    } catch (e) {
      print("Error adding individual league to Firestore: $e");
    }
  }

  // Csapat liga hozzáadása a Firestore-hoz
  Future<void> addTeamLeague(Map<String, dynamic> leagueData) async {
    try {
      await _db.collection('team_leagues').add(leagueData);
      print("Team league added to Firestore");
    } catch (e) {
      print("Error adding team league to Firestore: $e");
    }
  }

  // =============================
  //     DELETE METHODS
  // =============================


    Future<void> deletePlayerFromFirestore(int playerId) async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('players')
            .where('id', isEqualTo: playerId)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
          print("Deleted player with ID: ${doc.id}");
        }

        print("All players with ID $playerId have been deleted.");
      } catch (e) {
        print("Error deleting players: $e");
      }
    }

  Future<void> deletePlayerFromFirestoreByLeagueId(String leagueId) async {
    try {
      // Lekérjük az összes dokumentumot, aminek a league_id mezője megegyezik a megadott leagueId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('players')
          .where('league_id', isEqualTo: leagueId)
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted player with ID: ${doc.id} from league $leagueId");
      }

      print("All players with league_id $leagueId have been deleted.");
    } catch (e) {
      print("Error deleting players by league_id: $e");
    }
  }


  Future<void> deleteTeamFromFirestore(int teamId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('id', isEqualTo: teamId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted team with ID: ${doc.id}");
      }

      print("All teams with ID $teamId have been deleted.");
    } catch (e) {
      print("Error deleting teams: $e");
    }
  }

  Future<void> deleteTeamFromFirestoreByLeagueId(String leagueId) async {
    try {
      // Lekérjük az összes dokumentumot, aminek a league_id mezője megegyezik a megadott leagueId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('league_id', isEqualTo: leagueId)
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted team with ID: ${doc.id} from league $leagueId");
      }

      print("All teams with league_id $leagueId have been deleted.");
    } catch (e) {
      print("Error deleting teams by league_id: $e");
    }
  }


  Future<void> deleteMatchIndividualFromFirestore(int matchId) async {
    try {
      // Lekérjük az összes dokumentumot, aminek az ID-ja megegyezik a megadott leagueId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('match_individuals')
          .where('id', isEqualTo: matchId)
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted individual match with ID: ${doc.id}");
      }

      print("All individual matches with ID $matchId have been deleted.");
    } catch (e) {
      print("Error deleting individual matches with ID $matchId: $e");
    }
  }

  Future<void> deleteMatchIndiFromFirestoreByLeagueId(String leagueId) async {
    try {
      // Lekérjük az összes dokumentumot, aminek a league_id mezője megegyezik a megadott leagueId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('match_individuals')
          .where('league_id', isEqualTo: leagueId)
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted match with ID: ${doc.id} from league $leagueId");
      }

      print("All matches with league_id $leagueId have been deleted.");
    } catch (e) {
      print("Error deleting matches by league_id: $e");
    }
  }

  Future<void> deleteMatchesByPlayerId(int playerId) async {
    try {
      // Keresés a 'match_individuals' kollekcióban, ahol a player1_id megegyezik a playerId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('match_individuals')
          .where('player1_id', isEqualTo: playerId)
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted individual match with ID: ${doc.id} where player1_id is $playerId");
      }

      // Most ugyan ezt megismételjük a player2_id alapján
      querySnapshot = await FirebaseFirestore.instance
          .collection('match_individuals')
          .where('player2_id', isEqualTo: playerId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted individual match with ID: ${doc.id} where player2_id is $playerId");
      }

      print("All matches involving player with ID $playerId have been deleted.");
    } catch (e) {
      print("Error deleting matches by player_id: $e");
    }
  }


  Future<void> deleteMatchTeamFromFirestore(int matchId) async {
    try {
      // Lekérjük az összes dokumentumot, aminek az ID-ja megegyezik a megadott leagueId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('match_teams')
          .where('id', isEqualTo: matchId)
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted team match with ID: ${doc.id}");
      }

      print("All team matches with ID $matchId have been deleted.");
    } catch (e) {
      print("Error deleting team matches with ID $matchId: $e");
    }
  }

  Future<void> deleteMatchTeamFromFirestoreByLeagueId(String leagueId) async {
    try {
      // Lekérjük az összes dokumentumot, aminek a league_id mezője megegyezik a megadott leagueId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('match_teams')
          .where('league_id', isEqualTo: leagueId)
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted match with ID: ${doc.id} from league $leagueId");
      }

      print("All matches with league_id $leagueId have been deleted.");
    } catch (e) {
      print("Error deleting matches by league_id: $e");
    }
  }

  Future<void> deleteMatchesByTeamId(int teamId) async {
    try {
      // Keresés a 'match_teams' kollekcióban, ahol a team1_id megegyezik a teamId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('match_teams')
          .where('team1_id', isEqualTo: teamId)
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted team match with ID: ${doc.id} where team1_id is $teamId");
      }

      // Most ugyan ezt megismételjük a team2_id alapján
      querySnapshot = await FirebaseFirestore.instance
          .collection('match_teams')
          .where('team2_id', isEqualTo: teamId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted team match with ID: ${doc.id} where team2_id is $teamId");
      }

      print("All matches involving team with ID $teamId have been deleted.");
    } catch (e) {
      print("Error deleting matches by team_id: $e");
    }
  }


  Future<void> deleteLeagueIndividualFromFirestore(String leagueId) async {
    try {
      // Lekérjük az összes dokumentumot, aminek az ID-ja megegyezik a megadott leagueId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('individual_leagues')
          .where('id', isEqualTo: leagueId)  // Keresés az ID alapján
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted individual league with ID: ${doc.id}");
      }

      print("All individual leagues with ID $leagueId have been deleted.");
    } catch (e) {
      print("Error deleting individual league with ID $leagueId: $e");
    }
  }

  Future<void> deleteLeagueTeamFromFirestore(String leagueId) async {
    try {
      // Lekérjük az összes dokumentumot, aminek az ID-ja megegyezik a megadott leagueId-vel
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('team_leagues')
          .where('id', isEqualTo: leagueId)  // Keresés az ID alapján
          .get();

      // Törlés minden találatot
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        print("Deleted team league with ID: ${doc.id}");
      }

      print("All team leagues with ID $leagueId have been deleted.");
    } catch (e) {
      print("Error deleting team league with ID $leagueId: $e");
    }
  }

  // =============================
  //     UPDATE METHODS
  // =============================

  // Liga leírásának globális frissítése Firestore-ban
  Future<void> updateDescriptionInFirestore(String leagueId, String newDescription) async {
    try {
      bool isTeamBased = await LeagueDao().isTeamLeague(leagueId);

      if (isTeamBased) {
        // Ha csapat alapú a liga, akkor a team_leagues kollekcióban keresünk
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('team_leagues')
            .where('id', isEqualTo: leagueId)  // Keresés a 'league_id' mező alapján
            .get();

        // Törlés minden találatot (bár itt csak egy dokumentumot kell frissíteni, de több is lehet)
        for (var doc in querySnapshot.docs) {
          await doc.reference.update({'description': newDescription});  // Frissítjük a 'description' mezőt
          print("Updated description for team league with league_id: $leagueId");
        }

      } else {
        // Ha egyéni alapú a liga, akkor az individual_leagues kollekcióban keresünk
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('individual_leagues')
            .where('id', isEqualTo: leagueId)  // Keresés a 'league_id' mező alapján
            .get();

        // Törlés minden találatot
        for (var doc in querySnapshot.docs) {
          await doc.reference.update({'description': newDescription});  // Frissítjük a 'description' mezőt
          print("Updated description for individual league with league_id: $leagueId");
        }
      }
    } catch (e) {
      print("Error updating description: $e");
    }
  }

  // Frissíti a ligákat a Firestore-ban
  Future<void> updateLeagueInFirestore(String leagueId, Map<String, dynamic> updatedData) async {
    try {
      bool isTeamBased = await LeagueDao().isTeamLeague(leagueId);  // Ellenőrizzük, hogy csapat alapú liga

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(isTeamBased ? 'team_leagues' : 'individual_leagues')
          .where('id', isEqualTo: leagueId) // Keresés a 'league_id' mező alapján
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No league found with ID: $leagueId");
        return;  // Ha nincs találat, nem próbálkozunk frissíteni
      }

      // Ha van találat, frissítjük az adatokat
      for (var doc in querySnapshot.docs) {
        await doc.reference.update(updatedData);
        print("Updated league data for ${isTeamBased ? 'team' : 'individual'} league with ID: $leagueId");

        // Ellenőrizzük a frissítést
        var updatedDoc = await doc.reference.get();
        if (updatedDoc.exists) {
          print("Updated document: ${updatedDoc.data()}");
        } else {
          print("Failed to fetch updated document with ID: $leagueId");
        }
      }
    } catch (e) {
      print("Error updating league: $e");
    }
  }

  // Frissíti a meccseket a Firestore-ban
  Future<void> updateIndividualMatchFirestore(int matchId, Map<String, dynamic> updatedData, String leagueId) async {
    try {
      bool isTeamLeague = await LeagueDao().isTeamLeague(leagueId);  // Ellenőrizzük, hogy csapat alapú liga-e

      if (!isTeamLeague) {
        // Ha egyéni alapú a liga, akkor az `individual_matches` kollekcióban frissítünk
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('match_individuals')
            .where('id', isEqualTo: matchId)  // Keresés a 'matchId' alapján
            .get();

        // Ha van találat, frissítjük az adatokat
        for (var doc in querySnapshot.docs) {
          await doc.reference.update(updatedData);  // Frissítjük az adatokat
          print("Updated individual match with matchId: $matchId");

          // Ellenőrizhetjük a frissítést
          var updatedDoc = await doc.reference.get();
          if (updatedDoc.exists) {
            print("Updated document: ${updatedDoc.data()}");
          } else {
            print("Failed to fetch updated document with matchId: $matchId");
          }
        }
      } else {
        // Ha csapat alapú a liga, akkor a `team_matches` kollekcióban frissítünk
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('match_teams')
            .where('id', isEqualTo: matchId)  // Keresés a 'matchId' alapján
            .get();

        // Ha van találat, frissítjük az adatokat
        for (var doc in querySnapshot.docs) {
          await doc.reference.update(updatedData);  // Frissítjük az adatokat
          print("Updated team match with matchId: $matchId");

          // Ellenőrizhetjük a frissítést
          var updatedDoc = await doc.reference.get();
          if (updatedDoc.exists) {
            print("Updated document: ${updatedDoc.data()}");
          } else {
            print("Failed to fetch updated document with matchId: $matchId");
          }
        }
      }
    } catch (e) {
      print("Error updating match: $e");
    }
  }

  // Frissíti a játékos adatokat a Firestore-ban
  Future<void> updatePlayerFirestore(int playerId, Map<String, dynamic> updatedData) async {
    try {
      // A 'players' kollekcióban keresünk a 'playerId' alapján
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('players')  // Keresés a 'players' kollekcióban
          .where('id', isEqualTo: playerId)  // Keresés a 'playerId' mező alapján
          .get();

      // Ha találat van, frissítjük az adatokat
      for (var doc in querySnapshot.docs) {
        await doc.reference.update(updatedData);  // Frissítjük az adatokat
        print("Updated player with playerId: $playerId");

        // Ellenőrizhetjük a frissítést
        var updatedDoc = await doc.reference.get();
        if (updatedDoc.exists) {
          print("Updated document: ${updatedDoc.data()}");
        } else {
          print("Failed to fetch updated document with playerId: $playerId");
        }
      }
    } catch (e) {
      print("Error updating player: $e");
    }
  }

  // Frissíti a csapat adatokat a Firestore-ban
  Future<void> updateTeamFirestore(int teamId, Map<String, dynamic> updatedData) async {
    try {
      // A 'teams' kollekcióban keresünk a 'teamId' alapján
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('teams')  // Keresés a 'teams' kollekcióban
          .where('id', isEqualTo: teamId)  // Keresés a 'teamId' mező alapján
          .get();

      // Ha találat van, frissítjük az adatokat
      for (var doc in querySnapshot.docs) {
        await doc.reference.update(updatedData);  // Frissítjük az adatokat
        print("Updated team with teamId: $teamId");

        // Ellenőrizhetjük a frissítést
        var updatedDoc = await doc.reference.get();
        if (updatedDoc.exists) {
          print("Updated document: ${updatedDoc.data()}");
        } else {
          print("Failed to fetch updated document with teamId: $teamId");
        }
      }
    } catch (e) {
      print("Error updating team: $e");
    }
  }

  Future<void> updateMatchThemesForPlayerInFirestore(int playerId, String newTheme) async {
    try {
      // A Firestore megfelelő gyűjteménye
      CollectionReference matchCollection = FirebaseFirestore.instance.collection('match_individuals');

      // Először lekérdezzük azokat a meccseket, ahol player1_id == playerId
      QuerySnapshot querySnapshot1 = await matchCollection
          .where('player1_id', isEqualTo: playerId)
          .get();

      // Majd lekérdezzük azokat a meccseket, ahol player2_id == playerId
      QuerySnapshot querySnapshot2 = await matchCollection
          .where('player2_id', isEqualTo: playerId)
          .get();

      // Összefésüljük az eredményeket
      List<QueryDocumentSnapshot> allMatches = [...querySnapshot1.docs, ...querySnapshot2.docs]
        
        ;

      // Frissítés minden találatot
      for (var doc in allMatches) {
        Map<String, dynamic> matchData = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> updatedData = {};

        // Ha player1_id-hoz tartozik a playerId, akkor a player1_theme-et frissítjük
        if (matchData['player1_id'] == playerId) {
          updatedData['player1_theme'] = newTheme;
          print("Updated player1_theme for match ID: ${doc.id}");
        }

        // Ha player2_id-hoz tartozik a playerId, akkor a player2_theme-et frissítjük
        if (matchData['player2_id'] == playerId) {
          updatedData['player2_theme'] = newTheme;
          print("Updated player2_theme for match ID: ${doc.id}");
        }

        // Firestore frissítése
        await doc.reference.update(updatedData);
      }
    } catch (e) {
      print("Error updating match theme in Firestore: $e");
    }
  }


  Future<void> updateMatchThemesForTeamInFirestore(int teamId, String newTheme) async {
    try {
      // A Firestore megfelelő gyűjteménye
      CollectionReference matchCollection = FirebaseFirestore.instance.collection('match_teams');

      // Először lekérdezzük azokat a meccseket, ahol player1_id == playerId
      QuerySnapshot querySnapshot1 = await matchCollection
          .where('team1_id', isEqualTo: teamId)
          .get();

      // Majd lekérdezzük azokat a meccseket, ahol player2_id == playerId
      QuerySnapshot querySnapshot2 = await matchCollection
          .where('team2_id', isEqualTo: teamId)
          .get();

      // Összefésüljük az eredményeket
      List<QueryDocumentSnapshot> allMatches = [...querySnapshot1.docs, ...querySnapshot2.docs]
        
        ;

      // Frissítés minden találatot
      for (var doc in allMatches) {
        Map<String, dynamic> matchData = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> updatedData = {};

        // Ha player1_id-hoz tartozik a playerId, akkor a player1_theme-et frissítjük
        if (matchData['team1_id'] == teamId) {
          updatedData['team1_theme'] = newTheme;
          print("Updated team1_theme for match ID: ${doc.id}");
        }

        // Ha player2_id-hoz tartozik a playerId, akkor a player2_theme-et frissítjük
        if (matchData['team2_id'] == teamId) {
          updatedData['team2_theme'] = newTheme;
          print("Updated team2_theme for match ID: ${doc.id}");
        }

        // Firestore frissítése
        await doc.reference.update(updatedData);
      }
    } catch (e) {
      print("Error updating match theme in Firestore: $e");
    }
  }

}
