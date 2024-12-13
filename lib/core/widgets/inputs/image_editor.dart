import 'package:flutter/material.dart';
import 'package:ranker/core/widgets/avatar/avatar_container.dart';
import 'package:ranker/core/widgets/avatar/teamicon_container.dart';

class ImageEditor extends StatelessWidget {
  final int player_id;
  final VoidCallback onTap;
  final bool isTeam;
  final Color playerTheme;
  final double height;

  const ImageEditor({
    super.key,
    required this.player_id,
    required this.onTap,
    required this.isTeam,
    required this.playerTheme,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    double helperHeight = (height * 0.16 < 100) ? 100 : height * 0.16;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: helperHeight,
        height: helperHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Lekerekített végű
          color: playerTheme,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child:isTeam ? TeamiconContainer(size: helperHeight, teamId: player_id) : AvatarContainer(size: helperHeight, playerId: player_id,)
            ),
            Positioned(
              right: 5, // Jobb oldalon
              bottom: 5, // Alsó rész
              child: Container(
                padding: const EdgeInsets.all(4), // Padding az ikon körül
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Kör alakú
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Árnyék
                      blurRadius: 4, // Árnyék elmosódása
                      offset: const Offset(2, 2), // Árnyék pozíciója
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit, // Szerkesztés ikon
                  color: const Color(0xFF006699),
                  size: height * 0.03,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}