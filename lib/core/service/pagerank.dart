import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/dao/match_individual_dao.dart';
import 'package:ranker/core/dao/match_team_dao.dart';
import 'package:ranker/core/dao/league_dao.dart';

class PageRank{

  Future<void> PageRankAlgorithm(String leagueId) async {
    bool isTeamLeague = await LeagueDao().isTeamLeague(leagueId);
    Map<String, dynamic>? leagueData = await LeagueDao().getLeagueData(leagueId);
    Map<int, Map<String, dynamic>> players;
    Map<int, Map<String, dynamic>> matches;

    if(!isTeamLeague){
      players = await PlayerDao().getPlayersForMap(leagueId);
      matches = await MatchIndividualDao().getMatchIndividualForMap(leagueId);
    }else{
      players = await TeamDao().getTeamsForMap(leagueId);
      matches = await MatchTeamDao().getMatchTeamResultsForMap(leagueId);
    }
    print(players);
    print(matches);

    if (players.isEmpty) {
      print("No players found for the league. Returning.");
      return;
    }
    double beta = leagueData?['beta'] ?? 0.0;
    int N = players.isNotEmpty ? players.length : 1;

    players = initialize(players, N);
    List<double> newscores = [];
    do{
      newscores = OneCycle(players, matches, N, beta/100);
      if (comparePlayerScores(players, newscores)){
        updatePlayerPoints(leagueId, players, isTeamLeague);
        return;
      }
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

  List<double> OneCycle(Map<int, Map<String, dynamic>> players, Map<int,
      Map<String, dynamic>> matches, int N, double beta){
    List<double> newscores = [];
    double alfa = 0.15;

    for (var entry in players.entries) {  //Végigmegy minden játékoson
      int key = entry.key; // Játékos ID
      double metchResult = 0;

      for (var entry in matches.entries) {    //Végigmegy a mecseken
        if (entry.value['winner_id'] == key) {

          Map<String, dynamic> value = entry.value;
          int sw = value["score_w"];
          int sl = value["score_l"]==0 ? 1 : value["score_l"];
          int loser = value["loser_id"];

          if (players.containsKey(loser)) {
            Map<String, dynamic> player = players[loser]!;
            double PR = player['points'];
            int L = player["loss_count"]==0 ? 1 : player["loss_count"];
            double scoreValue = 1 + (((sw / sl) - 1) * beta);

            metchResult += (PR*scoreValue)/L;
            //print('$PR * (1 + ($sw / $sl - 1) * $beta) / $L');
          }
        }
      }
      double newscore = (alfa/N)+((1-alfa)*metchResult);
      newscores.add(newscore);
    }
    print(newscores);
    print("\n");
    double totalScore = newscores.reduce((sum, score) => sum + score);
    if(totalScore != 0) {
      newscores = newscores.map((score) => score / totalScore).toList();
    }
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


  Future<void> updatePlayerPoints(String leagueId, Map<int, Map<String, dynamic>> players, bool isTeamLeague) async {
    // Lekérdezzük a player DAO-t, és a táblát frissítjük.
    for (var playerId in players.keys) {
      double points = players[playerId]?['points'] ?? 0.0;  // A frissítendő új pontszám

      // Az alábbi kódot használd a player tábla frissítésére
      if(isTeamLeague){
        await TeamDao().updateTeamPoints(leagueId, playerId, points);
      }else{
        await PlayerDao().updatePlayerPoints(leagueId, playerId, points);
      }

    }
  }


}