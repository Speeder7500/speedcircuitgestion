import 'package:flutter/material.dart';
import '../Service/api_service.dart';
import '../Service/auth_service.dart';
import '../Classes/compte.dart';
import 'edit/editCompteScreen.dart';

class ComptePage extends StatefulWidget {
  const ComptePage({Key? key}) : super(key: key);

  @override
  State<ComptePage> createState() => _ComptePageState();
}

class _ComptePageState extends State<ComptePage> {
  Compte? compte;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCompte();
  }

  Future<void> _loadCompte() async {
    try {
      final data = await ApiService().getCompte();
      setState(() {
        if (data.isNotEmpty) {
          compte = Compte.fromJson(data[0] as Map<String, dynamic>);
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de chargement du compte : $e';
        isLoading = false;
      });
    }
  }

  Future<void> _navigationEdit() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditComptePage(compte: compte!)),
    );
    if (updated == true) {
      setState(() => isLoading = true);
      await _loadCompte();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4f6fb),
      appBar: AppBar(
        backgroundColor: const Color(0xff1a0a7f),
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
              'Mon compte',
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
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            )
          : compte == null
          ? const Center(
              child: Text(
                'Aucune information de compte disponible.',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: const Color(0xff1a0a7f),
                    child: Text(
                      '${compte!.prenom.isNotEmpty ? compte!.prenom[0].toUpperCase() : ''}'
                      '${compte!.nom.isNotEmpty ? compte!.nom[0].toUpperCase() : ''}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${compte!.prenom} ${compte!.nom.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1a0a7f),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    compte!.identifiant,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Information du compte',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1a0a7f),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: _navigationEdit,
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: Color(0xff1a0a7f),
                                ),
                                label: const Text(
                                  'Modifier',
                                  style: TextStyle(
                                    color: Color(0xff1a0a7f),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xff1a0a7f,
                                  ).withOpacity(0.08),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            color: const Color(0xff1a0a7f).withOpacity(0.2),
                            thickness: 1,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: Icons.person,
                            label: 'Prénom',
                            value: compte!.prenom,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            icon: Icons.badge,
                            label: 'Nom',
                            value: compte!.nom,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            icon: Icons.mail,
                            label: 'Mail',
                            value: compte!.mail,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            icon: Icons.account_circle,
                            label: 'Identifiant',
                            value: compte!.identifiant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xff1a0a7f).withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xff1a0a7f), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff1a1a2e),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
