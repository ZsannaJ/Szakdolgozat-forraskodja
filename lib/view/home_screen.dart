import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';

import 'package:ranker/view/new_league_screen.dart';
import 'package:ranker/view/find_league_screen.dart';
import 'package:ranker/view/my_leagues_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight= MediaQuery.of(context).size.height;

    return BackgroundWidget(
        child:Stack(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.15),
                  Image.asset(
                    "assets/images/logo.png",
                    semanticLabel: 'logo',
                    height: screenHeight * 0.25,
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  CustomButton(
                    title: 'New League',
                    buttonStyleType: ButtonStyleType.green,
                    buttonSize: ButtonSize.big,
                    height: screenHeight,
                    width: screenWidth,

                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const NewLeagueScreen(),
                      ));
                    },
                  ),
                  SizedBox(height: screenHeight/40),
                  CustomButton(
                    title: 'Find League',
                    buttonStyleType: ButtonStyleType.yellow,
                    buttonSize: ButtonSize.big,
                    height: screenHeight,
                    width: screenWidth,
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const FindMatchScreen(),
                      ));
                    },
                  ),
                  SizedBox(height: screenHeight/40),
                  CustomButton(
                    title: 'My Leagues',
                    buttonStyleType: ButtonStyleType.red,
                    buttonSize: ButtonSize.big,
                    height: screenHeight,
                    width: screenWidth,
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MyLeaguesScreen(),
                      ));
                    },
                  ),


                ],
              ),
            )],
        )
    );
  }
}

