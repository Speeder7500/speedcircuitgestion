import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
              'SpeedCircuit Admin',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTableSection(
                    title: 'Toutes les Réservations',
                    icon: Icons.list_alt,
                    color: Color(0xff1a0a7b),
                    reservations: allReservation,
                    emptyMessage: 'Aucune réservations.',
                  ),
                  SizedBox(height: 24),
                  _buildTableSection(
                    title: 'Réservations d\'aujourdh\'hui',
                    icon: Icons.today,
                    color: Color(0xff0077b6),
                    reservations: todayReservation,
                    emptyMessage: 'Aucune réservations pour aujourd\'hui',
                  ),
                  SizedBox(height: 24),
                  _buildTableSection(
                    title: 'Histporique des Réservations',
                    icon: Icons.history,
                    color: Color(0xff6c757d),
                    reservations: pastReservation,
                    emptyMessage: 'Aucune réservations dans l\'historique',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTableSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Reservation> reservations,
    required String emptyMessage,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: color,
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    '${reservations.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (reservations.isEmpty)
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  emptyMessage,
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  color.withOpacity(0.08),
                ),
                columnSpacing: 24,
                columns: [
                  DataColumn(
                    label: Text(
                      'N° Session',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Heure',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Véhicule',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Nom',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Prenom',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
                rows: reservations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final Reservation res = entry.value;
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>(
                      (states) => index.isOdd ? color.withOpacity(0.04) : null,
                    ),
                    cells: [
                      DataCell(
                        Text(
                          res.numSession.toString(),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataCell(Text(res.date)),
                      DataCell(Text(res.heure)),
                      DataCell(Text(res.vehicule)),
                      DataCell(Text(res.nom)),
                      DataCell(Text(res.prenom)),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
