import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/match_individual_dao.dart';
import 'package:ranker/core/dao/match_team_dao.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/service/pagerank.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/view/match_view_screen.dart';
import 'package:ranker/core/widgets/inputs/custom_textfield.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/widgets/visual/delete_pop_up.dart'; // Importáljuk a DeletePopup-ot

class EditMatchScreen extends StatefulWidget {
  final int matchId;
  final String leagueId;
  const EditMatchScreen({super.key, required this.matchId, required this.leagueId});

  @override
  State<EditMatchScreen> createState() => _EditMatchScreenState();
}

class _EditMatchScreenState extends State<EditMatchScreen> {
  String player1name = '';
  String player2name = '';
  int winner = -1;
  int player1 = -1;
  int player2 = -1;
  int player1scrore = 0;
  int player2scrore = 0;
  bool _isDeletePopupVisible = false;
  bool isLoading = true;

  late int _matchId;

  @override
  void initState() {
    super.initState();
    _matchId = widget.matchId;
    _loadMatchData(widget.leagueId);
  }

  Future<void> _loadMatchData(String leagueId) async {
    bool isTeamLeague = await LeagueDao().isTeamLeague(leagueId);
    Map<String, dynamic>? matchData;

    if (isTeamLeague) {
      matchData = await MatchTeamDao().readMatchTeamById(_matchId);
      if (matchData != null) {
        player1 = matchData['team1_id'] ?? -1;
        player1scrore = matchData['team1_score'] ?? 0;
        player2 = matchData['team2_id'] ?? -1;
        player2scrore = matchData['team2_score'] ?? 0;

        // Csapatok neveit betöltjük aszinkron
        player1name = await TeamDao().getTeamNameById(player1);
        player2name = await TeamDao().getTeamNameById(player2);

        setState(() {
          isLoading = false;
        });
      }
    } else {
      matchData = await MatchIndividualDao().readMatchIndividualById(_matchId);
      if (matchData != null) {
        player1 = matchData['player1_id'] ?? -1;
        player1scrore = matchData['player1_score'] ?? 0;
        player2 = matchData['player2_id'] ?? -1;
        player2scrore = matchData['player2_score'] ?? 0;

        // Egyéni játékosok neveit betöltjük
        player1name = await PlayerDao().getPlayerNameById(player1);
        player2name = await PlayerDao().getPlayerNameById(player2);

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _saveMatch() async {
    try {
      winner = player1scrore > player2scrore ? player1 : player2;

      bool isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);
      if (isTeamLeague) {
        final updatedData = {
          'team1_score': player1scrore,
          'team2_score': player2scrore,
          'winner_id' : winner,
        };
        await MatchTeamDao().updateTeamMatch(_matchId, updatedData, widget.leagueId);
        await TeamDao().updateTeamStats(player1);
        await TeamDao().updateTeamStats(player2);
      } else {
        final updatedData = {
          'player1_score': player1scrore,
          'player2_score': player2scrore,
          'winner_id' : winner,
        };
        await MatchIndividualDao().updateIndividualMatch(_matchId, updatedData, widget.leagueId);
        await PlayerDao().updatePlayerStats( player1);
        await PlayerDao().updatePlayerStats( player2);
      }
      PageRank().PageRankAlgorithm(widget.leagueId);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MatchView(leagueId: widget.leagueId),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating match: $e')));
    }
  }

  Future<void> _deleteMatch() async {

    try {
      bool isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);
      if (isTeamLeague) {
        await MatchTeamDao().deleteTeamMatch(_matchId);
        await TeamDao().updateTeamStats(player1);
        await TeamDao().updateTeamStats(player2);
      } else {
        await MatchIndividualDao().deleteIndividualMatch(_matchId);
        await PlayerDao().updatePlayerStats( player1);
        await PlayerDao().updatePlayerStats( player2);
      }

      PageRank().PageRankAlgorithm(widget.leagueId);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MatchView(leagueId: widget.leagueId),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting match: $e')));
    }
  }

  void _closeDeletePopup() {
    setState(() {
      _isDeletePopupVisible = false;
    });
  }

  void _showDeletePopup() {
    setState(() {
      _isDeletePopupVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BackgroundWidget(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Custom3DCard(
                    height: screenHeight*0.75,
                    width: screenWidth*0.85,
                    child: Column(
                      children: [
                        CustomHeader(
                          title: 'Edit Match',
                          width: screenWidth,
                          height: screenHeight,
                          onClose: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MatchView(leagueId: widget.leagueId),
                                ));
                          },
                          isItBlue: true,
                        ),
                        SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$player1name Score",
                            style: TextStyle(
                              color: const Color(0xFF006699),
                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                            ),
                          ),
                        ),
                        CustomTextField(
                          width: screenWidth,
                          height: screenHeight,
                          isNumericInput: true,
                          initialText: player1scrore.toString(),
                          onChanged: (value) {
                            setState(() {
                              player1scrore = int.tryParse(value) ?? 0;
                            });
                          },
                        ),

                        SizedBox(height: (screenHeight * 0.04 < 30) ? 30 : screenHeight * 0.04),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$player2name Score",
                            style: TextStyle(
                              color: const Color(0xFF006699),
                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                            ),
                          ),
                        ),
                        CustomTextField(
                          width: screenWidth,
                          height: screenHeight,
                          isNumericInput: true,
                          initialText: player2scrore.toString(),
                          onChanged: (value) {
                            setState(() {
                              player2scrore = int.tryParse(value) ?? 0;
                            });
                          },

                        ),
                        SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              title: 'Save',
                              height: screenHeight,
                              width: screenWidth,
                              buttonStyleType: ButtonStyleType.dark,
                              buttonSize: ButtonSize.small,
                              onTap: _saveMatch,
                            ),
                            CustomButton(
                              title: 'Delete',
                              height: screenHeight,
                              width: screenWidth,
                              buttonStyleType: ButtonStyleType.red,
                              buttonSize: ButtonSize.small,
                              onTap: _showDeletePopup,
                            ),
                          ],
                        ),
                        SizedBox(height: (screenHeight * 0.07< 20) ? 20 : screenHeight * 0.07),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isDeletePopupVisible)
            DeletePopUp(
              width: screenWidth,
              height: screenHeight,
              onCancel: _closeDeletePopup,
              onDelete: _deleteMatch,
            )
        ],
      ),
    );
  }
}
