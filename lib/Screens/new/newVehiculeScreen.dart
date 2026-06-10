import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Service/api_service.dart';
import '../../Classes/vehicule.dart';
import '../vehiculeScreen.dart';

class NewVehiculeScreen extends StatefulWidget {
  const NewVehiculeScreen({Key? key}) : super(key: key);

  @override
  State<NewVehiculeScreen> createState() => _NewVehiculePageState();
}

class _NewVehiculePageState extends State<NewVehiculeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _puissanceController = TextEditingController();
  final _poidController = TextEditingController();
  final _prixController = TextEditingController();

  String? _motriciteSelectionnee;
  int _idEtat = 1;
  bool _isLoading = false;

  static const Color _primary = Color(0xff1a0a7f);
  static const Color _background = Color(0xfff4f6fb);

  static const List<String> _motricites = ['4', '2', '1'];

  static const List<Map<String, dynamic>> _etats = [
    {'id': 1, 'libelle': 'Disponible'},
    {'id': 2, 'libelle': 'En réparation'},
    {'id': 3, 'libelle': 'Accidentée'},
    {'id': 4, 'libelle': 'Indisponible'},
  ];

  @override
  void dispose() {
    _marqueController.dispose();
    _modeleController.dispose();
    _puissanceController.dispose();
    _poidController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  Future<void> _soumettre() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final nouveauVehicule = await _apiService.addVehicule(
        marque: _marqueController.text.trim(),
        modele: _modeleController.text.trim(),
        puissance: int.parse(_puissanceController.text.trim()),
        poid: int.parse(_poidController.text.trim()),
        motricite: _motriciteSelectionnee!,
        prix: int.parse(_prixController.text.trim()),
        idEtat: _idEtat,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Véhicule ajouté avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, nouveauVehicule);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              'SpeedCircuit Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 20, color: Colors.white30),
            const SizedBox(width: 12),
            const Text(
              'Nouveau véhicule',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Identification', [
                _buildTextField(
                  controller: _marqueController,
                  label: 'Marque',
                  hint: 'ex: Renault',
                  icon: Icons.directions_car_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _modeleController,
                  label: 'Modèle',
                  hint: 'ex: Clio',
                  icon: Icons.car_repair_outlined,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Caractéristiques techniques', [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _puissanceController,
                        label: 'Puissance (ch)',
                        hint: 'ex: 130',
                        icon: Icons.speed_outlined,
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requis';
                          if (int.tryParse(v.trim()) == null) return 'Invalide';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _poidController,
                        label: 'Poids (kg)',
                        hint: 'ex: 1250',
                        icon: Icons.fitness_center_outlined,
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Requis';
                          if (int.tryParse(v.trim()) == null) return 'Invalide';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildDropdown<String>(
                  value: _motriciteSelectionnee,
                  label: 'Motricité',
                  icon: Icons.settings_outlined,
                  items: _motricites
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setState(() => _motriciteSelectionnee = v),
                  validator: (v) =>
                      v == null ? 'Veuillez sélectionner une motricité' : null,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Informations commerciales', [
                _buildTextField(
                  controller: _prixController,
                  label: 'Prix (€)',
                  hint: 'ex: 22900',
                  icon: Icons.euro_outlined,
                  inputType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Champ requis';
                    if (double.tryParse(v.trim().replaceAll(',', '.')) ==
                        null) {
                      return 'Prix invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _buildDropdown<int>(
                  value: _idEtat,
                  label: 'État initial',
                  icon: Icons.info_outline,
                  items: _etats
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e['id'] as int,
                          child: Text(e['libelle'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _idEtat = v!),
                ),
              ]),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _soumettre,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(
                    _isLoading ? 'Enregistrement...' : 'Ajouter le véhicule',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String titre, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _primary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: _primary.withOpacity(0.6)),
        filled: true,
        fillColor: _background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String label,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _primary.withOpacity(0.6)),
        filled: true,
        fillColor: _background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
