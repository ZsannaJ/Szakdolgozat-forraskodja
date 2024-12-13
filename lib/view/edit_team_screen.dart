import 'package:flutter/material.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/match_team_dao.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/service/pagerank.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/visual/delete_pop_up.dart';
import 'package:ranker/view/edit_icon_screen.dart';
import 'package:ranker/view/player_view_screen.dart';
import 'package:ranker/core/widgets/inputs/image_editor.dart';
import 'package:ranker/core/widgets/inputs/custom_textfield.dart';
import 'package:ranker/core/widgets/inputs/custom_dropdown_field.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/constants/enums.dart';

class EditTeamScreen extends StatefulWidget {
  final int teamId;
  final dynamic leagueId;

  const EditTeamScreen({super.key, required this.teamId, required this.leagueId});

  @override
  State<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  String teamName = '';
  String selectedTheme = '';
  List<String> items = ['yellow', 'pink', 'blue', 'red', 'green'];
  int selectedIndex = 0;
  bool isLoading = true;
  bool _isDeletePopupVisible = false;
  bool isTeamLeague = false;

  late int _teamId;

  @override
  void initState() {
    super.initState();
    _teamId = widget.teamId;
    _loadTeamData(widget.teamId);
    _checkLeagueType();
  }

  Future<void> _checkLeagueType() async {
    isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);

    setState(() {});
  }

  Future<void> _loadTeamData(int teamId) async {
    Map<String, dynamic>? teamData;
    teamData = await TeamDao().readTeamById(teamId);

    if (teamData != null) {
      setState(() {
        teamName = teamData?['name'] ?? '';
        selectedTheme = teamData?['theme'] ?? '';
        selectedIndex = items.indexOf(selectedTheme);

        isLoading = false;
      });
    }
  }

  Future<void> _savePlayer() async {
    final updatedData = {
      'name': teamName,
      'theme': selectedTheme,
    };
    try {
      await TeamDao().updateTeam(widget.teamId, updatedData);
      await MatchTeamDao().updateMatchThemesForTeam(widget.teamId, selectedTheme);

      await PageRank().PageRankAlgorithm(widget.leagueId);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PlayerView(leagueId: widget.leagueId),
      ));


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating league: $e')));
    }
  }

  Future<void> _deletePlayer() async {
    try {
      await TeamDao().deleteTeam(_teamId);
      await PageRank().PageRankAlgorithm(widget.leagueId);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PlayerView(leagueId: widget.leagueId),
      ));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting league: $e')));
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

  Color _getThemeColor(playerTheme) {
    switch (playerTheme) {
      case 'yellow':
        return const Color(0xFFFFED84);
      case 'pink':
        return const Color(0xFFFDC4FF);
      case 'blue':
        return const Color(0xFFA5ECFF);
      case 'red':
        return const Color(0xFFFFA2B9);
      case 'green':
        return const Color(0xFFB3F480);
      default:
        return const Color(0xFFA1D4EE);
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight= MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BackgroundWidget(
        child:Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                
                    SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                
                    Custom3DCard(
                      height: screenHeight*0.75,
                      width: screenWidth*0.85,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomHeader(
                              title: 'Edit Team',
                              width: screenWidth,
                              height: screenHeight,
                              onClose: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => PlayerView(leagueId: widget.leagueId,),
                                ));
                        
                              },
                              isItBlue: true,
                            ),
                        
                            SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                        
                            ImageEditor(
                                player_id: widget.teamId,
                                isTeam: isTeamLeague,
                                height: screenHeight,
                                playerTheme: _getThemeColor(selectedTheme),
                                onTap: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => EditIconScreen(teamId: widget.teamId, leagueId: widget.leagueId,),
                                  ));
                                }
                            ),
                        
                            SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                        
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Team Name",
                                style: TextStyle(
                                  color: const Color(0xFF006699),
                                  fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                ),
                              ),
                            ),
                        
                            CustomTextField(
                              width: screenWidth,
                              height: screenHeight,
                              max: 12,
                              initialText: teamName,
                              onChanged: (value) {
                                setState(() {
                                  teamName = value;
                                });
                              },
                            ),
                        
                            SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                        
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Select Theme",
                                style: TextStyle(
                                  color: const Color(0xFF006699),
                                  fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                ),
                              ),
                            ),
                        
                            CustomDropdownField(
                              width: screenWidth,
                              height: screenHeight,
                              selectedIndex: selectedIndex,
                              items: items,
                              onChanged: (value) {
                                setState(() {
                                  selectedTheme = value!;
                                  selectedIndex = items.indexOf(value);
                                });
                              },
                            ),
                        
                            SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                        
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  title: 'save',
                                  height: screenHeight,
                                  width: screenWidth,
                                  buttonStyleType: ButtonStyleType.dark,
                                  buttonSize: ButtonSize.small,
                                  onTap: _savePlayer,
                                ),
                                SizedBox(width: screenWidth*0.03),
                                CustomButton(
                                  title: 'delete',
                                  height: screenHeight,
                                  width: screenWidth,
                                  buttonStyleType: ButtonStyleType.red,
                                  buttonSize: ButtonSize.small,
                                  onTap: _showDeletePopup,
                                )
                              ],
                            ),
                            SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                          ],
                        ),
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
                onDelete: _deletePlayer,
              )

          ],
        )
    );
  }
}


