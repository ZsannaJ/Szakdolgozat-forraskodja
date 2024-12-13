import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';

class RankContainer extends StatelessWidget {
  final int ranking;
  final String playerName;
  final double score;
  final PlayerTheme playerTheme;
  final double width;
  final double height;
  final double bottomMargin;

  const RankContainer({
    super.key,
    required this.ranking,
    required this.playerName,
    required this.score,
    required this.playerTheme,
    required this.width,
    required this.height,
    this.bottomMargin = 8.0,
  });

  Color _getRankingColor() {
    switch (ranking) {
      case 1:
        return const Color(0xFFBB9722);
      case 2:
        return const Color(0xFFA4A4A4);
      case 3:
        return const Color(0xFFB87333);
      default:
        return const Color(0xFF006699);
    }
  }

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
        return const Color(0xFFA1D4EE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (width * 0.75 > 100) ? 100 : width * 0.75,
      height: (height * 0.1 < 50) ? 50 : height * 0.1,
      margin: EdgeInsets.only(bottom: bottomMargin), // Alsó margó beállítása
      decoration: BoxDecoration(
        color: _getThemeColor(), // Konténer szín
        borderRadius: BorderRadius.circular(height * 0.015), // Kerekített sarkak
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Center(
            child:Text(
              playerName,
              style: TextStyle(
                fontSize: (playerName.length > 9) ? height * 0.016 : height * 0.025,
                color: const Color(0xFF006699), // Játékos neve
              ),
            ),
          ),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Helyezés
            Text(
              ranking.toString(),
              style: TextStyle(
                fontSize: height * 0.07,
                fontWeight: FontWeight.bold,
                color: _getRankingColor(), // Helyezés színe
              ),
            ),
            // Játékos neve
            Text(
              ( "${(score * 100).toStringAsFixed(0)}%"),
              style: TextStyle(
                fontSize: height * 0.02,
                color: const Color(0xFF006699), // Pontszám
              ),
            ),
          ],
        ),
      ]
      ),
    );
  }
}
