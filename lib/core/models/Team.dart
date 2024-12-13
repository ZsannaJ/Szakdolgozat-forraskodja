
class Team {
  int id;
  String name;
  String theme;
  String league_id;
  int rank;
  double points;
  int win_count;
  int loss_count;
  int? icon;
  int? icon_color;

  // Konstruktor
  Team({
    required this.id,
    required this.name,
    required this.theme,
    required this.league_id,
    required this.rank,
    required this.points,
    required this.win_count,
    required this.loss_count,
    this.icon,
    this.icon_color,

  });


  // Map-ból való létrehozás
  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      id: map['id'],
      name: map['name'],
      theme: map['theme'],
      league_id: map['league_id'],
      rank: map['rank'],
      points: map['points'],
      win_count: map['win_count'],
      loss_count: map['loss_count'],
      icon: map['icon'] ?? 0,
      icon_color: map['icon_color'] ?? 0,
    );
  }

  // Map-ba való konvertálás
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'theme': theme,
      'league_id': league_id,
      'rank': rank,
      'points': points,
      'win_count': win_count,
      'loss_count': loss_count,
      'icon': icon,
      'icon_color': icon_color,
    };
  }


  @override
  String toString() {
    return 'Team(id: $id, name: $name, theme: $theme, icon: $icon, leagueId: $league_id, rank: $rank, points: $points, winCount: $win_count, lossCount: $loss_count)';
  }
}
