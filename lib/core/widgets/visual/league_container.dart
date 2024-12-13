import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ranker/core/constants/enums.dart';

class LeagueListContainer extends StatelessWidget {
  final String leagueName;
  final String leagueInfo1;
  final String leagueInfo2;
  final String leagueImagePath;
  final PlayerTheme leagueTheme;
  final double width;
  final double height;
  final VoidCallback onTap;

  const LeagueListContainer({
    super.key,
    required this.leagueName,
    required this.leagueInfo1,
    required this.leagueInfo2,
    required this.leagueImagePath,
    required this.leagueTheme,
    required this.width,
    required this.height,
    required this.onTap,
  });

  Color _getThemeColor() {
    switch (leagueTheme) {
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
    double nameSize = (height * 0.03 < 14) ? 14 : height * 0.03;
    if(nameSize > width*0.05){
      nameSize = width * 0.05;
    }

    return GestureDetector(
      onTap: onTap, // Az egész konténer kattintható
      child: Container(
        height: (height * 0.14 < 100) ? 100 : height * 0.14,
        width: width * 0.8,
        margin: const EdgeInsets.symmetric(vertical: 10), // Margó a konténer körül
        padding: const EdgeInsets.all(10), // Párnázás a tartalom körül
        decoration: BoxDecoration(
          color: _getThemeColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Kép és szövegek középre igazítása
          children: [
            // Liga képe bal oldalon, kerekített sarkú négyzet
            Container(
              padding: const EdgeInsets.all(5), // Belső padding a kép körül
              decoration: BoxDecoration(
                color: const Color(0x99FFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: (height * 0.09 < 50) ? 50 : height * 0.09,
                height:(height * 0.09 < 50) ? 50 : height * 0.09,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Kerekített sarkak a képhez is
                ),
                child: SvgPicture.asset(
                  height: (height * 0.085 < 85) ? 85 : height * 0.085,
                  leagueImagePath, // SVG fájl elérési útja
                  fit: BoxFit.cover, // A kép teljesen kitölti a rendelkezésre álló helyet
                ),
              ),
            ),
            const SizedBox(width: 16), // Térköz a kép és az oszlop között

            // Szövegek oszlopa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    leagueName,
                    style: TextStyle(
                      fontSize: nameSize,
                      color: const Color(0xFF006699),
                    ),
                  ),

                  // Liga első információ
                  Text(
                    leagueInfo1,
                    style: TextStyle(
                      fontSize: nameSize * 0.6,
                      color: const Color(0xFF006699),
                      fontFamily: 'WellFleet',
                    ),
                  ),

                  // Liga második információ
                  Text(
                    "started: $leagueInfo2",
                    style: TextStyle(
                      fontSize: nameSize * 0.6,
                      color: const Color(0xFF006699),
                      fontFamily: 'WellFleet',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
