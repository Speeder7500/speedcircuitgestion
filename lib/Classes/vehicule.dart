class Vehicule {
  final int id;
  final String marque;
  final String modele;
  final int idEtat;
  final String libelleEtat;

  Vehicule({
    required this.id,
    required this.marque,
    required this.modele,
    required this.idEtat,
    required this.libelleEtat,
  });

  factory Vehicule.fromJson(Map<String, dynamic> json) {
    return Vehicule(
      id: json['IdVehicule'],
      marque: json['Marque'],
      modele: json['Modele'],
      idEtat: json['IdEtat'],
      libelleEtat: json['libelleEtat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'IdVehicule': id, 'Marque': marque, 'Modele': modele};
  }

  Vehicule copyWith({int? idEtat, String? libelleEtat}) {
    return Vehicule(
      id: id,
      marque: marque,
      modele: modele,
      idEtat: idEtat ?? this.idEtat,
      libelleEtat: libelleEtat ?? this.libelleEtat,
    );
  }

  @override
  String toString() => '$marque $modele';
}
