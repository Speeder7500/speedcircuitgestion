import 'package:flutter/material.dart';
import '../Service/api_service.dart';
import '../Service/auth_service.dart';
import '../Classes/reservation.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPage();
}

class _ReservationPage extends State<ReservationPage> {
  final ApiService _apiService = ApiService();
  List<Reservation> allReservation = [];
  List<Reservation> todayReservation = [];
  List<Reservation> pastReservation = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final results = await Future.wait([
        _apiService.fetchAllReservations(),
        _apiService.fetchTodayReservations(),
        _apiService.fetchPastReservations(),
      ]);

      setState(() {
        allReservation = results[0];
        todayReservation = results[1];
        pastReservation = results[2];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur de chargement des réservations : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff4f6fb),
      appBar: AppBar(
        backgroundColor: Color(0xff1a0a7f),
        title: Row(
          children: [
            Text(
              'SpeedCircuit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 12),
            Container(width: 1, height: 20, color: Colors.white30),
            SizedBox(width: 12),
            Text(
              'Reservations',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => AuthService().logout(context),
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start),
            ),
    );
  }
}
