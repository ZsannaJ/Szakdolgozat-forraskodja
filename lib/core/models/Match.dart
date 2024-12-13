
class MatchIndividual {
  int id;
  int player1_id;
  int player2_id;
  int player1_score;
  int player2_score;
  String player1_theme;
  String player2_theme;
  int winner_id;
  DateTime date;
  String league_id;

  // Konstruktor
  MatchIndividual({
    required this.id,
    required this.player1_id,
    required this.player2_id,
    required this.player1_score,
    required this.player2_score,
    required this.player1_theme,
    required this.player2_theme,
    required this.date,
    required this.league_id,
  }) : winner_id = (player1_score > player2_score) ? player1_id : player2_id;

  // A Map-ból való létrehozás
  factory MatchIndividual.fromMap(Map<String, dynamic> map) {
    return MatchIndividual(
      id: map['id'],
      player1_id: map['player1_id'],
      player2_id: map['player2_id'],
      player1_score: map['player1_score'],
      player2_score: map['player2_score'],
      player1_theme: map['player1_theme'],
      player2_theme: map['player2_theme'],
      date: DateTime.parse(map['date']),
      league_id: map['league_id'],
    );
  }

  // A Map-ba való konvertálás
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'player1_id': player1_id,
      'player2_id': player2_id,
      'player1_score': player1_score,
      'player2_score': player2_score,
      'player1_theme': player1_theme,
      'player2_theme': player2_theme,
      'winner_id': winner_id,
      'date': date.toIso8601String(),
      'league_id': league_id,
    };
  }

  @override
  String toString() {
    return 'Individual Match: Player $player1_id vs Player $player2_id, Score: $player1_score-$player2_score, Winner: $winner_id, Date: $date, League: $league_id';
  }
}




class MatchTeam {
  int id;
  int team1_id;
  int team2_id;
  int team1_score;
  int team2_score;
  String team1_theme;
  String team2_theme;
  int winner_id;
  DateTime date;
  String league_id;

  // Konstruktor
  MatchTeam({
    required this.id,
    required this.team1_id,
    required this.team2_id,
    required this.team1_score,
    required this.team2_score,
    required this.team1_theme,
    required this.team2_theme,
    required this.date,
    required this.league_id,
  }) : winner_id = (team1_score > team2_score) ? team1_id : team2_id;

  // A Map-ból való létrehozás
  factory MatchTeam.fromMap(Map<String, dynamic> map) {
    return MatchTeam(
      id: map['id'],
      team1_id: map['team1_id'],
      team2_id: map['team2_id'],
      team1_score: map['team1_score'],
      team2_score: map['team2_score'],
      team1_theme: map['team1_theme'],
      team2_theme: map['team2_theme'],
      date: DateTime.parse(map['date']),
      league_id: map['league_id'],
    );
  }

  // A Map-ba való konvertálás
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'team1_id': team1_id,
      'team2_id': team2_id,
      'team1_score': team1_score,
      'team2_score': team2_score,
      'team1_theme': team1_theme,
      'team2_theme': team2_theme,
      'winner_id': winner_id,
      'date': date.toIso8601String(),
      'league_id': league_id,
    };
  }

  @override
  String toString() {
    return 'Team Match: ID $id, Team $team1_id vs Team $team2_id, Score: $team1_score-$team2_score, Winner: $winner_id, Date: $date, League: $league_id, $team1_theme, $team2_theme';
  }
}
