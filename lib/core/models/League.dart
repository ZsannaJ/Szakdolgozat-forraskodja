
import 'package:ranker/core/constants/enums.dart';

// Egyéni liga osztálya
class IndividualLeague {
  final String id;
  final String name;
  final String password;
  final double? beta;
  final PlayerTheme theme;
  final String icon;
  final DateTime creationDate;
  final String description;

  // Konstruktor
  IndividualLeague({
    required this.id,
    required this.name,
    required this.password,
    this.beta,
    required this.theme,
    required this.icon,
    required this.creationDate,
    required this.description,
  });

  // A ligától való adatbeviteli map konvertálás
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'beta' : beta,
      'theme': theme.toString(),
      'icon': icon,
      'creation_date': creationDate.toIso8601String(),
      'description': description,
    };
  }

  // Map konvertálás a liga példányára
  factory IndividualLeague.fromMap(Map<String, dynamic> map) {
    return IndividualLeague(
      id: map['id'],
      name: map['name'],
      password: map['password'],
      beta: map['beta'] ?? 0,
      theme: PlayerTheme.values.firstWhere((e) => e.toString() == map['theme']),
      icon: map['icon'],
      creationDate: DateTime.parse(map['creation_date']),
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Individual League: $name, Created on: $creationDate, Description: $description';
  }
}


// Csapat liga osztálya
class TeamLeague {
  final String id;
  final String name;
  final String password;
  final double? beta;
  final PlayerTheme theme;
  final String icon;
  final DateTime creationDate;
  final String description;

  // Konstruktor
  TeamLeague({
    required this.id,
    required this.name,
    required this.password,
    this.beta,
    required this.theme,
    required this.icon,
    required this.creationDate,
    required this.description,r
  });

  // A ligától való adatbeviteli map konvertálás
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'beta' : beta,
      'theme': theme.toString(),
      'icon': icon,
      'creation_date': creationDate.toIso8601String(),
      'description': description,
    };
  }

  // Map konvertálás a liga példányára
  factory TeamLeague.fromMap(Map<String, dynamic> map) {
    return TeamLeague(
      id: map['id'],
      name: map['name'],
      password: map['password'],
      beta: map['beta'] ?? 0,
      theme: PlayerTheme.values.firstWhere((e) => e.toString() == map['theme']),
      icon: map['icon'],
      creationDate: DateTime.parse(map['creation_date']),
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Team League: $name, Created on: $creationDate, Description: $description';
  }
}

