import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/widgets/navigation/custom_navbar_button.dart';
// hozzáadva az adatbázis eléréshez
import 'package:ranker/core/dao/league_dao.dart';  // hozzáadva az adatbázis eléréshez
import 'package:ranker/view/edit_league_screen.dart';
import 'package:ranker/view/my_leagues_screen.dart';

import 'package:ranker/view/rank_view_screen.dart';
import 'package:ranker/view/match_view_screen.dart';
import 'package:ranker/view/player_view_screen.dart';
import 'package:ranker/view/graph_view.dart';
import 'package:ranker/view/rule_view_screen.dart';
import 'package:ranker/view/tryout_screen.dart';

class CustomNavBar extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String leagueId;

  const CustomNavBar({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.leagueId
  });

  @override
  Widget build(BuildContext context) {
    double distance = screenWidth * 0.015;
    double buttonSize = screenHeight * 0.11;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.12,
      color: const Color(0xEEFFFFFF),
      child: FutureBuilder<bool>(
        future: LeagueDao().isTeamLeague(leagueId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final isTeamLeague = snapshot.data ?? false;
          final playerButtonTitle = isTeamLeague ? "Teams" : "Players";
          final playerButtonIcon = isTeamLeague ? NavbarIcon.teams : NavbarIcon.players;

          return ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[

                SizedBox(width: distance,),
              CustomNavbarButton(
                title: "Exit",
                buttonStyleType: ButtonStyleType.dark,
                navbarIcon: NavbarIcon.exit,
                buttonSize: buttonSize,
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const MyLeaguesScreen(),
                  ));
                },
              ),
              SizedBox(width: distance,),
                CustomNavbarButton(
                  title: "Rules",
                  buttonStyleType: ButtonStyleType.orange,
                  navbarIcon: NavbarIcon.receipt,
                  buttonSize: buttonSize,
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => RuleView(leagueId: leagueId),
                    ));
                  },
                ),
                SizedBox(width: distance,),
                CustomNavbarButton(
                  title: "Rank",
                  buttonStyleType: ButtonStyleType.blue,
                  navbarIcon: NavbarIcon.rank,
                  buttonSize: buttonSize,
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => RankView(leagueId: leagueId),
                    ));
                  },
                ),
                SizedBox(width: distance,),
                CustomNavbarButton(
                  title: "Graph",
                  buttonStyleType: ButtonStyleType.green,
                  navbarIcon: NavbarIcon.graph,
                  buttonSize: buttonSize,
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GraphView(leagueId: leagueId),
                    ));
                  },
                ),
                SizedBox(width: distance,),
                CustomNavbarButton(
                  title: playerButtonTitle,
                  buttonStyleType: ButtonStyleType.red,
                  navbarIcon: playerButtonIcon,
                  buttonSize: buttonSize,
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => PlayerView(leagueId: leagueId),
                    ));
                  },
                ),
                SizedBox(width: distance,),
                CustomNavbarButton(
                  title: "Matches",
                  buttonStyleType: ButtonStyleType.yellow,
                  navbarIcon: NavbarIcon.matches,
                  buttonSize: buttonSize,
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MatchView(leagueId: leagueId),
                    ));
                  },
                ),
                SizedBox(width: distance,),
                CustomNavbarButton(
                  title: "Tryout",
                  buttonStyleType: ButtonStyleType.pink,
                  navbarIcon: NavbarIcon.play,
                  buttonSize: buttonSize,
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TryoutScreen(leagueId: leagueId),
                    ));
                  },
                ),
                SizedBox(width: distance,),
                CustomNavbarButton(
                  title: "Edit",
                  buttonStyleType: ButtonStyleType.dark,
                  navbarIcon: NavbarIcon.settings,
                  buttonSize: buttonSize,
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => EditLeagueScreen(leagueId: leagueId),
                    ));
                  },
                ),
                SizedBox(width: distance,),
              ],
          );
        },
      ),
    );
  }
}
