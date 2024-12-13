import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ranker/core/dao/team_dao.dart';


String getIcon(int skinid){
  switch(skinid){
    case 1:
      return "assets/images/teamicons/teamicon2.svg";
    case 2:
      return "assets/images/teamicons/teamicon3.svg";
    case 3:
      return "assets/images/teamicons/teamicon4.svg";
    case 4:
      return "assets/images/teamicons/teamicon5.svg";
    case 5:
      return "assets/images/teamicons/teamicon6.svg";
    case 6:
      return "assets/images/teamicons/teamicon7.svg";
    default:
      return "assets/images/teamicons/teamicon1.svg";
  }
}

String getIconColor(int skinid){
  switch(skinid){
    case 1:
      return "0xFFEBEBEB";
    case 2:
      return "0xFFFC8AFF";
    case 3:
      return "0xFFff4237";
    case 4:
      return "0xFFff781f";
    case 5:
      return "0xFFFFDB0A";
    case 6:
      return "0xFF76B948";
    case 7:
      return "0xFF61a7ff";
    case 8:
      return "0xFFB796D3";
    default:
      return "0xFF464646";
  }
}


class TeamiconContainer extends StatefulWidget {
  final double size;
  final int teamId;

  const TeamiconContainer(
      {super.key,
        required this.size,
        required this.teamId,
      });

  @override
  State<TeamiconContainer> createState() => _TeamiconContainerState();
}

class _TeamiconContainerState extends State<TeamiconContainer> {

  int icon = 0;
  int icon_color = 0;

  @override
  void initState() {
    super.initState();
    _loadAvatarData();
  }

  // Avatar adatainak lekérése a playerId alapján
  Future<void> _loadAvatarData() async {
    final avatarData = await TeamDao().readTeamById(widget.teamId);
    if (avatarData != null) {
      setState(() {
        icon = avatarData['icon'] ?? 0;
        icon_color = avatarData['icon_color'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TeamiconValueContainer(size: widget.size, icon: icon, icon_color: icon_color);
  }
}

class TeamiconValueContainer extends StatefulWidget {
  final double size;
  final int icon;
  final int icon_color;

  const TeamiconValueContainer({
    super.key,
    required this.size,
    required this.icon,
    required this.icon_color,
  });

  @override
  State<TeamiconValueContainer> createState() => _TeamiconValueContainerState();
}

class _TeamiconValueContainerState extends State<TeamiconValueContainer> {

  @override
  Widget build(BuildContext context) {


    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          getIcon(widget.icon),
          color: Color(int.parse(getIconColor(widget.icon_color))),
          width: widget.size,
        ),

      ],
    );
  }
}

