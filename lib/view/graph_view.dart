import 'package:flutter/material.dart';
import 'package:ranker/core/dao/match_individual_dao.dart';
import 'package:ranker/core/dao/match_team_dao.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_simple_hadder.dart';
import 'package:ranker/core/widgets/navigation/custom_navbar.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/widgets/graph/graph.dart';

class GraphView extends StatefulWidget {
  final String leagueId;

  const GraphView({super.key, required this.leagueId});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  late Future<String?> _leagueNameFuture;
  late Future<List<Map<String, dynamic>>> _teamOrPlayerFuture;
  late Future<bool> _isTeamLeagueFuture;

  @override
  void initState() {
    super.initState();
    _leagueNameFuture = LeagueDao().getLeagueNameById(widget.leagueId);
    _isTeamLeagueFuture = LeagueDao().isTeamLeague(widget.leagueId);
  }

  Future<List<Map<String, dynamic>>> _getTeamOrPlayers() async {
    bool isTeamLeague = await _isTeamLeagueFuture;
    if (isTeamLeague) {
      return await TeamDao().readTeamsByLeague(widget.leagueId);
    } else {
      return await PlayerDao().readPlayersByLeague(widget.leagueId);
    }
  }

  Future<List<List<String>>> _getEdges() async {
    bool isTeamLeague = await _isTeamLeagueFuture;
    if (isTeamLeague) {
      List<Map<String, String>> matchResults = await MatchTeamDao().getMatchResultsByLeagueId(widget.leagueId);
      return matchResults.map((result) {
        return [result['winner']!, result['loser']!];
      }).toList();
    } else {
      List<Map<String, String>> matchResults = await MatchIndividualDao().getMatchResultsByLeagueId(widget.leagueId);
      return matchResults.map((result) {
        return [result['winner']!, result['loser']!];
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BackgroundWidget(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FutureBuilder<String?>(
                    future: _leagueNameFuture,
                    builder: (context, snapshot) {
                      return CustomSimpleHeader(
                        title: snapshot.data ?? "Loading...",
                        width: screenWidth,
                        height: screenHeight,
                      );
                    },
                  ),
                  Text(
                    "Graph View",
                    style: TextStyle(
                        fontSize: (screenHeight * 0.024 < 12) ? 12 : screenHeight * 0.024,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xb3ffffff)),
                  ),
              
                  const SizedBox(height: 10),

                  // Gráf widget, ahol a node és edge adatok dinamikusan töltődnek
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getTeamOrPlayers(), // Lekérjük a csapatokat vagy játékosokat
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();  // Betöltési indikátor
                      }
              
                      if (snapshot.hasError) {
                        return Text('Hiba történt: ${snapshot.error}');  // Hibaüzenet
                      }
              
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Nincsenek adatok!');  // Ha nincsenek adatok
                      }

                      // Az adatok sikeresen lekérve, feltöltjük a gráf node listáját
                      List<Map<String, String>> nodes = [];
                      for (var item in snapshot.data!) {
                        nodes.add({
                          "id": item['name'], // A játékos vagy csapat neve
                          "theme": item['theme'], // A téma (pl. szín)
                        });
                      }

                      // Edge-eket a _getEdges metódus segítségével töltjük fel
                      return FutureBuilder<List<List<String>>>(
                        future: _getEdges(),
                        builder: (context, edgeSnapshot) {
                          if (edgeSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Betöltési indikátor az élekhez
                          }
              
                          if (edgeSnapshot.hasError) {
                            return Text('Hiba történt: ${edgeSnapshot.error}');
                          }
              

                          // Visszaadjuk a gráfot a nodes és edges adatokat használva
                          List<List<String>> edges = edgeSnapshot.data!;
                          return SizedBox(
                            height: (screenHeight < screenWidth) ? screenHeight * 0.5 : screenHeight * 0.65,
                            width: screenWidth * 0.95,
                            child: GraphWidget(
                              nodes: nodes,  // A node lista, amit most töltünk fel
                              edges: edges,  // Az edge lista, amit most töltünk fel
                            ),
                          );
                        },
                      );
                    },
                  ),
              
                  const SizedBox(height: 10),
              
                  ],
              ),
            ),
          ),
          CustomNavBar(screenWidth: screenWidth, screenHeight: screenHeight, leagueId: widget.leagueId)

        ],
      ),
    );
  }
}
