import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

String getTopColor(int topid){
  switch(topid){
    case 1:
      return "0xFFEBEBEB";
    case 2:
      return "0xFFFEACBF";
    case 3:
      return "0xFFff4237";
    case 4:
      return "0xFFff781f";
    case 5:
      return "0xFFfcd64c";
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

String getTopShadowColor(int topid){
  switch(topid){
    case 1:
      return "0xFFBCBCBC";
    case 2:
      return "0xFFFE89AE";
    case 3:
      return "0xFFCC342C";
    case 4:
      return "0xFFCC6018";
    case 5:
      return "0xFFE2C044";
    case 6:
      return "0xFF5E9439";
    case 7:
      return "0xFF4D85CC";
    case 8:
      return "0xFF9278A8";
    default:
      return "0xFF2F2F2F";
  }
}

class Top extends StatefulWidget {
  final int topId;
  final int topColorId;
  final double size;

  const Top(
      {super.key,
        required this.topId,
        required this.topColorId,
        required this.size,
      });

  @override
  State<Top> createState() => _TopState();
}

class _TopState extends State<Top> {

  @override
  Widget build(BuildContext context) {
    final int topColor = int.parse(getTopColor(widget.topColorId));
    final int topShadowColor = int.parse(getTopShadowColor(widget.topColorId));

    switch(widget.topId){
      case 1:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/top1.svg",
              color: Color(topColor),
              width: widget.size,
            ),
          ],
        );
      case 2:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/top2_1.svg",
              color: Color(topColor),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top2_2.svg",
              color: Color(topShadowColor),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top2_3.svg",
              color: const Color(0xFF2F2F2F),
              width: widget.size,
            ),
          ],
        );
      case 3:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/top3_1.svg",
              color: Color(topColor),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top3_2.svg",
              color: Color(topColor),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top3_3.svg",
              color: Color(topShadowColor),
              width: widget.size,
            ),
          ],
        );
      case 4:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/top4_1.svg",
              color: Color(topColor),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top4_2.svg",
              color: Color(topShadowColor),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top4_3.svg",
              color: const Color(0xFF464646),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top4_4.svg",
              color: Color(topShadowColor),
              width: widget.size,
            ),
          ],
        );
      case 5:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/top5_1.svg",
              color: const Color(0xFFFFFFFF),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top5_2.svg",
              color: const Color(0xFFD3D3D3),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top5_3.svg",
              color: Color(topColor),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top5_4.svg",
              color: Color(topShadowColor),
              width: widget.size,
            ),
          ],
        );
      case 6:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/top6_1.svg",
              color: Color(topColor),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/top6_2.svg",
              color: topColor==0xFFEBEBEB ? const Color(0xFF464646) : const Color(0xFFEBEBEB),
              width: widget.size,
            ),

          ],
        );
      default:
        return const Stack();
    }
  }
}

class Extra extends StatefulWidget {
  final int extraId;
  final int extraColorId;
  final double size;

  const Extra(
      {super.key,
        required this.extraId,
        required this.extraColorId,
        required this.size,
  });

  @override
  State<Extra> createState() => _ExtraState();
}

class _ExtraState extends State<Extra> {
  @override
  Widget build(BuildContext context) {
    final int extraColor = int.parse(getTopShadowColor(widget.extraColorId));

    switch(widget.extraId){
      case 1:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/glasses1_1.svg",
              color: const Color(0xBBFFFFFF),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/glasses1_2.svg",
              color: Color(extraColor),
              width: widget.size,
            ),
          ],
        );
      case 2:
        return Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/avatar/glasses2_1.svg",
              color: const Color(0xBBFFFFFF),
              width: widget.size,
            ),
            SvgPicture.asset(
              "assets/images/avatar/glasses2_2.svg",
              color: Color(extraColor),
              width: widget.size,
            ),
          ],
        );
      default:
        return const Stack();
    }
  }
}

