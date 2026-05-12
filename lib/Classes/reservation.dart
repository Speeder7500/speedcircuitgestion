class Reservation {
  final int numSession;
  final DateTime date;
  final String heure;
  final String vehicule;
  final String nom;
  final String prenom;

  Reservation({
    required this.numSession,
    required this.date,
    required this.heure,
    required this.vehicule,
    required this.nom,
    required this.prenom,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    final rawDate = json['DateSession'].toString().split('T')[0];
    final parts = rawDate.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );

    final rawHeure = json['HeureReservation'].toString();
    final heureParts = rawHeure.split(':');
    final heure = '${heureParts[0]}:${heureParts[1]}';

    return Reservation(
      numSession: json['NumSession'],
      date: date,
      heure: heure,
      vehicule: '${json['Marque']} ${json['Modele']}',
      nom: json['Nom'],
      prenom: json['Prenom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdSession': numSession,
      'DateSession': date.toIso8601String(),
      'HeureReservation': heure,
      'Vehicule': vehicule,
      'Nom': nom,
      'Prenom': prenom,
    };
  }

  @override
  String toString() =>
      'Reservation{id: $numSession, client: $prenom $nom, vehicule: $vehicule, date: $date, heure: $heure}';
}
