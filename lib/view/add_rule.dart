import 'package:flutter/material.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/inputs/custom_textarea.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/local_db/db_helper.dart';
import 'package:ranker/view/rule_view_screen.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/dao/league_dao.dart';

class AddRule extends StatefulWidget {
  final String leagueId;
  final String description;

  const AddRule({super.key, required this.leagueId, required this.description});

  @override
  State<AddRule> createState() => _AddRuleState();
}

class _AddRuleState extends State<AddRule> {
  bool isTeamLeague = false;
  late TextEditingController _controller; // Controller a szöveg kezelésére

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.description); // Controller inicializálása a kezdő szöveggel
    _checkLeagueType();
  }

  @override
  void dispose() {
    _controller.dispose(); // Fontos: A controller megfelelő felszabadítása, amikor az oldal elhagyásra kerül
    super.dispose();
  }

  Future<void> _checkLeagueType() async {
    final dbHelper = DBHelper();
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
                  const SizedBox(height: 20),
                  Custom3DCard(
                    height: screenHeight * 0.75,
                    width: screenWidth * 0.85,
                    child: Column(
                      children: [
                        CustomHeader(
                          title: 'Add Description',
                          width: screenWidth,
                          height: screenHeight,
                          onClose: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => RuleView(leagueId: widget.leagueId),
                            ));
                          },
                          isItBlue: true,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        CustomTextArea(
                          width: screenWidth,
                          height: (screenHeight < screenWidth) ? screenHeight * 0.48 : screenHeight * 0.7,
                          initialText: widget.description,
                          controller: _controller,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        CustomButton(
                          title: 'SAVE',
                          buttonStyleType: ButtonStyleType.dark,
                          height: screenHeight,
                          width: screenWidth,
                          buttonSize: ButtonSize.small,
                          onTap: () async {
                            String newDescription = _controller.text;
                            if (newDescription.isNotEmpty) {
                              await LeagueDao().updateDescription(widget.leagueId, newDescription);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => RuleView(leagueId: widget.leagueId),
                              ));
                            }
                          },
                        ),
                      ],
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
}

