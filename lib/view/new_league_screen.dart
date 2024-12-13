import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/widgets/inputs/custom_textfield.dart';
import 'package:ranker/core/widgets/inputs/icon_picker.dart';
import 'package:ranker/view/home_screen.dart';
import 'package:ranker/core/widgets/inputs/custom_dropdown_field.dart';
import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/view/my_leagues_screen.dart';
import 'package:ranker/core/dao/league_team_dao.dart';
import 'package:ranker/core/dao/league_individual_dao.dart';

class NewLeagueScreen extends StatefulWidget {
  const NewLeagueScreen({super.key});

  @override
  State<NewLeagueScreen> createState() => _NewLeagueScreenState();
}

class _NewLeagueScreenState extends State<NewLeagueScreen> {
  String _selectedIconPath = 'assets/icons/icon1.svg';
  String _leagueName = '';
  String _password = '';
  String _selectedTheme = 'blue';
  String? _selectedLeagueType;

  final List<String> _errorMessages = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BackgroundWidget(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Custom3DCard(
                      height: screenHeight * 0.8,
                      width: screenWidth * 0.85,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                              CustomHeader(
                                title: 'New League',
                                width: screenWidth,
                                height: screenHeight,
                                onClose: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ));
                                },
                              ),
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),

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
                
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                              Text("League Name", style: TextStyle(color: const Color(0xFF006699), fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02)),
                              CustomTextField(
                                width: screenWidth,
                                height: screenHeight,
                                onChanged: (value) {
                                  setState(() {
                                    _leagueName = value;
                                  });
                                },
                              ),
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                              Text("Password", style: TextStyle(color: const Color(0xFF006699), fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02)),
                              CustomTextField(
                                width: screenWidth,
                                height: screenHeight,
                                onChanged: (value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                              ),
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                              Text("Select League Type", style: TextStyle(color: const Color(0xFF006699), fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02)),
                              CustomDropdownField(
                                width: screenWidth,
                                height: screenHeight,
                                items: const ['individual league', 'team league'],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLeagueType = value;
                                  });
                                  print('Selected league type: $_selectedLeagueType');
                                },
                              ),
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                              Text("Select League Theme", style: TextStyle(color: const Color(0xFF006699), fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02)),
                              CustomDropdownField(
                                width: screenWidth,
                                height: screenHeight,
                                items: const ['yellow', 'pink', 'blue', 'red', 'green'],
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null) {
                                      _selectedTheme = value;
                                    } else {
                                      _selectedTheme ='blue';
                                    }
                                  });
                                  print('Selected: $_selectedTheme');
                                },
                              ),
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                              Text("League Icon", style: TextStyle(color: const Color(0xFF006699), fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02)),
                              SizedBox(height: screenHeight*0.01),
                              IconPicker(
                                height: screenHeight,
                                initialIconPath: _selectedIconPath,
                                onIconSelected: (String iconPath) {
                                  setState(() {
                                    _selectedIconPath = iconPath;
                                  });
                                },
                              ),
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                              CustomButton(
                                title: 'Add',
                                width: screenWidth,
                                buttonStyleType: ButtonStyleType.dark,
                                buttonSize: ButtonSize.small,
                                height: screenHeight,
                                onTap: () async {
                                  _errorMessages.clear();

                                  if (_leagueName.isEmpty || _leagueName.length > 12) {
                                    _errorMessages.add('League name must be between 1 and 12 characters.');
                                  }
                
                                  if (_password.length < 3) {
                                    _errorMessages.add('Password must be at least 3 characters.');
                                  }

                                  if (_errorMessages.isNotEmpty) {
                                    setState(() {});
                                    return;
                                  }
                                  print(_errorMessages.length);
                                  print("\n\n");

                                  String leagueId = await DBHelper().generateUniqueId(_selectedLeagueType ?? 'individual league');
                                  String icon = _selectedIconPath;
                                  String creationDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                
                                  Map<String, dynamic> leagueData = {
                                    'id': leagueId,
                                    'name': _leagueName,
                                    'password': _password,
                                    'beta' : 0,
                                    'theme': _selectedTheme,
                                    'icon': icon,
                                    'creation_date': creationDate,
                                    'description': ''
                                  };
                
                                  if (_selectedLeagueType == 'team league') {
                                    await LeagueTeamDao().createTeamLeague(leagueData);
                                  } else {
                                    await LeagueIndividualDao().createIndividualLeague(leagueData);
                                  }
                
                                  print('League added: $leagueData');
                
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => const MyLeaguesScreen(),
                                  ));
                                },
                              ),
                              SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}