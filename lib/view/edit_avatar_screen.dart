import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/dao/player_dao.dart';
import 'package:ranker/core/widgets/avatar/avatar_container.dart';
import 'package:ranker/core/widgets/inputs/custom_slider.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/view/edit_player_screen.dart';



class EditAvatarScreen extends StatefulWidget {
  final int playerId;
  final String leagueId;
  const EditAvatarScreen({super.key, required this.playerId, required this.leagueId});

  @override
  State<EditAvatarScreen> createState() => _EditAvatarScreenState();
}

class _EditAvatarScreenState extends State<EditAvatarScreen> {
  int skin_color = 0;
  int hair = 0;
  int hair_color = 0;
  int top = 1;
  int top_color = 3;
  int beard = 0;
  int beard_color = 0;
  int glasses = 0;
  int glasses_color = 0;

  String playerTheme = 'def';
  bool isLoading = true;

  late int _playerId;

  @override
  void initState() {
    super.initState();
    _playerId = widget.playerId;
    _loadTeamData(widget.playerId);
  }

  Future<void> _loadTeamData(int playerId) async {
    Map<String, dynamic>? playerData;
    playerData = await PlayerDao().readPlayerById(playerId);

    if (playerData != null) {
      setState(() {
        skin_color = playerData?['skin_color'] ?? 0;
        hair = playerData?['hair'] ?? 0;
        hair_color = playerData?['hair_color'] ?? 0;
        top = playerData?['top'] ?? 0;
        top_color = playerData?['top_color'] ?? 0;
        beard = playerData?['beard'] ?? 0;
        beard_color = playerData?['beard_color'] ?? 0;
        glasses = playerData?['glasses'] ?? 0;
        glasses_color = playerData?['glasses_color'] ?? 0;

        playerTheme = playerData?['theme'] ?? 'def';
        isLoading = false;

        print(skin_color.toDouble());
      });
    }
  }

  Future<void> _saveAvatar() async {
    final updatedData = {
      'skin_color': skin_color,
      'hair': hair,
      'hair_color': hair_color,
      'top': top,
      'top_color': top_color,
      'beard': beard,
      'beard_color': beard_color,
      'glasses': glasses,
      'glasses_color': glasses_color,
    };
    try {
      await PlayerDao().updatePlayer(widget.playerId, updatedData);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => EditPlayerScreen(playerId: widget.playerId, leagueId: widget.leagueId,),
      ));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating league: $e')));
    }
  }

  Color _getThemeColor() {
    switch (playerTheme) {
      case 'yellow':
        return const Color(0xFFFFED84);
      case 'pink':
        return const Color(0xFFFDC4FF);
      case 'blue':
        return const Color(0xFFA5ECFF);
      case 'red':
        return const Color(0xFFFFA2B9);
      case 'green':
        return const Color(0xFFB3F480);
      default:
        return const Color(0xFFA1D4EE);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight= MediaQuery.of(context).size.height;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Várakozási animáció
    }

    return BackgroundWidget(
        child:Stack(
          children: [
            Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  
                      Custom3DCard(
                        height: screenHeight * 0.75,
                        width: screenWidth * 0.85,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                  
                              SizedBox(height: screenHeight * 0.02),
                              CustomHeader(
                                title: 'Avatar Editor',
                                width: screenWidth*0.8,
                                height: screenHeight,
                                onClose: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => EditPlayerScreen(playerId: widget.playerId, leagueId: widget.leagueId,),
                                  ));
                                },
                                isItBlue: true,
                              ),
                  
                              SizedBox(height: screenHeight * 0.02),
                  
                              Container(
                                height: (screenHeight * 0.2 < 100) ? 100 : screenHeight * 0.2,
                                width: (screenHeight * 0.2 < 100) ? 100 : screenHeight * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: _getThemeColor(),
                                ),
                                child: AvatarValueContainer(
                                  size: (screenHeight * 0.18 < 80) ? 80 : screenHeight * 0.18,
                                  skinId: skin_color,
                                  hairId: hair,
                                  hairColorId: hair_color,
                                  topId: top,
                                  topColorId: top_color,
                                  beardId: beard,
                                  beardColorId: beard_color,
                                  extraId: glasses,
                                  extraColorId: glasses_color,
                                ),
                              ),
                  
                              SizedBox(height: screenHeight * 0.02),
                              SizedBox(
                                height: screenHeight*0.4,
                                child: SingleChildScrollView(
                                  child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Skin",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 6,
                                          step: 1,
                                          initialValue: skin_color.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              skin_color = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Hair",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 7,
                                          step: 1,
                                          initialValue: hair.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              hair = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Hair Color",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 5,
                                          step: 1,
                                          initialValue: hair_color.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              hair_color = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Beard",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 5,
                                          step: 1,
                                          initialValue: beard.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              beard = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Beard Color",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 5,
                                          step: 1,
                                          initialValue: beard_color.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              beard_color = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Top",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 6,
                                          step: 1,
                                          initialValue: top.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              top = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Top Color",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 8,
                                          step: 1,
                                          initialValue: top_color.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              top_color = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Extra",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 3,
                                          step: 1,
                                          initialValue: glasses.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              glasses = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Select Extra Color",
                                            style: TextStyle(
                                              color: const Color(0xFF006699),
                                              fontSize: (screenHeight*0.02 < 12) ? 12 : screenHeight*0.02,
                                            ),
                                          ),
                                        ),
                                        CustomSlider(
                                          width: screenWidth * 0.7,
                                          minValue: 0,
                                          maxValue: 8,
                                          step: 1,
                                          initialValue: glasses_color.toDouble(),
                                          onChanged: (value) {
                                            setState(() {
                                              glasses_color = value.toInt();
                                            });
                                          },
                                        ),
                                  
                                        SizedBox(height: screenHeight * 0.02),
                                  
                                        CustomButton(
                                          title: 'save',
                                          height: screenHeight,
                                          width: screenWidth,
                                          buttonStyleType: ButtonStyleType.dark,
                                          buttonSize: ButtonSize.small,
                                          onTap:  _saveAvatar,
                                        ),
                                  
                                        SizedBox(height: screenHeight * 0.06),
                                      ],
                                    ),
                                ),
                              ),
                  
                            ],
                          ),
                        ),
                      ),
                  
                  
                    ],
                  ),
                ),
            )],
        )
    );
  }
}


