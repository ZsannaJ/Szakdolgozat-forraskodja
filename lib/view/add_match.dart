import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ranker/core/models/Match.dart';
import 'package:ranker/core/models/Team.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/view/match_view_screen.dart';
import 'package:ranker/core/widgets/inputs/custom_textfield.dart';
import 'package:ranker/core/widgets/inputs/custom_dropdown_field.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/dao/match_team_dao.dart';
import 'package:ranker/core/dao/match_individual_dao.dart';
import 'package:ranker/core/service/pagerank.dart';

class AddMatch extends StatefulWidget {
  final String leagueId;

  const AddMatch({super.key, required this.leagueId});

  @override
  State<AddMatch> createState() => _AddMatchState();
}

class _AddMatchState extends State<AddMatch> {
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

  @override
  void initState() {
    super.initState();
    _checkLeagueType();

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
    final dbHelper = DBHelper();
    isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);
    print(isTeamLeague);
    setState(() {});
    _participantsFuture = _loadParticipants();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BackgroundWidget(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Custom3DCard(
                    height: screenHeight * 0.75,
                    width: screenWidth * 0.85,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomHeader(
                            title: 'Add Match',
                            width: screenWidth,
                            height: screenHeight,
                            onClose: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => MatchView(leagueId: widget.leagueId),
                              ));
                            },
                            isItBlue: true,
                          ),
              
                          SizedBox(height: screenHeight*0.01),
                          // Hibaüzenetek megjelenítése
                          if (_errorMessages.isNotEmpty)
                            Container(
                              color: const Color(0xFFFFA2B9),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _errorMessages.map((message) => Text(
                                  message,
                                  style: const TextStyle(color: Color(0xFFE90038), fontFamily: "Wellfleet"),
                                )).toList(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Player 1/Team 1
                                    Text(
                                      isTeamLeague ? "Team 1" : "Player 1",
                                      style: TextStyle(
                                        color: const Color(0xFF006699),
                                        fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                      ),
                                    ),
                                    CustomDropdownField(
                                      width: screenWidth,
                                      height: screenHeight,
                                      items: _participantsMap.values.map((participant) => participant['name'] as String).toList(),
                                      onChanged: (name) {
                                        setState(() {
                                          // Az 'id' (String) típusú értéket konvertáljuk 'int?' típusra
                                          _player1 = int.tryParse(
                                              _participantsMap.entries.firstWhere((entry) => entry.value['name'] == name).key
                                          );
                                          _player1Theme = _participantsMap[_player1?.toString()]?['theme']; // Ellenőrizzük, hogy 'player1' nem null
                                        });
                                      },
                                    ),
              
              
                                    SizedBox(height: screenHeight*0.01),
                      
                                    // Player 1/Team 1 Score
                                    Text(
                                      isTeamLeague ? "Team 1 Score" : "Player 1 Score",
                                      style: TextStyle(
                                        color: const Color(0xFF006699),
                                        fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                      ),
                                    ),
                                    CustomTextField(
                                      isNumericInput: true,
                                      width: screenWidth,
                                      height: screenHeight,
                                      onChanged: (value) {
                                        _player1score = int.tryParse(value) ?? 1;
                                      },
                                    ),
                                    SizedBox(height: screenHeight*0.08),
                      
                                    // Player 2/Team 2
                                    Text(
                                      isTeamLeague ? "Team 2" : "Player 2",
                                      style: TextStyle(
                                        color: const Color(0xFF006699),
                                        fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                      ),
                                    ),
                                    CustomDropdownField(
                                      width: screenWidth,
                                      height: screenHeight,
                                      items: _participantsMap.values.map((participant) => participant['name'] as String).toList(),
                                      onChanged: (name) {
                                        setState(() {
                                          // Az 'id' (String) típusú értéket konvertáljuk 'int?' típusra
                                          _player2 = int.tryParse(
                                              _participantsMap.entries.firstWhere((entry) => entry.value['name'] == name).key
                                          );
                                          _player2Theme = _participantsMap[_player2?.toString()]?['theme']; // Ellenőrizzük, hogy 'player1' nem null
                                        });
                                      },
                                    ),
                                    SizedBox(height: screenHeight*0.01),
                      
                                    // Player 2/Team 2 Score
                                    Text(
                                      isTeamLeague ? "Team 2 Score" : "Player 2 Score",
                                      style: TextStyle(
                                        color: const Color(0xFF006699),
                                        fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                      ),
                                    ),
                                    CustomTextField(
                                      isNumericInput: true,
                                      width: screenWidth,
                                      height: screenHeight,
                                      onChanged: (value) {
                                        _player2score = int.tryParse(value) ?? 1;
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return const Text("No participants found");
                              }
                            },
                          ),
                          SizedBox(height: screenHeight*0.01),
                      
                          // Save Button
                          CustomButton(
                            title: 'Save',
                            buttonStyleType: ButtonStyleType.dark,
                            buttonSize: ButtonSize.small,
                            height: screenHeight,
                            width: screenWidth,
                            onTap: _saveEntity,
                          ),
              
                          SizedBox(height: screenHeight*0.03),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveEntity() async {
    _errorMessages.clear();
    String creationDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final dbHelper = DBHelper();


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

    _player1Theme ??= '';
    _player2Theme ??= '';

    if (isTeamLeague) {
      final newMatchId = await dbHelper.generateUniqueTeamMatchId();
      final newMatch = MatchTeam(
        id: newMatchId,
        team1_id: _player1!,
        team2_id: _player2!,
        team1_score: _player1score,
        team2_score: _player2score,
        team1_theme: _player1Theme!,
        team2_theme: _player2Theme!,
        date: DateTime.parse(creationDate),
        league_id: widget.leagueId,
      );

      await _saveMatchTeamToDatabase(newMatch);



    } else {
      final newMatchId = await dbHelper.generateUniqueIndividualMatchId();
      final newMatch = MatchIndividual(
        id: newMatchId,
        player1_id: _player1!,
        player2_id: _player2!,
        player1_score: _player1score,
        player2_score: _player2score,
        player1_theme: _player1Theme!,
        player2_theme: _player2Theme!,
        date: DateTime.parse(creationDate),
        league_id: widget.leagueId,
      );

      await _saveMatchIndividualToDatabase(newMatch);


    }


    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MatchView(leagueId: widget.leagueId),
    ));
  }

  Future<void> _saveMatchTeamToDatabase(MatchTeam team) async {
    final dbHelper = DBHelper();
    await MatchTeamDao().createMatchTeam(team.toMap());
    print('Team match added: $team');
    PageRank().PageRankAlgorithm(widget.leagueId);
  }

  Future<void> _saveMatchIndividualToDatabase(MatchIndividual player) async {
    final dbHelper = DBHelper();
    await MatchIndividualDao().createMatchIndividual(player.toMap());
    print('Individual match added: $player');

    if(isTeamLeague){
      await TeamDao().updateTeamStats(_player1!);
      await TeamDao().updateTeamStats(_player2!);
    }else{
      await PlayerDao().updatePlayerStats( _player1!);
      await PlayerDao().updatePlayerStats( _player2!);
    }

    PageRank().PageRankAlgorithm(widget.leagueId);
  }
}
