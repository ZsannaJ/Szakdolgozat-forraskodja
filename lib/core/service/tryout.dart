import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/dao/match_individual_dao.dart';
import 'package:ranker/core/dao/match_team_dao.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/local_db/db_helper.dart';

class PageRankTry{

  Future<Map<int, Map<String, dynamic>>> PageRankTesterAlgorithm(String leagueId, Map<String, dynamic> match) async {
    bool isTeamLeague = await LeagueDao().isTeamLeague(leagueId);
    Map<String, dynamic>? leagueData = await LeagueDao().getLeagueData(leagueId);
    Map<int, Map<String, dynamic>> players;
    Map<int, Map<String, dynamic>> matches;

    int newMatchId;

    if(!isTeamLeague){
      players = await PlayerDao().getPlayersForMap(leagueId);
      matches = await MatchIndividualDao().getMatchIndividualForMap(leagueId);
      print("player");
      print(players);
      print(matches);

      newMatchId = await DBHelper().generateUniqueIndividualMatchId();
    }else{
      players = await TeamDao().getTeamsForMap(leagueId);
      matches = await MatchTeamDao().getMatchTeamResultsForMap(leagueId);
      print("team");
      print(players);
      print(matches);

      newMatchId = await DBHelper().generateUniqueTeamMatchId();
    }


    matches[newMatchId] = match;

    print("\n");
    print(matches);

    double beta = leagueData?['beta'] ?? 0.0;
    print('\nBeta: $beta');
    int N = players.isNotEmpty ? players.length : 1;

    players = initialize(players, N);
    List<double> newscores = [];

    do{
      newscores = OneCycle(players, matches, N, beta/100);

      if (comparePlayerScores(players, newscores)){
        setPlayerRanks(players);


        List<MapEntry<int, Map<String, dynamic>>> sortedPlayers = players.entries.toList()
          ..sort((a, b) {
            return b.value['points'].compareTo(a.value['points']);
          });

        // Ha szükséges, visszaalakíthatod a sorted listát mapbe
        players = Map.fromEntries(sortedPlayers);

        print(players);  // Kiírás a rendezett játékosokkal
        return players;  // Visszaadjuk a rendezett játékosokat
      }
      //print(players);
    }while(true);

  }

  Map<int, Map<String, dynamic>> initialize(Map<int, Map<String, dynamic>> players, int N) {
    if (N == 0) {
      N = 1;
    }
    double normalizedValue = 1.0 / N;  // Minden játékos "normalizált" értéke.
    players.forEach((key, value) {
      value['points'] = normalizedValue;  // Az összes játékos 'points' értéke 1 / N
    });

    return players;  // Eredmény megjelenítése
  }

  List<double> OneCycle(Map<int, Map<String, dynamic>> players, Map<int, Map<String, dynamic>> matches, int N, double beta){
    List<double> newscores = [];
    double alfa = 0.15;

    for (var entry in players.entries) {  //Végigmegy minden játékoson
      int key = entry.key; // Játékos ID
      double metchResult = 0;

      for (var entry in matches.entries) {    //Végigmegy a mecseken amiket a játékos játszott és összeadja az értékeket.
        if (entry.value['winner_id'] == key) {

          Map<String, dynamic> value = entry.value;
          int sw = value["score_w"];
          int sl = value["score_l"]==0 ? 1 : value["score_l"];
          int loser = value["loser_id"];

          if (players.containsKey(loser)) {
            Map<String, dynamic> player = players[loser]!;

            // Lekérdezheted az adott játékos pontjait:
            double PR = player['points'];  // Nyertes pontszám
            int L = player["loss_count"]==0 ? 1 : player["loss_count"];

            //print('\nBeta: $beta');
            double scoreValue = 1 + (((sw / sl) - 1) * beta);
            //print(score_value);

            metchResult += (PR*scoreValue)/L;
            print('$PR * (1 + ($sw / $sl - 1) * $beta) / $L');
          }

        }


      }

      double newscore = (alfa/N)+((1-alfa)*metchResult);
      newscores.add(newscore);
    }

    print(newscores);

    double totalScore = newscores.reduce((sum, score) => sum + score);

    if(totalScore != 0) {
      newscores = newscores.map((score) => score / totalScore).toList();
    }
    print('totalScore: $totalScore');
    print('normalizalt scores: $newscores');

    return newscores;
  }

  bool comparePlayerScores(Map<int, Map<String, dynamic>> players, List<double> newscores) {
    int counter = 0; // Eltérések száma
    List<int> playerIds = players.keys.toList(); // Játékosok ID-k listája

    // Ellenőrizzük, hogy a lista és a players hosszúsága megegyezik-e
    if (players.length != newscores.length) {
      print('A players és a newscores lista hossza nem egyezik!');
      return false;
    }

    // Végigmegyünk az összes játékoson
    for (int i = 0; i < players.length; i++) {
      int playerId = playerIds[i];
      double currentScore = players[playerId]?['points'] ?? 0.0;  // Játékos aktuális pontja
      double newScore = newscores[i];  // Az új pont érték a listából

      // Összehasonlítjuk az új értéket a meglévő értékkel (4 tizedesjegyig)
      if ((currentScore - newScore).abs() > 0.0001) {  // Ha a két érték különbözik 4 tizedesjegyig
        counter++;
        players[playerId]?['points'] = newScore;  // Frissítjük a player pontjait a newscore értékkel
      }
    }

    // Ellenőrizzük, hogy voltak-e eltérések
    if (counter > 0) {
      print('Az eltérések száma: $counter');
      return false;
    } else {
      print('Minden érték megegyezik!');
      return true;
    }
  }

  void setPlayerRanks(Map<int, Map<String, dynamic>> players) {
    // Játékosok rendezése pontok alapján (csökkenő sorrendben)
    List<MapEntry<int, Map<String, dynamic>>> playerList = players.entries.toList();
    playerList.sort((a, b) => b.value['points'].compareTo(a.value['points']));  // Pontok szerint csökkenő sorrend

    int rank = 0;  // Kezdőrang
    double lastScore = -1;  // Az előző játékos pontszáma

    for (int i = 0; i < playerList.length; i++) {
      int playerId = playerList[i].key;
      double currentScore = playerList[i].value['points'];

      if (currentScore != lastScore) {
        // Ha új pontszámot találunk, akkor növeljük a rangot
        rank++;
        players[playerId]?['rank'] = rank;
        print('score: $currentScore != $lastScore --> $rank');
        lastScore = currentScore;
      } else {
        // Ha ugyanaz a pontszám, akkor nem növeljük a rangot, ugyanazt a rangot kapják
        players[playerId]?['rank'] = rank;
        print('score: $currentScore == $lastScore --> $rank');
      }
    }

    // Kiíratjuk a rangokat, hogy lássuk az eredményt
    print('Player ranks:');
    players.forEach((id, player) {
      print('Player ID: $id, Rank: ${player['rank']}, Points: ${player['points']}');
    });
  }




}