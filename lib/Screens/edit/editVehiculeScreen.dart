import 'package:flutter/material.dart';
import '../Classes/vehicule.dart';
import '../Service/api_service.dart';

class EditVehiculePage extends StatefulWidget {
  final Vehicule vehicule;
  const EditVehiculePage({Key? key, required this.vehicule}) : super(key: key);

  @override
  State<EditVehiculePage> createState() => _EditVehiculePageState();
}

class _EditVehiculePageState extends State<EditVehiculePage> {
  static const Color _primary = Color(0xff1a0a7f);
  static const Color _background = Color(0xfff4f6fb);

  final List<Map<String, dynamic>> _etats = [
    {'id': 1, 'libelle': 'Disponible'},
    {'id': 2, 'libelle': 'En réparation'},
    {'id': 3, 'libelle': 'Accidentée'},
    {'id': 4, 'libelle': 'Indisponible'},
  ];

  late int _selectedIdEtat;
  late String _selectedLibelle;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedIdEtat = widget.vehicule.idEtat;
    _selectedLibelle = widget.vehicule.libelleEtat;
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

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      await ApiService().updateVehiculeEtat(
        widget.vehicule.id,
        _selectedIdEtat,
      );
      final updated = widget.vehicule.copyWith(
        idEtat: _selectedIdEtat,
        libelleEtat: _selectedLibelle,
      );
      if (mounted) Navigator.pop(context, updated);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sauvegarde : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              'SpeedCircuit',
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
              'Modification véhicule',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
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
                        "assets/Vehicule/${widget.vehicule.id}.png",
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.directions_car_rounded,
                          color: _primary.withOpacity(0.4),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vehicule.marque,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.vehicule.modele,
                        style: TextStyle(
                          fontSize: 18,
                          color: _primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),
            Text(
              'Etat du véhicule',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _primary,
              ),
            ),
            SizedBox(height: 12),
            ..._etats.map((etat) {
              final isSelected = etat['id'] == _selectedIdEtat;
              final color = _etatColor(etat['libelle']);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIdEtat = etat['id'];
                    _selectedLibelle = etat['libelle'];
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        etat['libelle'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected ? color : Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: color,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Sauvegarder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
