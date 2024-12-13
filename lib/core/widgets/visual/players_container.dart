import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/widgets/avatar/avatar_container.dart';
import 'package:ranker/core/widgets/avatar/teamicon_container.dart';

class PlayerListContainer extends StatelessWidget {
  final String playerName;
  final int player_id;
  final int rank;
  final PlayerTheme playerTheme;
  final double width;
  final double height;
  final double margin;
  final VoidCallback onEdit;
  final bool isTeam;

  const PlayerListContainer({
    super.key,
    required this.playerName,
    required this.player_id,
    required this.rank,
    required this.playerTheme,
    required this.width,
    required this.height,
    this.margin = 10.0,
    required this.onEdit,
    required this.isTeam,
  });

  Color _getThemeColor() {
    switch (playerTheme) {
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
    double nameSize = (height * 0.02 < 14) ? 14 : height * 0.02;
    if(nameSize > width*0.04){
      nameSize = width * 0.04;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      child: Container(
        width: width * 0.7,
        height: (height * 0.1 < 50) ? 50 : height * 0.1,
        decoration: BoxDecoration(
          color: _getThemeColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              width: height * 0.09,
              height: (height * 0.09 < 45) ? 45 : height * 0.09,
              decoration: BoxDecoration(
                color: _getThemeColor(),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: isTeam
                    ? TeamiconContainer(size: height * 0.09, teamId: player_id)
                    : AvatarContainer(size: height * 0.09, playerId: player_id),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    playerName,
                    style: TextStyle(
                      fontSize: nameSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF006699),
                    ),
                  ),
                  Text(
                    "Rank: #$rank",
                    style: TextStyle(
                      fontSize: nameSize * 0.9,
                      color: const Color(0xFF006699),
                      fontFamily: 'WellFleet',
                    ),
                  ),
                ],
              ),
            ),
            // Szerkesztő gomb
            GestureDetector(
              onTap: onEdit, // Külső funkció meghívása
              child: Container(
                width: height * 0.07,
                height: height * 0.07,
                decoration: const BoxDecoration(
                  color: Colors.transparent, // Átlátszó háttér
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center, // Középre igazítás
                  children: [
                    // Alsó ikon (árnyék)
                    Positioned(
                      top: 10, // Az alsó ikon eltolása lefelé
                      child: Icon(
                        Icons.edit, // Szerkesztő ikon
                        color: const Color(0x26000000),
                        size: height * 0.05,
                      ),
                    ),
                    // Felső ikon
                    Icon(
                      Icons.edit, // Szerkesztő ikon
                      color: Colors.white, // Fehér szín
                      size: height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
