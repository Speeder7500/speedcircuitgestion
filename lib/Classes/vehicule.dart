class Vehicule {
  final int id;
  final String marque;
  final String modele;
  final int puissance;
  final int poid;
  final String motricite;
  final int prix;
  final int idEtat;
  final String libelleEtat;

  Vehicule({
    required this.id,
    required this.marque,
    required this.modele,
    required this.puissance,
    required this.poid,
    required this.motricite,
    required this.prix,
    required this.idEtat,
    required this.libelleEtat,
  });

  factory Vehicule.fromJson(Map<String, dynamic> json) {
    return Vehicule(
      id: json['IdVehicule'],
      marque: json['Marque'],
      modele: json['Modele'],
      puissance: json['Puissance'] ?? 0,
      poid: json['Poid'] ?? 0,
      motricite: json['Motricite'] ?? '',
      prix: json['Prix'],
      idEtat: json['IdEtat'],
      libelleEtat: json['libelleEtat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdVehicule': id,
      'Marque': marque,
      'Modele': modele,
      'Puissance': puissance,
      'Poid': poid,
      'Motricite': motricite,
      'Prix': prix,
      'IdEtat': idEtat,
    };
  }

  Vehicule copyWith({
    int? idEtat,
    String? libelleEtat,
    String? marque,
    String? modele,
    int? puissance,
    int? poid,
    String? motricite,
    int? prix,
  }) {
    return Vehicule(
      id: id,
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      puissance: puissance ?? this.puissance,
      poid: poid ?? this.poid,
      motricite: motricite ?? this.motricite,
      prix: prix ?? this.prix,
      idEtat: idEtat ?? this.idEtat,
      libelleEtat: libelleEtat ?? this.libelleEtat,
    );
  }

  @override
  String toString() => '$marque $modele';
}
