import 'package:flutter/material.dart';
import 'package:ranker/core/service/pagerank.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/view/player_view_screen.dart';
import 'package:ranker/core/widgets/inputs/custom_textfield.dart';
import 'package:ranker/core/widgets/inputs/custom_dropdown_field.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/models/Player.dart';
import 'package:ranker/core/models/Team.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/dao/player_dao.dart';

class AddPlayer extends StatefulWidget {
  final String leagueId;

  const AddPlayer({super.key, required this.leagueId}); // -1 ha nem csapat

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  String _playerName = '';
  String _selectedTheme = 'blue';
  final List<String> _errorMessages = [];
  bool isTeamLeague = false;

  @override
  void initState() {
    super.initState();
    _checkLeagueType();
  }

  Future<void> _checkLeagueType() async {
    isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);

    setState(() {});
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
                    height: screenHeight*0.75,
                    width: screenWidth*0.85,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                          CustomHeader(
                            title: isTeamLeague ? 'Add Team' : 'Add Player',
                            width: screenWidth,
                            height: screenHeight,
                            onClose: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => PlayerView(leagueId: widget.leagueId),
                              ));
                            },
                            isItBlue: true,
                          ),
                          SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
              
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
              
                          SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(isTeamLeague ? "Team Name" : "Player Name",
                                style: TextStyle(color: const Color(0xFF006699), fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02)),
                          ),
                          CustomTextField(
                            width: screenWidth,
                            height: screenHeight,
                            max: 12,
                            onChanged: (value) {
                              setState(() {
                                _playerName = value;
                              });
                            },
                          ),
                          SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Select Theme", style: TextStyle(color: const Color(0xFF006699), fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02)),
                          ),
                          CustomDropdownField(
                            width: screenWidth,
                            height: screenHeight,
                            items: const ['yellow', 'pink', 'blue', 'red', 'green'],
                            onChanged: (value) {
                              setState(() {
                                _selectedTheme = value ?? 'blue';
                              });
                            },
                          ),
                          SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                          CustomButton(
                            title: 'SAVE',
                            height: screenHeight,
                            width: screenWidth,
                            buttonStyleType: ButtonStyleType.dark,
                            buttonSize: ButtonSize.small,
                            onTap: _saveEntity,
                          ),
                          SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
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


    if (_playerName.isEmpty || _playerName.length > 12) {
      _errorMessages.add('Name must be between 1 and 12 characters.');
    }

    if (_errorMessages.isNotEmpty) {
      setState(() {});
      return;
    }

    if (isTeamLeague) {
      final newTeam = Team(

        id: await DBHelper().generateUniqueTeamId(),
        name: _playerName,
        theme: _selectedTheme,
        league_id: widget.leagueId,
        rank: 1,
        points: 0,
        win_count: 0,
        loss_count: 0,
        icon: 0,
        icon_color: 0,
      );

      await _saveTeamToDatabase(newTeam);
    } else {

      final newPlayer = Player(
        id: await DBHelper().generateUniquePlayerId(),
        name: _playerName,
        theme: _selectedTheme,
        league_id: widget.leagueId,
        points: 0,
        rank: 1,
        win_count: 0,
        loss_count: 0,
        skin_color: 0,
        hair: 0,
        hair_color: 0,
        top: 1,
        top_color: 3,
        beard: 0,
        beard_color: 0,
        glasses: 0,
        glasses_color: 0,
      );

      await _savePlayerToDatabase(newPlayer);
    }


      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PlayerView(leagueId: widget.leagueId),
      ));



  }

  Future<void> _saveTeamToDatabase(Team team) async {
    await TeamDao().createTeam(team.toMap());
    PageRank().PageRankAlgorithm(widget.leagueId);
  }

  Future<void> _savePlayerToDatabase(Player player) async {
    await PlayerDao().createPlayer(player.toMap());
    PageRank().PageRankAlgorithm(widget.leagueId);
  }
}


