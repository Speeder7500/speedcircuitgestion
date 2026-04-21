class Evenement {
  final String libelle;
  final DateTime dateEvenement;
  final double prix;

  Evenement({
    required this.libelle,
    required this.dateEvenement,
    required this.prix,
  });

  factory Evenement.fromJson(Map<String, dynamic> json) {
    return Evenement(
      libelle: json['LibelleEvenement'],
      dateEvenement: DateTime.parse(json['DateEvenement']),
      prix: (json['Prix'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Libelle': libelle,
      'DateEvenement': dateEvenement.toIso8601String(),
      'Prix': prix,
    };
  }

  @override
  String toString() =>
      'Evenement{libelle: $libelle, date: $dateEvenement, prix: $prix}';
}
