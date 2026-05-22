import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Classes/vehicule.dart';
import '../Classes/evenement.dart';
import '../Classes/reservation.dart';

class ApiService {
  // Quand je suis au lycée
  final String baseUrl = 'http://172.16.195.254:5000';

  //Quand je suis chez moi
  //final String baseUrl = 'http://sio.fenelon-notredame.fr:19522';

  final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login(
    String identifiant,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifiant': identifiant, 'mdp': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Echec de la connexion');
    }
  }

  Future<List<Vehicule>> fetchVehicules() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vehicule'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Vehicule.fromJson(json)).toList();
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur API : $e');
      rethrow;
    }
  }

  Future<void> updateVehiculeEtat(int idVehicule, int idEtat) async {
    final response = await http.put(
      Uri.parse('$baseUrl/vehicule/$idVehicule/etat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'IdEtat': idEtat}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour : ${response.statusCode}');
    }
  }

  Future<Vehicule> addVehicule({
    required String marque,
    required String modele,
    required int puissance,
    required int poid,
    required String motricite,
    required int prix,
    required int idEtat,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/vehicule/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Marque': marque,
        'Modele': modele,
        'Puissance': puissance,
        'Poid': poid,
        'Prix': prix,
        'IdEtat': idEtat,
      }),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return Vehicule.fromJson(body);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Erreur lors de l\'ajout du véhicule');
    }
  }

  Future<List<dynamic>> getCompte() async {
    final String? userId = await _storage.read(key: 'x-user-id');

    final response = await http.get(
      Uri.parse('$baseUrl/compte/pro'),
      headers: {'Content-Type': 'application/json', 'x-user-id': userId ?? ''},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur : ${response.statusCode}');
    }
  }

  Future<List<Evenement>> fetchEvenement() async {
    final response = await http.get(Uri.parse('$baseUrl/evenement'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Evenement.fromJson(json)).toList();
    } else {
      throw Exception('Echec du chargement des evenements');
    }
  }

  Future<List<Reservation>> fetchAllReservations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/toutes-reservations'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Reservation.fromJson(json)).toList();
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur API : $e');
      rethrow;
    }
  }

  Future<List<Reservation>> fetchTodayReservations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/toutes-reservations/today'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Reservation.fromJson(json)).toList();
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur API : $e');
      rethrow;
    }
  }

  Future<List<Reservation>> fetchPastReservations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/toutes-reservations/past'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Reservation.fromJson(json)).toList();
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur API : $e');
      rethrow;
    }
  }

  Future<void> updateCompteInfos({
    required String mail,
    required String identifiant,
  }) async {
    final String? userId = await _storage.read(key: 'x-user-id');

    if (userId == null) throw Exception('Utilisateur non connecté');

    final response = await http.put(
      Uri.parse('$baseUrl/compte/pro/infos'),
      headers: {'Content-Type': 'application/json', 'x-user-id': userId},
      body: jsonEncode({'mail': mail, 'identifiant': identifiant}),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Erreur lors de la mise à jour');
    }
  }

  Future<void> updatePassword({
    required String ancienMotDePasse,
    required String nouveauMotDePasse,
  }) async {
    final String? userId = await _storage.read(key: 'x-user-id');

    if (userId == null) throw Exception('Utilisateur non connecté');

    final response = await http.put(
      Uri.parse('$baseUrl/compte/pro/password'),
      headers: {'Content-Type': 'application/json', 'x-user-id': userId},
      body: jsonEncode({
        'ancienMotDePasse': ancienMotDePasse,
        'nouveauMotDePasse': nouveauMotDePasse,
      }),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(
        body['message'] ?? 'Erreur lors du changement de mot de passe',
      );
    }
  }
}
