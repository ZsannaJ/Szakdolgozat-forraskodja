import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/dao/team_dao.dart';
import 'package:ranker/core/widgets/avatar/teamicon_container.dart';
import 'package:ranker/core/widgets/inputs/custom_slider.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/view/edit_team_screen.dart';


class EditIconScreen extends StatefulWidget {
  final int teamId;
  final String leagueId;
  const EditIconScreen({super.key, required this.teamId, required this.leagueId});

  @override
  State<EditIconScreen> createState() => _EditIconScreenState();
}

class _EditIconScreenState extends State<EditIconScreen> {
  int selectedIcon = 0;
  int selectedIconColor = 0;
  String playerTheme = 'def';
  bool isLoading = true;

  late int _teamId;

  @override
  void initState() {
    super.initState();
    _teamId = widget.teamId;
    _loadTeamData(widget.teamId);
  }

  Future<void> _loadTeamData(int teamId) async {
    Map<String, dynamic>? teamData;
    teamData = await TeamDao().readTeamById(teamId);

    if (teamData != null) {
      setState(() {
        selectedIcon = teamData?['icon'] ?? 0;
        selectedIconColor = teamData?['icon_color'] ?? 0;
        playerTheme = teamData?['theme'] ?? 'def';

        isLoading = false;
      });
    }
  }

  Future<void> _saveIcon() async {
    final updatedData = {
      'icon': selectedIcon,
      'icon_color': selectedIconColor,
    };
    try {
      await TeamDao().updateTeam(widget.teamId, updatedData);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => EditTeamScreen(teamId: widget.teamId, leagueId: widget.leagueId,),
      ));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating league: $e')));
    }
  }

  Color _getThemeColor() {
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
      return const Center(child: CircularProgressIndicator()); // Várakozási animáció
    }

    return BackgroundWidget(
        child:Stack(
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
                            SizedBox(height: screenHeight * 0.02),
                            CustomHeader(
                              title: 'Icon Editor',
                              width: screenWidth*0.8,
                              height: screenHeight,
                              onClose: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => EditTeamScreen(teamId: widget.teamId, leagueId: widget.leagueId,),
                                ));
                              },
                              isItBlue: true,
                            ),
                
                            SizedBox(height: screenHeight * 0.02),
                
                            Container(
                              height: (screenHeight * 0.2 < 100) ? 100 : screenHeight * 0.2,
                              width: (screenHeight * 0.2 < 100) ? 100 : screenHeight * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _getThemeColor(),
                              ),
                              child: TeamiconValueContainer(
                                  size: screenWidth * 0.4,
                                  icon: selectedIcon,
                                  icon_color: selectedIconColor
                              ),
                            ),
                
                            SizedBox(height: screenHeight * 0.02),
                
                        SizedBox(
                          height: screenHeight*0.4,
                          child:SingleChildScrollView(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Select Icon",
                                      style: TextStyle(
                                        color: const Color(0xFF006699),
                                        fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                      ),
                                    ),
                                  ),
                
                                  SizedBox(height: screenHeight * 0.005),
                                  CustomSlider(
                                    width: screenWidth * 0.7,
                                    minValue: 0,
                                    maxValue: 6,
                                    step: 1,
                                    initialValue: selectedIcon.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedIcon = value.toInt();
                
                                      });
                                    },
                                  ),
                
                                  SizedBox(height: screenHeight * 0.01),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Select Icon Color",
                                      style: TextStyle(
                                        color: const Color(0xFF006699),
                                        fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  CustomSlider(
                                    width: screenWidth * 0.7,
                                    minValue: 0,
                                    maxValue: 8,
                                    step: 1,
                                    initialValue: selectedIconColor.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedIconColor = value.toInt();
                                      });
                                    },
                                  ),
                
                                  SizedBox(height: screenHeight * 0.02),
                
                                  CustomButton(title: 'save',
                                      height: screenHeight,
                                      width: screenWidth,
                                      buttonStyleType: ButtonStyleType.dark,
                                      buttonSize: ButtonSize.small,
                                      onTap:  _saveIcon,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
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
              ),
            )],
        )
    );
  }


}


