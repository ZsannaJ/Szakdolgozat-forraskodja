import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ranker/core/widgets/navigation/custom_navbar.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/visual/custom_simple_hadder.dart';
import 'package:ranker/core/widgets/visual/rank_conatainer.dart';
import 'package:ranker/core/widgets/inputs/custom_textfield.dart';
import 'package:ranker/core/widgets/inputs/custom_dropdown_field.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/service/tryout.dart';

class TryoutScreen extends StatefulWidget {
  final String leagueId;

  const TryoutScreen({super.key, required this.leagueId});

  @override
  State<TryoutScreen> createState() => _TryoutScreenState();
}

class _TryoutScreenState extends State<TryoutScreen> {
  final List<String> _errorMessages = [];
  bool isTeamLeague = false;
  int? _player1;
  int? _player2;
  String? _player1Theme;
  String? _player2Theme;
  int _player1score = 1;
  int _player2score = 1;
  Future<List<Map<String, dynamic>>>? _participantsFuture;
  Map<String, Map<String, String>> _participantsMap = {};
  late Future<String?> _leagueNameFuture;

  late Future<Map<int, Map<String, dynamic>>> updatedPlayers = Future.value({});

  @override
  void initState() {
    super.initState();
    _checkLeagueType();
    _leagueNameFuture = LeagueDao().getLeagueNameById(widget.leagueId);
  }

  Future<List<Map<String, dynamic>>> _loadParticipants() async {
    if (isTeamLeague) {
      return TeamDao().readTeamsByLeague(widget.leagueId);
    } else {
      return PlayerDao().readPlayersByLeague(widget.leagueId);
    }
  }

  void _populateParticipantsMap(List<Map<String, dynamic>> participants) {
    _participantsMap = {
      for (var participant in participants)
        participant['id'].toString(): {
          'name': participant['name'] as String,
          'theme': participant['theme'] as String,
        }
    };
  }

