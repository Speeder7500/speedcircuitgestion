import 'package:flutter/material.dart';
import 'package:speedcircuitgestion/Service/auth_service.dart';
import '../../Service/api_service.dart';
import '../../Classes/compte.dart';

class EditComptePage extends StatefulWidget {
  final Compte compte;

  const EditComptePage({Key? key, required this.compte}) : super(key: key);

  @override
  State<EditComptePage> createState() => _EditComptePageState();
}

class _EditComptePageState extends State<EditComptePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showPasswordSection = false;

  late final TextEditingController _mailController;
  late final TextEditingController _identifiantController;
  final TextEditingController _ancienMotDePasseController =
      TextEditingController();
  final TextEditingController _nouveauMotDePasseController =
      TextEditingController();
  final TextEditingController _confirmMotDePasseController =
      TextEditingController();

  bool _obscureAncien = true;
  bool _obscureNouveau = true;
  bool _obscureConfrim = true;

  @override
  void initState() {
    super.initState();
    _mailController = TextEditingController(text: widget.compte.mail);
    _identifiantController = TextEditingController(
      text: widget.compte.identifiant,
    );
  }

  @override
  void dispose() {
    _mailController.dispose();
    _identifiantController.dispose();
    _ancienMotDePasseController.dispose();
    _nouveauMotDePasseController.dispose();
    _confirmMotDePasseController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Le mail est requis';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Adresse mail invalide';
    return null;
  }

  String? _validateIdentifiant(String? value) {
    if (value == null || value.trim().isEmpty)
      return "L'identifiant est requis";
    if (value.trim().length < 3) return 'Minimum 3 caractères';
    return null;
  }

  String? _validateNouveauMotDePasse(String? value) {
    if (!_showPasswordSection) return null;
    if (value == null || value.isEmpty)
      return 'Le nouveau mot de passe est requis';
    if (value.length < 12) return 'Minimum 12 caractères';
    if (!RegExp(r'[A-Z]').hasMatch(value))
      return 'Au moins une majuscule requise';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Au moins un chiffre requis';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (!_showPasswordSection) return null;
    if (value != _nouveauMotDePasseController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  String? _validateAncienMotDePasse(String? value) {
    if (!_showPasswordSection) return null;
    if (value == null || value.isEmpty)
      return 'Le mot de passe actuel est requis';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ApiService().updateCompteInfos(
        mail: _mailController.text.trim(),
        identifiant: _identifiantController.text.trim(),
      );

      if (_showPasswordSection) {
        await ApiService().updatePassword(
          ancienMotDePasse: _ancienMotDePasseController.text,
          nouveauMotDePasse: _nouveauMotDePasseController.text,
        );
      }

      if (!mounted) return;
      _showSnackBar('Compte mis à jour avec succès', success: true);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Erreur : $e', success: false);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String messgae, {required bool success}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_outline : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(messgae)),
          ],
        ),
        backgroundColor: success
            ? const Color(0xff2e7d32)
            : const Color(0xffc62828),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        backgroundColor: const Color(0xff1a0a7f),
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
            SizedBox(width: 40),
            Text(
              'Modification du compte',
              style: TextStyle(color: Colors.white),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: const Color(0xff1a0a7f),
                  child: Text(
                    '${widget.compte.prenom.isNotEmpty ? widget.compte.prenom[0].toUpperCase() : ''}'
                    '${widget.compte.nom.isNotEmpty ? widget.compte.nom[0].toUpperCase() : ''}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  '${widget.compte.prenom} ${widget.compte.nom.toLowerCase()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1a0a7f),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Informations du comtpe'),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _mailController,
                label: 'Adresse mail',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _identifiantController,
                label: 'Identifiant',
                icon: Icons.account_circle_outlined,
                validator: _validateIdentifiant,
              ),
              const SizedBox(height: 14),

              InkWell(
                onTap: () => setState(
                  () => _showPasswordSection = !_showPasswordSection,
                ),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _showPasswordSection
                          ? const Color(0xff1a0a7f)
                          : const Color(0xffe0e0e0),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: _showPasswordSection
                            ? const Color(0xff1a0a7f)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Modifier le mot de passe',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1a1a2e),
                          ),
                        ),
                      ),
                      Icon(
                        _showPasswordSection
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                child: _showPasswordSection
                    ? Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            controller: _ancienMotDePasseController,
                            label: 'Mot de passe actuel',
                            obscure: _obscureAncien,
                            onToggle: () => setState(
                              () => _obscureAncien = !_obscureAncien,
                            ),
                            validator: _validateAncienMotDePasse,
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            controller: _nouveauMotDePasseController,
                            label: 'Nouveau mot de passe',
                            obscure: _obscureNouveau,
                            onToggle: () => setState(
                              () => _obscureNouveau = !_obscureNouveau,
                            ),
                            validator: _validateNouveauMotDePasse,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 8),
                          _PasswordStrengthBar(
                            password: _nouveauMotDePasseController.text,
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            controller: _confirmMotDePasseController,
                            label: 'Confirmer le mot de passe',
                            obscure: _obscureConfrim,
                            onToggle: () => setState(
                              () => _obscureConfrim = !_obscureConfrim,
                            ),
                            validator: _validateConfirm,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1a0a7f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Enregistrer les modifications',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xff1a0a7f)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1a0a7f),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff1a0a7f),
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff1a0a7f), size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffe0e0e0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xff0e0e0e)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xff1a0a7f), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffc62828)),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xff1a0a7f),
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffe0e0e0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffe0e0e0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xff1a0a7f), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffc62828)),
        ),
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  final String password;

  const _PasswordStrengthBar({required this.password});

  int get _stength {
    int score = 0;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$&*-]').hasMatch(password)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final labels = ['Faible', 'Moyen', 'Bon', 'Fort'];
    final colors = [
      const Color(0xffc62828),
      const Color(0xffe65100),
      const Color(0xff2e7d32),
      const Color(0xff1b5e20),
    ];
    final s = (_stength - 1).clamp(0, 3);

    return Row(
      children: [
        ...List.generate(4, (i) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              height: 4,
              decoration: BoxDecoration(
                color: i <= s ? colors[s] : const Color(0xffe0e0e0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          labels[s],
          style: TextStyle(
            fontSize: 12,
            color: colors[s],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
