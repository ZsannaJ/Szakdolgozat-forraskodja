import 'package:flutter/material.dart';
import 'package:ranker/core/widgets/visual/background.dart';
import 'package:ranker/core/widgets/visual/custom_hadder.dart';
import 'package:ranker/core/widgets/visual/custom_3d_card.dart';
import 'package:ranker/core/widgets/visual/league_container.dart';
import 'package:ranker/view/home_screen.dart';
import 'package:ranker/view/rank_view_screen.dart';
import 'package:ranker/core/assets/assets.dart';
import 'package:ranker/core/local_db/db_helper.dart';

import 'package:ranker/core/dao/league_dao.dart';
import 'package:ranker/core/dao/league_team_dao.dart';
import 'package:ranker/core/dao/league_individual_dao.dart';


class MyLeaguesScreen extends StatefulWidget {
  const MyLeaguesScreen({super.key});

  @override
  State<MyLeaguesScreen> createState() => _MyLeaguesScreenState();
}

class _MyLeaguesScreenState extends State<MyLeaguesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> individualLeagues = [];
  List<Map<String, dynamic>> teamLeagues = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLeagues();
  }

  Future<void> _loadLeagues() async {
    final dbHelper = DBHelper();
    List<Map<String, dynamic>> fetchedIndividualLeagues = await LeagueIndividualDao().listAllIndividualLeagues();
    List<Map<String, dynamic>> fetchedTeamLeagues = await LeagueTeamDao().listAllTeamLeagues();

    setState(() {
      individualLeagues = fetchedIndividualLeagues;
      teamLeagues = fetchedTeamLeagues;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BackgroundWidget(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Custom3DCard(
                    height: screenHeight * 0.8,
                    width: screenWidth * 0.85,
                    child: Column(
                      children: [
                        SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
                        CustomHeader(
                          title: 'My Leagues',
                          width: screenWidth,
                          height: screenHeight,
                          onClose: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ));
                          },
                          isItBlue: true,
                        ),
                        SizedBox(height: (screenHeight*0.02<10) ? 10 : screenHeight*0.02),
              
                        // TabBar ikonos
                        TabBar(
                          controller: _tabController,
                          indicatorColor: const Color(0xFF006699),
                          labelColor: const Color(0xFF006699),
                          unselectedLabelColor: Colors.grey,
                          tabs: const [
                            Tab(icon: Icon(Icons.person, color: Color(0xFF006699))),
                            Tab(icon: Icon(Icons.groups, color: Color(0xFF006699))),
                          ],
                        ),
                        SizedBox(height: (screenHeight*0.01<10) ? 10 : screenHeight*0.01),
              
                        // Betöltés kijelzése
                        if (isLoading)
                          const CircularProgressIndicator()
                        else
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildIndividualLeaguesList(),
                                _buildTeamLeaguesList(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildIndividualLeaguesList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (individualLeagues.isEmpty) {
      return const Center(child: Text('No individual leagues found.', style: TextStyle(color: Color(0xFF006699))));
    }

    return ListView.builder(
      itemCount: individualLeagues.length,
      itemBuilder: (context, index) {
        final league = individualLeagues[index];
        return FutureBuilder<int>(
          future: LeagueDao().countLeagueParticipants(league['id']),
          builder: (context, snapshot) {
            String leagueInfo1;
            if (snapshot.connectionState == ConnectionState.waiting) {
              leagueInfo1 = 'Loading...';
            } else if (snapshot.hasError) {
              leagueInfo1 = 'Error: ${snapshot.error}';
            } else {
              leagueInfo1 = '${snapshot.data} players';
            }

            return LeagueListContainer(
              leagueName: league['name'],
              leagueInfo1: leagueInfo1,
              leagueInfo2: league['creation_date'],
              leagueImagePath: league['icon'] ?? Assets.images.icon1,
              leagueTheme: DBHelper().convertStringToPlayerTheme(league['theme']),
              width: screenWidth,
              height: screenHeight,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RankView(leagueId: league['id']),
                ));
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTeamLeaguesList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (teamLeagues.isEmpty) {
      return const Center(child: Text('No team leagues found.', style: TextStyle(color: Color(0xFF006699))));
    }

    return ListView.builder(
      itemCount: teamLeagues.length,
      itemBuilder: (context, index) {
        final league = teamLeagues[index];
        return FutureBuilder<int>(
          future: LeagueDao().countLeagueParticipants(league['id']),
          builder: (context, snapshot) {
            String leagueInfo1;
            if (snapshot.connectionState == ConnectionState.waiting) {
              leagueInfo1 = 'Loading...';
            } else if (snapshot.hasError) {
              leagueInfo1 = 'Error: ${snapshot.error}';
            } else {
              leagueInfo1 = '${snapshot.data} teams';
            }

            return LeagueListContainer(
              leagueName: league['name'],
              leagueInfo1: leagueInfo1,
              leagueInfo2: league['creation_date'],
              leagueImagePath: league['icon'] ?? Assets.images.icon1,
              leagueTheme: DBHelper().convertStringToPlayerTheme(league['theme']),
              width: screenWidth,
              height: screenHeight,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RankView(leagueId: league['id']),
                ));
              },
            );
          },
        );
      },
    );
  }

}


