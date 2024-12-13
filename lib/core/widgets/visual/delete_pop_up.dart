import 'package:flutter/material.dart';
import 'package:ranker/core/constants/enums.dart';
import 'package:ranker/core/widgets/inputs/custon_button.dart';

class DeletePopUp extends StatelessWidget {
  final double width;
  final double height;
  final Function() onCancel;
  final Function() onDelete;

  const DeletePopUp({
    super.key,
    required this.width,
    required this.height,
    required this.onCancel,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Homályos háttér

          Container(
            width: width,
            height: height,
            color: const Color(0xFF006699).withOpacity(0.5),
            child:
            Center(
              child: Container(
                width: width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontSize: height*0.03 < 15 ? 15 : height*0.03,
                        color: const Color(0xFF006699),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Row gombokkal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          title: 'Cancel',
                          height: height,
                          width: width,
                          buttonStyleType: ButtonStyleType.dark,
                          buttonSize: ButtonSize.small,
                          onTap: onCancel,
                        ),
                        const SizedBox(width: 10),
                        CustomButton(
                          title: 'Delete',
                          height: height,
                          width: width,
                          buttonStyleType: ButtonStyleType.red,
                          buttonSize: ButtonSize.small,
                          onTap: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ),
        // Középre igazított pop-up ablak

      ],
    );
  }
}
