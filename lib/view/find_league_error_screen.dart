import 'package:flutter/material.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/view/find_league_screen.dart';

class FindMatchErrorScreen extends StatefulWidget {
  const FindMatchErrorScreen({super.key});

  @override
  State<FindMatchErrorScreen> createState() => _FindMatchErrorScreenState();
}

class _FindMatchErrorScreenState extends State<FindMatchErrorScreen> {
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
                      height: (screenHeight * 0.3 < 180) ? 180 : screenHeight * 0.3,
                      width: (screenWidth * 0.85 < 270) ? 270 : screenWidth * 0.85,
                      child: Column(
                        children: [
                          CustomHeader(
                            title: 'League Not Found',
                            width: screenWidth,
                            height: screenHeight,
                            onClose: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => const FindMatchScreen(),
                              ));
                            },
                            isItBlue: false,
                          ),
                
                          const SizedBox(height: 40),
                
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "We couldn't find any leagues matching your ID.",
                              style: TextStyle(
                                color: const Color(0xFFE90038),
                                fontSize:  (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02
                              ),
                              ),
                            ),
                
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Please try again!",
                              style: TextStyle(
                                color: const Color(0xFFE90038),
                                fontSize:  (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02
                              ),
                              ),
                            ),
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

