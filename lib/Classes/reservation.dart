import 'package:intl/intl.dart';

class Reservation {
  final int numSession;
  final String date;
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
    /*final rawDate = json['DateReservation'].toString().split('T')[0];
    final parts = rawDate.split('-');
    final date = DateFormat('dd/MM/yyyy').format(
      DateTime.utc(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      ),
    );*/

    return Reservation(
      numSession: json['IdSession'],
      date: json['DateReservation'],
      heure: json['HeureReservation'],
      vehicule: '${json['Marque']} ${json['Modele']}',
      nom: json['Nom'],
      prenom: json['Prenom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdSession': numSession,
      'DateReservation': date,
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