  Future<void> _checkLeagueType() async {
    isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);
    setState(() {});
    _participantsFuture = _loadParticipants();
  }

  Future<void> _saveEntity() async {
    try {
      _errorMessages.clear();

      if (_player1 == null || _player2 == null) {
        isTeamLeague
            ? _errorMessages.add("Both teams must be selected.")
            : _errorMessages.add("Both players must be selected.");
        setState(() {});
        return;
      }

      if (_player1 == _player2) {
        isTeamLeague
            ? _errorMessages.add("A team can't play against themselves.")
            : _errorMessages.add("A player can't play against themselves.");
        setState(() {});
        return;
      }

      if (_player1score == _player2score) {
        _errorMessages.add("The match must be decided!");
        setState(() {});
        return;
      }

      int winnerId = _player1score > _player2score ? _player1! : _player2!;
      int loserId = _player1score < _player2score ? _player1! : _player2!;
      int scoreW = _player1score > _player2score ? _player1score : _player2score;
      int scoreL = _player1score < _player2score ? _player1score : _player2score;

      Map<String, dynamic> matchResults = {};

      matchResults['score_w'] = scoreW;
      matchResults['score_l'] = scoreL;
      matchResults['loser_id'] = loserId;
      matchResults['winner_id'] = winnerId;

      print("Updated Match Results: $matchResults");

      updatedPlayers = PageRankTry().PageRankTesterAlgorithm(widget.leagueId, matchResults);

      setState(() {});

    } catch (e) {
      print("Error in _saveEntity: $e");
      _errorMessages.add("An error occurred during simulation.");
      setState(() {});
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
                      "Simulation",
                      style: TextStyle(
                          fontSize: (screenHeight * 0.024 < 12) ? 12 : screenHeight * 0.024,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xb3ffffff
                          )),
                    ),
                    SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                    Custom3DCard(
                      height: (screenHeight < screenWidth) ? screenHeight * 0.5 : screenHeight * 0.65,
                      width: screenWidth * 0.85,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                            if (_errorMessages.isNotEmpty)
                              Container(
                                color: const Color(0xFFFFA2B9),
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _errorMessages.map((message) => Text(message, style: const TextStyle(color: Color(0xFFE90038), fontFamily: "Wellfleet"))).toList(),
                                ),
                              ),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _participantsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  _populateParticipantsMap(snapshot.data!);
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  isTeamLeague ? "Team 1" : "Player 1",
                                                  style: TextStyle(
                                                      color: const Color(0xFF006699),
                                                      fontSize: (screenHeight * 0.02 < 12) ? 12 : (screenHeight * 0.02 > screenWidth * 0.03 ? screenWidth * 0.03 : screenHeight * 0.02)
                                                  )),

                                              CustomDropdownField(
                                                width: screenWidth * 0.42,
                                                height: screenHeight,
                                                items: _participantsMap.values.map((participant) => participant['name'] as String).toList(),
                                                onChanged: (name) {
                                                  setState(() {
                                                    _player1 = int.tryParse(_participantsMap.entries.firstWhere((entry) => entry.value['name'] == name).key);
                                                    _player1Theme = _participantsMap[_player1?.toString()]?['theme'];
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  isTeamLeague ? "Team 2" : "Player 2",
                                                  style: TextStyle(
                                                      color: const Color(0xFF006699),
                                                      fontSize: (screenHeight * 0.02 < 12) ? 12 : (screenHeight * 0.02 > screenWidth * 0.03 ? screenWidth * 0.03 : screenHeight * 0.02)
                                                  )),

                                              CustomDropdownField(
                                                width: screenWidth * 0.42,
                                                height: screenHeight,
                                                items: _participantsMap.values.map((participant) => participant['name'] as String).toList(),
                                                onChanged: (name) {
                                                  setState(() {
                                                    _player2 = int.tryParse(_participantsMap.entries.firstWhere((entry) => entry.value['name'] == name).key);
                                                    _player2Theme = _participantsMap[_player2?.toString()]?['theme'];
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  isTeamLeague ? "Team 1 Score" : "Player 1 Score",
                                                  style: TextStyle(
                                                      color: const Color(0xFF006699),
                                                      fontSize: (screenHeight * 0.02 < 12) ? 12 : (screenHeight * 0.02 > screenWidth * 0.03 ? screenWidth * 0.03 : screenHeight * 0.02),
                                                  )),
                                              CustomTextField(
                                                isNumericInput: true,
                                                height: screenHeight,
                                                width: screenWidth * 0.43,
                                                onChanged: (value) {
                                                  _player1score = int.tryParse(value) ?? 1;
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  isTeamLeague ? "Team 2 Score" : "Player 2 Score",
                                                  style: TextStyle(
                                                      color: const Color(0xFF006699),
                                                      fontSize: (screenHeight * 0.02 < 12) ? 12 : (screenHeight * 0.02 > screenWidth * 0.03 ? screenWidth * 0.03 : screenHeight * 0.02),
                                                  )),
                                              CustomTextField(
                                                isNumericInput: true,
                                                height: screenHeight,
                                                width: screenWidth * 0.43,
                                                onChanged: (value) {
                                                  _player2score = int.tryParse(value) ?? 1;
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                                      CustomButton(
                                        title: "Sim",
                                        height: screenHeight,
                                        width: screenWidth,
                                        buttonSize: ButtonSize.small,
                                        buttonStyleType: ButtonStyleType.dark,
                                        onTap: _saveEntity,
                                      ),

                                      FutureBuilder<Map<int, Map<String, dynamic>>>(
                                        future: updatedPlayers,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            var playerList = snapshot.data!.values.toList(); // Convert the Map to a List


                                            return SizedBox(
                                              width: screenWidth * 0.7,
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,  // Fontos: ezt kell használni, hogy a ListView ne próbálja kitölteni az egész rendelkezésre álló helyet
                                                    itemCount: playerList.length,
                                                    itemBuilder: (context, index) {
                                                      final player = playerList[index];
                                                      return RankContainer(
                                                        ranking: player['rank'],
                                                        playerName: player['name'],
                                                        score: player['points'] ?? 0,
                                                        playerTheme: PlayerTheme.def,
                                                        width: screenWidth,
                                                        height: screenHeight,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return const Text("No players found.");
                                          }
                                        },
                                      )


                                    ],
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: (screenHeight * 0.07< 20) ? 20 : screenHeight * 0.07),



                  ],
                ),
              ),

            ),
            CustomNavBar(
                screenWidth: screenWidth,
                screenHeight: MediaQuery.of(context).size.height,
                leagueId: widget.leagueId
            )
          ],
        ),
    );
  }
}