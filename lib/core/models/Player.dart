

class Player {
  final int id;
  final String name;
  final String theme;
  final String league_id;
  final int points;
  final int rank;
  final int win_count;
  final int loss_count;
  final int? skin_color;
  final int? hair;
  final int? hair_color;
  final int? top;
  final int? top_color;
  final int? beard;
  final int? beard_color;
  final int? glasses;
  final int? glasses_color;

  Player({
    required this.id,
    required this.name,
    required this.theme,
    required this.league_id,
    required this.points,
    required this.rank,
    required this.win_count,
    required this.loss_count,
    this.skin_color,
    this.hair,
    this.hair_color,
    this.top,
    this.top_color,
    this.beard,
    this.beard_color,
    this.glasses,
    this.glasses_color,
  });



  // Map-ból való létrehozás
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      theme: map['theme'],
      league_id: map['league_id'],
      points: map['points'],
      rank: map['rank'],
      win_count: map['win_count'],
      loss_count: map['loss_count'],
      skin_color: map['skin_color'] ?? 0,
      hair: map['hair'] ?? 0,
      hair_color: map['hair_color'] ?? 0,
      top: map['top'] ?? 1,
      top_color: map['top_color'] ?? 3,
      beard: map['beard'] ?? 0,
      beard_color: map['beard_color'] ?? 0,
      glasses: map['glasses'] ?? 0,
      glasses_color: map['glasses_color'] ?? 0,
    );
  }

  // Map-ba való konvertálás
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'theme': theme,
      'league_id': league_id,
      'points': points,
      'rank': rank,
      'win_count': win_count,
      'loss_count': loss_count,
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
  }

  @override
  String toString() {
    return 'Player(id: $id, name: $name, theme: $theme, league_id: $league_id, points: $points, rank: $rank, win_count: $win_count, loss_count: $loss_count)';
  }
}
