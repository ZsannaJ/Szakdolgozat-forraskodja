import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/match_container.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/widgets/visual/custom_simple_hadder.dart';
import 'package:ranker/core/widgets/navigation/custom_navbar.dart';
import 'package:ranker/view/edit_match_screen.dart';
import 'package:ranker/view/add_match.dart';
import 'package:ranker/core/local_db/db_helper.dart';

import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/dao/match_individual_dao.dart';
import 'package:ranker/core/dao/match_team_dao.dart';
import 'package:ranker/core/dao/league_dao.dart';

class MatchView extends StatefulWidget {
  final String leagueId;

  const MatchView({super.key, required this.leagueId});

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  late Future<List<Map<String, dynamic>>> _matchesFuture;
  late Future<String?> _leagueNameFuture;
  late bool isTeamLeague;

  @override
  void initState() {
    super.initState();

    _matchesFuture = Future.delayed(Duration.zero, () async {
      isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);
      return isTeamLeague
          ? MatchTeamDao().readMatchesTeamByLeague(widget.leagueId)
          : MatchIndividualDao().readMatchesIndividualByLeague(widget.leagueId);
    });

    _leagueNameFuture = LeagueDao().getLeagueNameById(widget.leagueId);
    _matchesFuture;
  }

  void _onEditMatch(int matchId) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            EditMatchScreen(matchId: matchId, leagueId: widget.leagueId),
      ),
    );
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CustomSimpleHeader(
                          title: "Loading...",
                          width: screenWidth,
                        );
                      }

                      final leagueName = snapshot.data ?? "Unknown League";
                      return CustomSimpleHeader(
                        title: leagueName,
                        width: screenWidth,
                        height: screenHeight,
                      );
                    },
                  ),
                  Text(
                    "Match List",
                    style: TextStyle(
                      fontSize: (screenHeight * 0.024 < 12) ? 12 : screenHeight * 0.024,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xb3ffffff),
                    ),
                  ),
                  SizedBox(height: screenHeight*0.01),
                  Custom3DCard(
                    height: (screenHeight < screenWidth) ? screenHeight * 0.5 : screenHeight * 0.65,
                    width: screenWidth * 0.85,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _matchesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Column(
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    "No matches found",
                                    style: TextStyle(color: Color(0xFF006699)),
                                  ),
                                ),
                              ),
                              CustomButton(
                                title: 'Add',
                                height: screenHeight,
                                width: screenWidth,
                                buttonStyleType: ButtonStyleType.dark,
                                buttonSize: ButtonSize.small,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddMatch(leagueId: widget.leagueId),
                                  ));
                                },
                              ),
                              SizedBox(height: screenHeight*0.01),
                            ],
                          );
                        }
              

                        final matches = snapshot.data!;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: matches.length,
                                itemBuilder: (context, index) {
                                  final match = matches[index];
                                  String tabla = isTeamLeague ? "team" : "player";
              
                                  final player1Id = match['${tabla}1_id'] ?? 0;
                                  final player2Id = match['${tabla}2_id'] ?? 0;
                                  final playerTheme1 = match['${tabla}1_theme'] ?? 'blue';
                                  final playerTheme2 = match['${tabla}2_theme'] ?? 'blue';
                                  final score1 = match['${tabla}1_score'] ?? 0;
                                  final score2 = match['${tabla}2_score'] ?? 0;
              
              

                                  return FutureBuilder<List<String?>>(
                                    future: Future.wait([
                                      PlayerDao().getPlayerNameById(player1Id),
                                      PlayerDao().getPlayerNameById(player2Id),
                                      TeamDao().getTeamNameById(player1Id),
                                      TeamDao().getTeamNameById(player2Id),
                                    ]),
                                    builder: (context, playerSnapshot) {
                                      if (playerSnapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
              
                                      final playerName1 = playerSnapshot.data?[0] ?? "Unknown";
                                      final playerName2 = playerSnapshot.data?[1] ?? "Unknown";
              
                                      final teamName1 = playerSnapshot.data?[2] ?? "Unknown";
                                      final teamName2 = playerSnapshot.data?[3] ?? "Unknown";
              

                                      print('Player 1 ID: $player1Id, Name: $playerName1');
                                      print('Player 2 ID: $player2Id, Name: $playerName2');
              
                                      return MatchContainer(
                                        playerId1: player1Id,
                                        playerId2: player2Id,
                                        playerName1: isTeamLeague ? teamName1 : playerName1,
                                        playerName2: isTeamLeague ? teamName2 : playerName2,
                                        playerTheme1: DBHelper().convertStringToPlayerTheme(playerTheme1),
                                        playerTheme2: DBHelper().convertStringToPlayerTheme(playerTheme2),
                                        score1: score1,
                                        score2: score2,
                                        width: screenWidth,
                                        height: screenHeight,
                                        isTeam: isTeamLeague,
                                        onEdit: () => _onEditMatch(match['id']),
                                      );
                                    },
                                  );
              
                                },
                              ),
                            ),
                            CustomButton(
                              title: 'Add',
                              height: screenHeight,
                              width: screenWidth,
                              buttonStyleType: ButtonStyleType.dark,
                              buttonSize: ButtonSize.small,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddMatch(leagueId: widget.leagueId),
                                ));
                              },
                            ),
                            SizedBox(height: screenHeight*0.01),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: (screenHeight * 0.07< 20) ? 20 : screenHeight * 0.07),

                ],
              ),
            ),
          ),
          CustomNavBar(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            leagueId: widget.leagueId,
          ),
        ],
      ),
    );
  }
}
