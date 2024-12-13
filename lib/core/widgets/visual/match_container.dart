import 'package:ranker/core/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:ranker/core/widgets/avatar/avatar_container.dart';
import 'package:ranker/core/widgets/avatar/teamicon_container.dart';

class MatchContainer extends StatelessWidget {
  final int playerId1;
  final int playerId2;
  final String playerName1;
  final String playerName2;
  final PlayerTheme playerTheme1;
  final PlayerTheme playerTheme2;
  final int score1;
  final int score2;
  final double width;
  final double height;
  final VoidCallback onEdit;
  final bool isTeam;

  const MatchContainer({
    super.key,
    required this.playerId1,
    required this.playerId2,
    required this.playerName1,
    required this.playerName2,
    required this.playerTheme1,
    required this.playerTheme2,
    required this.score1,
    required this.score2,
    required this.width,
    required this.height,
    required this.onEdit,
    required this.isTeam,
  });

  Color _getThemeColor(PlayerTheme theme) {
    switch (theme) {
      case PlayerTheme.yellow:
        return const Color(0xFFFFED84);
      case PlayerTheme.pink:
        return const Color(0xFFFDC4FF);
      case PlayerTheme.blue:
        return const Color(0xFFA5ECFF);
      case PlayerTheme.red:
        return const Color(0xFFFFA2B9);
      case PlayerTheme.green:
        return const Color(0xFFB3F480);
      default:
        return const Color(0xFF92E7FD);
    }
  }

  @override
  Widget build(BuildContext context) {
    double nameSize = height * 0.02;
    if (nameSize > width*0.03){nameSize = width * 0.03;}

    double iconSize = height * 0.09;
    if (iconSize > width * 0.15){ iconSize = width * 0.15;}

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: width * 0.7,
        height: height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Játékos 1 oldala
                Flexible(
                  flex: 1,
                  child: Container(
                    color: _getThemeColor(playerTheme1), // Játékos 1 színe
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Játékos 1 "Avatar" helyett sima szögletes Container
                        Row(
                          children: [

                            Container(
                              width: height * 0.09,
                              height: (height * 0.09 < 45) ? 45 : height * 0.09,
                              color: _getThemeColor(playerTheme1), // Háttérszín
                              child: isTeam
                                  ? TeamiconContainer(size:iconSize, teamId: playerId1)
                                  : AvatarContainer(size: iconSize, playerId: playerId1),
                            ),
                            // Játékos 1 neve
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                playerName1,
                                style: TextStyle(
                                  color: const Color(0xFF006699),
                                  fontSize: nameSize,
                                  overflow: TextOverflow.ellipsis, // Ellipszis a hosszú szövegnél
                                ),
                                maxLines: 1, // Csak egy sorban jelenítjük meg
                              ),
                            ),
                          ],
                        ),

                        // Játékos 1 pontszáma
                        Container(
                          width: width,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "V",
                            style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: height * 0.04),
                          ),
                        ),
                        Container(
                          width: width,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "$score1-",
                            style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: height * 0.06),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Játékos 2 oldala
                Flexible(
                  flex: 1,
                  child: Container(
                    color: _getThemeColor(playerTheme2), // Játékos 2 színe
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Játékos 2 "Avatar" helyett sima szögletes Container

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            const SizedBox(width: 5), // Különbség
                            Flexible(
                              child: Text(
                                playerName2,
                                style: TextStyle(
                                  color: const Color(0xFF006699),
                                  fontSize: nameSize,
                                  overflow: TextOverflow.ellipsis, // Ellipszis a hosszú szövegnél
                                ),
                                maxLines: 1, // Csak egy sorban jelenítjük meg
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: height * 0.09,
                              height: (height * 0.09 < 45) ? 45 : height * 0.09,
                              color: _getThemeColor(playerTheme2), // Háttérszín
                              child: isTeam
                                  ? TeamiconContainer(size: iconSize, teamId: playerId2)
                                  : AvatarContainer(size: iconSize, playerId: playerId2),
                            ),
                          ],
                        ),

                        // Játékos 2 pontszáma
                        Container(
                          width: width,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "S",
                            style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: height * 0.04),
                          ),
                        ),
                        Container(
                          width: width,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "-$score2",
                            style: TextStyle(
                                color: const Color(0xFF006699),
                                fontSize: height * 0.06),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Edit gomb a jobb alsó sarokban
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: onEdit, // Külső funkció meghívása
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.transparent, // Átlátszó háttér
                    shape: BoxShape.circle,
                  ),
                  child: const Stack(
                    alignment: Alignment.center, // Középre igazítás
                    children: [
                      // Alsó ikon (árnyék)
                      Positioned(
                        top: 10, // Az alsó ikon eltolása lefelé
                        child: Icon(
                          Icons.edit, // Szerkesztő ikon
                          color: Color(0x26000000),
                          size: 30,
                        ),
                      ),
                      // Felső ikon
                      Icon(
                        Icons.edit, // Szerkesztő ikon
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
