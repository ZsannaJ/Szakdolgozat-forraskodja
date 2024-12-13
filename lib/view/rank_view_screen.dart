import 'package:flutter/material.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/rank_conatainer.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/visual/custom_simple_hadder.dart';
import 'package:ranker/core/widgets/navigation/custom_navbar.dart';
import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/dao/player_dao.dart';

class RankView extends StatefulWidget {
  final String leagueId;

  const RankView({super.key, required this.leagueId});

  @override
  State<RankView> createState() => _RankViewState();
}

class _RankViewState extends State<RankView> {
  List<Map<String, dynamic>> rankings = [];
  late Future<String?> _leagueNameFuture;

  @override
  void initState() {
    super.initState();
    _loadRankings();
    _leagueNameFuture = LeagueDao().getLeagueNameById(widget.leagueId);
  }

  Future<void> _loadRankings() async {
    final dbHelper = DBHelper();
    bool isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);

    if (isTeamLeague) {
      final teams = await TeamDao().readTeamsByLeagueRank(widget.leagueId);
      setState(() {
        rankings = teams;
      });
    } else {
      final players = await PlayerDao().readPlayersByLeagueRank(widget.leagueId);
      setState(() {
        rankings = players;
      });
    }

    rankings.sort((a, b) => a['rank'].compareTo(b['rank']));
    print("\nRankings: $rankings");
    setState(() {}); // Frissítjük a UI-t
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BackgroundWidget(
      child: SafeArea(
        child: Stack(
          children: [
            // Scrollozható tartalom
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(height: (screenHeight * 0.01 < 10) ? 10 : screenHeight * 0.01),

                  Center(
                    child: Text(
                      "Ranking List",
                      style: TextStyle(
                        fontSize: (screenHeight * 0.024 < 12) ? 12 : screenHeight * 0.024,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xb3ffffff),
                      ),
                    ),
                  ),

                  SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),

                  Center(
                    child: Custom3DCard(
                      height: (screenHeight < screenWidth) ? screenHeight * 0.5 : screenHeight * 0.65,
                      width: screenWidth * 0.85,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            rankings.isEmpty
                                ? Center(
                              child: FutureBuilder<bool>(
                                future: LeagueDao().isTeamLeague(widget.leagueId),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final isTeamLeague = snapshot.data ?? false;
                                  return Text(
                                    isTeamLeague
                                        ? "No teams found in league"
                                        : "No players found in league",
                                    style: const TextStyle(color: Color(0xFF006699)),
                                  );
                                },
                              ),
                            )
                                : ListView.builder(
                              itemCount: rankings.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = rankings[index];
                                return RankContainer(
                                  ranking: item['rank'],
                                  playerName: item['name'],
                                  score: item['points'] ?? 0,
                                  playerTheme: DBHelper().convertStringToPlayerTheme(item['theme']),
                                  width: screenWidth,
                                  height: screenHeight,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: (screenHeight * 0.07< 20) ? 20 : screenHeight * 0.07),
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomNavBar(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                leagueId: widget.leagueId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
