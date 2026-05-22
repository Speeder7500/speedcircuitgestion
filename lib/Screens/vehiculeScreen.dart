import 'package:flutter/material.dart';
import '../Service/api_service.dart';
import '../Service/auth_service.dart';
import '../Classes/vehicule.dart';
import 'edit/editVehiculeScreen.dart';
import 'new/newVehiculeScreen.dart';

class VehiculesPage extends StatefulWidget {
  const VehiculesPage({Key? key}) : super(key: key);

  @override
  State<VehiculesPage> createState() => _VehiculesPagesState();
}

class _VehiculesPagesState extends State<VehiculesPage> {
  List<Vehicule> vehicules = [];
  bool _isLoading = true;

  static const Color _primary = Color(0xff1a0a7f);
  static const Color _background = Color(0xfff4f6fb);

  @override
  void initState() {
    super.initState();
    _loadVehicules();
  }

  Future<void> _loadVehicules() async {
    try {
      final data = await ApiService().fetchVehicules();
      setState(() {
        vehicules = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Erreur de chargement des véhicules : $e');
    }
  }

  Color _etatColor(String libelle) {
    switch (libelle.toLowerCase()) {
      case 'disponible':
        return Colors.green;
      case 'en réparation':
        return Colors.orange;
      case 'accidentée':
        return Colors.red;
      case 'indisponible':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'SpeedCircuit Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 12),
            Container(width: 1, height: 20, color: Colors.white30),
            SizedBox(width: 12),
            Text(
              'Véhicules',
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
            icon: Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.push<Vehicule>(
            context,
            MaterialPageRoute(builder: (_) => const NewVehiculeScreen()),
          );
          if (added != null) {
            setState(() => vehicules.add(added));
          }
        },
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Ajouter un nouveau véhciule',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: _primary))
          : vehicules.isEmpty
          ? _buildEmptyState()
          : _buildVehiculeList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'Aucun véhicule trouvé',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehiculeList() {
    return RefreshIndicator(
      color: _primary,
      onRefresh: _loadVehicules,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: vehicules.length,
        itemBuilder: (context, index) {
          return _buildVehiculeCard(vehicules[index]);
        },
      ),
    );
  }

  Widget _buildVehiculeCard(Vehicule vehicule) {
    final etatColor = _etatColor(vehicule.libelleEtat);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/Vehicule/${vehicule.id}.png",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.directions_car_rounded,
                    color: _primary.withOpacity(0.4),
                    size: 28,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicule.marque,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    vehicule.modele,
                    style: TextStyle(
                      fontSize: 16,
                      color: _primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: etatColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: etatColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          vehicule.libelleEtat,
                          style: TextStyle(
                            fontSize: 11,
                            color: etatColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                final updated = await Navigator.push<Vehicule>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditVehiculePage(vehicule: vehicule),
                  ),
                );

                if (updated != null) {
                  setState(() {
                    final index = vehicules.indexWhere(
                      (v) => v.id == updated.id,
                    );
                    if (index != -1) vehicules[index] = updated;
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _primary,
                side: BorderSide(color: _primary.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: Text(
                'Modifier',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
