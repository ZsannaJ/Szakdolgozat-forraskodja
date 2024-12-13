import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/widgets/avatar/avatar_clothes.dart';
import 'package:ranker/core/widgets/avatar/avatar_hair.dart';


String getSkinColor(int skinid){
    switch(skinid){
      case 1:
        return "0xFFF8DEC3";
      case 2:
        return "0xFFE9CBA9";
      case 3:
        return "0xFFE8BE94";
      case 4:
        return "0xFFD5A484";
      case 5:
        return "0xFF986842";
      case 6:
        return "0xFF7F4829";
      default:
        return "0xFFFAEBDB";
    }
}

String getSkinShadowColor(int skinid){
  switch(skinid){
    case 1:
      return "0xFFF5D1AC";
    case 2:
      return "0xFFE4BF95";
    case 3:
      return "0xFFE3B17F";
    case 4:
      return "0xFFCF9671";
    case 5:
      return "0xFF865C3A";
    case 6:
      return "0xFF6C3D23";
    default:
      return "0xFFF7DFC5";
  }
}


class AvatarContainer extends StatefulWidget {
  final double size;
  final int playerId;

  const AvatarContainer(
      {super.key,
        required this.size,
        required this.playerId,
      });

  @override
  State<AvatarContainer> createState() => _AvatarContainerState();
}

class _AvatarContainerState extends State<AvatarContainer> {
  int skinId = 0;
  int hairId = 0;
  int hairColorId = 0;
  int beardId = 0;
  int beardColorId = 0;
  int topId = 1;
  int topColorId = 3;
  int extraId = 0;
  int extraColorId = 0;

  @override
  void initState() {
    super.initState();
    _loadAvatarData();
  }

  // Avatar adatainak lekérése a playerId alapján
  Future<void> _loadAvatarData() async {
    final avatarData = await PlayerDao().readPlayerById(widget.playerId);
    if (avatarData != null) {
      setState(() {
        skinId = avatarData['skin_color'] ?? 0;
        hairId = avatarData['hair'] ?? 0;
        hairColorId = avatarData['hair_color'] ?? 0;
        beardId = avatarData['beard'] ?? 0;
        beardColorId = avatarData['beard_color'] ?? 0;
        topId = avatarData['top'] ?? 1;
        topColorId = avatarData['top_color'] ?? 3;
        extraId = avatarData['glasses'] ?? 0;
        extraColorId = avatarData['glasses_color'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AvatarValueContainer(
        size: widget.size,
        skinId: skinId,
        hairId: hairId,
        hairColorId: hairColorId,
        beardId: beardId,
        beardColorId: beardColorId,
        topId: topId,
        topColorId: topColorId,
        extraId: extraId,
        extraColorId: extraColorId);
  }
}


class AvatarValueContainer extends StatefulWidget {
  final double size;
  final int skinId;
  final int hairId;
  final int hairColorId;
  final int beardId;
  final int beardColorId;
  final int topId;
  final int topColorId;
  final int extraId;
  final int extraColorId;

  const AvatarValueContainer({
    super.key,
    required this.size,
    required this.skinId,
    required this.hairId,
    required this.hairColorId,
    required this.beardId,
    required this.beardColorId,
    required this.topId,
    required this.topColorId,
    required this.extraId,
    required this.extraColorId,
  });

  @override
  State<AvatarValueContainer> createState() => _AvatarValueContainerState();
}

class _AvatarValueContainerState extends State<AvatarValueContainer> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/avatar/skin.svg",
          color: Color(int.parse(getSkinColor(widget.skinId))),
          width: widget.size,
        ),
        SvgPicture.asset(
          "assets/images/avatar/skin_shadow.svg",
          color: Color(int.parse(getSkinShadowColor(widget.skinId))),
          width: widget.size,
        ),
        Top(topId: widget.topId, topColorId: widget.topColorId, size: widget.size,),
        Extra(extraId: widget.extraId, extraColorId: widget.extraColorId, size: widget.size,),

        Hair(hairId: widget.hairId, hairColorId: widget.hairColorId, size: widget.size),
        Beard(beardId: widget.beardId, beardColorId: widget.beardColorId, size: widget.size),
      ],
    );
  }
}

