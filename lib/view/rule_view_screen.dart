import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/visual/custom_simple_hadder.dart';
import 'package:ranker/core/widgets/navigation/custom_navbar.dart';
import 'package:ranker/view/add_rule.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/dao/league_dao.dart';

class RuleView extends StatefulWidget {
  final String leagueId;

  const RuleView({super.key, required this.leagueId});

  @override
  State<RuleView> createState() => _RuleViewState();
}

class _RuleViewState extends State<RuleView> {
  late Future<String?> _leagueNameFuture;
  late Future<String?> _descriptionFuture;

  @override
  void initState() {
    super.initState();
    _leagueNameFuture = LeagueDao().getLeagueNameById(widget.leagueId);
    _descriptionFuture = LeagueDao().readDescription(widget.leagueId);
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
                  Text(
                    "Rule View",
                    style: TextStyle(
                      fontSize: (screenHeight * 0.024 < 12) ? 12 : screenHeight * 0.024,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xb3ffffff),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Custom3DCard(
                    height: (screenHeight < screenWidth) ? screenHeight * 0.5 : screenHeight * 0.65,
                    width: screenWidth * 0.85,
                    child: FutureBuilder<String?>(
                      future: _descriptionFuture,
                      builder: (context, snapshot) {
                        String displayText;
              
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          displayText = "Loading description...";
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          displayText = snapshot.data!;
                        } else {
                          displayText = "No description available.";
                        }
              
                        return Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      displayText,
                                      style: TextStyle(
                                        fontFamily: "Wellfleet",
                                        fontWeight: FontWeight.bold,
                                        fontSize: (screenHeight * 0.024 < 12) ? 12 : screenHeight * 0.024,
                                        color: const Color(0xFF006699),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: CustomButton(
                                title: 'Edit',
                                height: screenHeight,
                                width: screenWidth,
                                buttonStyleType: ButtonStyleType.dark,
                                buttonSize: ButtonSize.small,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddRule(leagueId: widget.leagueId, description: displayText,),
                                  ));
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
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
