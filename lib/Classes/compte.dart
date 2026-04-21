class Compte {
  final String mail;
  final String nom;
  final String prenom;
  final String identifiant;

  Compte({
    required this.mail,
    required this.nom,
    required this.prenom,
    required this.identifiant,
  });

  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
      mail: json['Mail']?.toString() ?? '',
      nom: json['Nom']?.toString() ?? '',
      prenom: json['Prenom']?.toString() ?? '',
      identifiant: json['Identifiant']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Mail': mail,
      'Nom': nom,
      'Prenom': prenom,
      'Identifiant': identifiant,
    };
  }

  @override
  String toString() =>
      'Compte{nom: $nom, prenom: $prenom, mail: $mail, identifiant: $identifiant}';
}
