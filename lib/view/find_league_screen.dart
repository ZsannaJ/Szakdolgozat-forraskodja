import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/widgets/inputs/custom_textfield.dart';
import 'package:ranker/view/find_league_error_screen.dart';
import 'package:ranker/view/home_screen.dart';
import 'package:ranker/view/my_leagues_screen.dart';

class FindMatchScreen extends StatefulWidget {
  const FindMatchScreen({super.key});

  @override
  State<FindMatchScreen> createState() => _FindMatchScreenState();
}

class _FindMatchScreenState extends State<FindMatchScreen> {
  String _leagueId = '';
  String _password = '';
  final List<String> _errorMessages = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight= MediaQuery.of(context).size.height;

    return BackgroundWidget(
        child:Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                
                    Custom3DCard(
                      height: (screenHeight * 0.5 < 340) ? 340 : screenHeight * 0.5,
                      width: screenWidth * 0.85,
                      child: Column(
                        children: [
                          SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                          CustomHeader(
                              title: 'Find League',
                              width: screenWidth,
                              height: screenHeight,
                              onClose: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ));
                              },
                            isItBlue: true,
                          ),
                
                          SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Enter League ID",
                              style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02),
                              ),
                            ),
                
                
                          CustomTextField(
                              width: screenWidth,
                              height: screenHeight,
                              onChanged: (value){
                                setState(() {
                                  _leagueId = value;
                                });
                              },
                          ),
                
                          SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Enter League Password",
                              style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize:(screenHeight*0.02 < 12) ? 12 : screenHeight*0.02),
                            ),
                          ),
                
                          CustomTextField(
                            width: screenWidth,
                            height: screenHeight,
                            onChanged: (value){
                              setState(() {
                                _password = value;
                              });
                            },
                          ),
                
                          SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                          CustomButton(
                            title: 'Add',
                            height: screenHeight,
                            width: screenWidth,
                            buttonStyleType: ButtonStyleType.dark,
                            buttonSize: ButtonSize.small,
                            onTap: () async{
                              _errorMessages.clear();
                
                              if (_leagueId.isEmpty || _password.isEmpty) {
                                _errorMessages.add('League ID and PASSWORD must be given!');
                              }
                
                              if (_errorMessages.isNotEmpty) {
                                setState(() {});
                                return; // Ne folytassa a ligák létrehozását, ha van hiba
                              }
                
                              bool foundLeague = await LeagueDao().findLeagueInLocalDatabase(_leagueId, _password);
                
                              if(foundLeague){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => const MyLeaguesScreen(),
                                ));
                              }else{
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => const FindMatchErrorScreen(),
                                ));
                              }
                
                
                            },
                          ),
                          SizedBox(height: (screenHeight*0.03<10) ? 10 : screenHeight*0.03),
                        ],
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

