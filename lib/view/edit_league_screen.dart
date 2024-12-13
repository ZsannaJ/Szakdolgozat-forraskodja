import 'package:flutter/material.dart';
import 'package:ranker/core/dao/league_individual_dao.dart';
import 'package:ranker/core/dao/league_team_dao.dart';
import 'package:ranker/core/service/pagerank.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/visual/delete_pop_up.dart';
import 'package:ranker/view/my_leagues_screen.dart';
import 'package:ranker/view/rank_view_screen.dart';
import 'package:ranker/core/widgets/inputs/icon_picker.dart';
import 'package:ranker/core/widgets/inputs/custom_textfield.dart';
import 'package:ranker/core/widgets/inputs/custom_dropdown_field.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/widgets/inputs/custom_slider.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/dao/league_dao.dart';


class EditLeagueScreen extends StatefulWidget {
  final String leagueId;
  const EditLeagueScreen({super.key, required this.leagueId});

  @override
  State<EditLeagueScreen> createState() => _EditLeagueScreenState();
}

class _EditLeagueScreenState extends State<EditLeagueScreen> {
  String leagueName = '';
  String password = '';
  String selectedTheme = '';
  double betaValue = 0.0;
  String selectedIconPath = '';
  List<String> items = ['yellow', 'pink', 'blue', 'red', 'green'];
  int selectedIndex = 0;
  bool isLoading = true;
  bool _isDeletePopupVisible = false;

  late String _leagueId;

  @override
  void initState() {
    super.initState();
    _loadLeagueData(widget.leagueId);
    _leagueId = widget.leagueId;
  }


  Future<void> _loadLeagueData(String leagueId) async {
    bool isTeamLeague = await LeagueDao().isTeamLeague(leagueId);
    Map<String, dynamic>? leagueData;

    if (isTeamLeague) {
      leagueData = await LeagueTeamDao().readTeamLeagueById(leagueId);
    } else {
      leagueData = await LeagueIndividualDao().readIndividualLeagueById(leagueId);
    }

    print(leagueData);

    if (leagueData != null) {
      setState(() {
        leagueName = leagueData?['name'] ?? '';
        password = leagueData?['password'] ?? '';
        selectedTheme = leagueData?['theme'] ?? '';
        betaValue = leagueData?['beta'] ?? 0.0;
        selectedIconPath = leagueData?['icon'] ?? '';
        selectedIndex = items.indexOf(selectedTheme);

        isLoading = false;
      });
    }
  }


  Future<void> _saveLeague() async {
    final updatedData = {
      'name': leagueName,
      'password' : password,
      'theme': selectedTheme,
      'beta': betaValue,
      'icon': selectedIconPath,
    };

    try {
      bool isTeamLeague = await LeagueDao().isTeamLeague(widget.leagueId);
      if (isTeamLeague) {
        await LeagueTeamDao().updateTeamLeague(widget.leagueId, updatedData);

      } else {
        await LeagueIndividualDao().updateLeague(widget.leagueId, updatedData);
      }

      await PageRank().PageRankAlgorithm(widget.leagueId);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => RankView(leagueId: widget.leagueId),
      ));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating league: $e')));
    }
  }



  Future<void> _deleteLeague() async {
    try {
      bool isTeamLeague = await LeagueDao().isTeamLeague(_leagueId);
      if (isTeamLeague) {
        await LeagueTeamDao().deleteTeamLeague(_leagueId);
      } else {
        await LeagueIndividualDao().deleteLeague(_leagueId);
      }


      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MyLeaguesScreen(),
      ));
    } catch (e) {
      // Hiba esetén
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
                    height: screenHeight * 0.75,
                    width: screenWidth * 0.85,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomHeader(
                            title: 'Edit League',
                            width: screenWidth*0.8,
                            height: screenHeight,
                            onClose: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => RankView(leagueId: widget.leagueId),
                              ));
                            },
                            isItBlue: true,
                          ),
                          SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              _leagueId,
                              style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: (screenHeight*0.025 < 14) ? 14 : screenHeight*0.025,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Wellfleet',
                              ),
                            ),
                          ),
                          SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "League Name",
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
                            initialText: leagueName,
                            onChanged: (value) {
                              setState(() {
                                leagueName = value;
                              });
                            },
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "League Password",
                              style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                              ),
                            ),
                          ),
                          CustomTextField(
                            width: screenWidth,
                            height: screenHeight,
                            initialText: password,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
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
                          IconPicker(
                            initialIconPath: selectedIconPath,
                            height: screenHeight,
                            onIconSelected: (String iconPath) {
                              setState(() {
                                selectedIconPath = iconPath;
                              });
                            },
                          ),
                          SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
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
                          SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select Score Value",
                              style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "How match scores affect the rankings",
                              style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: (screenHeight*0.018 < 9) ? 9 : screenHeight*0.018,
                                fontFamily: "Wellfleet",
                              ),
                            ),
                          ),
                          CustomSlider(
                            width: screenWidth,
                            step: 5,
                            initialValue: betaValue,
                            onChanged: (value) {
                              setState(() {
                                betaValue = value;
                              });
                            },
                          ),
                          SizedBox(height: (screenHeight * 0.02 < 10) ? 10 : screenHeight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(
                                title: 'Save',
                                height: screenHeight,
                                width: screenWidth,
                                buttonStyleType: ButtonStyleType.dark,
                                buttonSize: ButtonSize.small,
                                onTap: _saveLeague,
                              ),
                              SizedBox(width: screenWidth*0.03),
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
                          SizedBox(height: (screenHeight * 0.04 < 20) ? 20 : screenHeight * 0.04),
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
              onDelete: _deleteLeague,
            )
        ],
      ),
    );
  }
}



