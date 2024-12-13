import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

String getHairColor(int hairid){
  switch(hairid){
    case 1:
      return '0xFFBCBCBC';
    case 2:
      return '0xFFAA8144';
    case 3:
      return '0xFFDA6C11';
    case 4:
      return '0xFF803F0A';
    case 5:
      return '0xFF4B2506';
    default:
      return '0xFF171717';
  }
}

class Hair extends StatefulWidget {
  final int hairId;
  final int hairColorId;
  final double size;
  const Hair(
      {super.key,
        required this.hairId,
        required this.hairColorId,
        required this.size,
      });

  @override
  State<Hair> createState() => _HairState();
}

class _HairState extends State<Hair> {
  @override
  Widget build(BuildContext context) {
    int hairColor = int.parse(getHairColor(widget.hairColorId));

    switch(widget.hairId){
      case 1:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/hair1.svg",
              color: Color(int.parse(getHairColor(widget.hairColorId))),
              width: widget.size,
            ),
          ],
        );
      case 2:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/hair2.svg",
              color: Color(hairColor),
              width: widget.size,
            ),
          ],
        );
      case 3:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/hair3.svg",
              color: Color(hairColor),
              width: widget.size,
            ),
          ],
        );
      case 4:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/hair4.svg",
              color: Color(hairColor),
              width: widget.size,
            ),
          ],
        );
      case 5:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/hair5.svg",
              color: Color(hairColor),
              width: widget.size,
            ),
          ],
        );
      case 6:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/hair6.svg",
              color: Color(hairColor),
              width: widget.size,
            ),
          ],
        );
      case 7:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/hair7.svg",
              color: Color(hairColor),
              width: widget.size,
            ),
          ],
        );
      default:
        return const Stack();
    }
  }
}

class Beard extends StatefulWidget {
  final int beardId;
  final int beardColorId;
  final double size;

  const Beard(
      {super.key,
        required this.beardId,
        required this.beardColorId,
        required this.size,
      });

  @override
  State<Beard> createState() => _BeardState();
}

class _BeardState extends State<Beard> {
  @override
  Widget build(BuildContext context) {
    final int beardColor = int.parse(getHairColor(widget.beardColorId));

    switch(widget.beardId){
      case 1:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/beard1.svg",
              color: Color(beardColor),
              width: widget.size,
            ),
          ],
        );
      case 2:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/beard2.svg",
              color: Color(beardColor),
              width: widget.size,
            ),
          ],
        );
      case 3:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/beard3.svg",
              color: Color(beardColor),
              width: widget.size,
            ),
          ],
        );
      case 4:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/beard4.svg",
              color: Color(beardColor),
              width: widget.size,
            ),
          ],
        );
      case 5:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/beard5.svg",
              color: Color(beardColor),
              width: widget.size,
            ),
          ],
        );
      default:
        return const Stack();
    }
  }
}

