class Reservation {
  final int numSession;
  final DateTime heure;
  final String vehicule;
  final String nom;
  final String prenom;

  Reservation({
    required this.numSession,
    required this.heure,
    required this.vehicule,
    required this.nom,
    required this.prenom,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      numSession: json['IdSession'],
      heure: DateTime.parse(json['DateSession']),
      vehicule: '${json['Marque']} ${json['Modele']}',
      nom: json['Nom'],
      prenom: json['Prenom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdSession': numSession,
      'DateSession': heure.toIso8601String(),
      'vehicule': vehicule,
      'Nom': nom,
      'Prenom': prenom,
    };
  }

  @override
  String toString() =>
      'Reservation{id: $numSession, client: $prenom $nom, vehicule: $vehicule}';
}
