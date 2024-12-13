import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/players_container.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/widgets/visual/custom_simple_hadder.dart';
import 'package:ranker/core/widgets/navigation/custom_navbar.dart';
import 'package:ranker/view/edit_player_screen.dart';
import 'package:ranker/view/add_player.dart';
import 'package:ranker/core/local_db/db_helper.dart';

import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/view/edit_team_screen.dart';

class PlayerView extends StatefulWidget {
  final String leagueId;

  const PlayerView({super.key, required this.leagueId});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  List<Map<String, dynamic>> _entries = [];
  bool _isLoading = true;
  late Future<String?> _leagueNameFuture;

  @override
  void initState() {
    super.initState();
    _fetchEntries();
    _leagueNameFuture = LeagueDao().getLeagueNameById(widget.leagueId);
  }

  Future<void> _fetchEntries() async {
    final dbHelper = DBHelper();
    bool isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);

    if (isTeamLeague) {
      final teams = await TeamDao().readTeamsByLeague(widget.leagueId);
      setState(() {
        _entries = teams;
        _isLoading = false;
      });
    } else {
      final players = await PlayerDao().readPlayersByLeague(widget.leagueId);
      setState(() {
        _entries = players;
        _isLoading = false;
      });
    }
  }


  void _onEdit(int id) async{
    bool isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);
    if(isTeamLeague){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditTeamScreen(teamId: id, leagueId: widget.leagueId),
      ));
    }else{
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditPlayerScreen(playerId: id, leagueId: widget.leagueId),
      ));
    }

  }

  Future<bool> isTeamLeagueChecked() async {
    bool isTeam = await LeagueDao().isTeamLeague(widget.leagueId);
    print("League ${widget.leagueId} is team league: $isTeam");
    return isTeam;
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
                  FutureBuilder<bool>(
                    future: isTeamLeagueChecked(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final isTeamLeague = snapshot.data ?? false;
                      final listTitle = isTeamLeague ? "Team List" : "Player List";
              
                      return Text(
                        listTitle,
                        style: TextStyle(
                          fontSize: (screenHeight * 0.024 < 12) ? 12 : screenHeight * 0.024,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xb3ffffff),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight*0.01),
                  Custom3DCard(
                    height: (screenHeight < screenWidth) ? screenHeight * 0.5 : screenHeight * 0.65,
                    width: screenWidth * 0.85,
                    child: FutureBuilder<bool>(
                      future: isTeamLeagueChecked(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final isTeamLeague = snapshot.data ?? false;
                        final emptyMessage = isTeamLeague
                            ? "No teams found in league"
                            : "No players found in league";
              
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : _entries.isEmpty
                                  ? Center(
                                child: Text(
                                  emptyMessage,
                                  style: const TextStyle(color: Color(0xFF006699)),
                                ),
                              )
                                  : ListView.builder(
                                itemCount: _entries.length,
                                itemBuilder: (context, index) {
                                  final player = _entries[index];
                                  return Align(
                                    alignment: Alignment.center,
                                    child: PlayerListContainer(
                                      isTeam: isTeamLeague,
                                      player_id: player['id'],
                                      playerName: player['name'],
                                      rank: player['rank'],
                                      playerTheme: DBHelper()
                                          .convertStringToPlayerTheme(player['theme']),
                                      width: screenWidth,
                                      height: screenHeight,
                                      onEdit: () => _onEdit(player['id']),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight*0.01),
                            Align(
                              alignment: Alignment.center,
                              child: CustomButton(
                                title: 'Add',
                                height: screenHeight,
                                width: screenWidth,
                                buttonStyleType: ButtonStyleType.dark,
                                buttonSize: ButtonSize.small,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddPlayer(leagueId: widget.leagueId),
                                  ));
                                },
                              ),
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
