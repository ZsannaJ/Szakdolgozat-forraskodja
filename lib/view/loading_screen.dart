import 'package:flutter/material.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/view/home_screen.dart';



class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override

  void initState() {
    Future.delayed(const Duration(seconds: 3), () {


        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));

    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight= MediaQuery.of(context).size.height;

    return BackgroundWidget(
        child:Stack(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.2),
                  Image.asset(
                    "assets/images/logo.png",
                    semanticLabel: 'logo',
                    height: screenHeight * 0.25,
                  ),
                  SizedBox(height: screenHeight*0.3),

                  Text("Loading...",
                  style: TextStyle(color: const Color(0xFF006699), fontSize: screenWidth * 0.05,),
                  ),
                ],
              ),
            )],
        )
    );
  }
}
