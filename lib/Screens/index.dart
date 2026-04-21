import 'package:flutter/material.dart';
import '../Service/api_service.dart';
import '../Service/auth_service.dart';
import 'evenementScreen.dart';
import 'vehiculeScreen.dart';
import 'reservationScreen.dart';
import '../Screens/compteScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page d\'acceuil',
      theme: ThemeData(primaryColor: Color(0xff1a0a7f)),
      home: Index(),
    );
  }
}

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _Index();
}

class _Index extends State<Index> {
  List<dynamic> info_user = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInformationUser();
  }

  Future<void> _loadInformationUser() async {
    try {
      final data = await ApiService().getCompte();
      setState(() {
        info_user = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'label': 'Evénements', 'icon': Icons.event, 'page': EvenementPage()},
      {
        'label': 'Gestion véhicules',
        'icon': Icons.directions_car,
        'page': VehiculesPage(),
      },
      {
        'label': 'Reservations',
        'icon': Icons.event_available_sharp,
        'page': ReservationPage(),
      },
      {'label': 'Profil', 'icon': Icons.person, 'page': ComptePage()},
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1a0a7f),
        title: Row(
          children: [
            Text(
              'Speed Circuit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 40),
            Text('Accueil', style: TextStyle(color: Colors.white)),
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
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (info_user.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.4),
                      child: Text(
                        'Bienvenue, ${info_user[0]['Prenom']} ${info_user[0]['Nom']}!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1a0a7f),
                        ),
                      ),
                    ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final itemCount = menuItems.length;
                        final rows = (itemCount / 2).ceil();
                        final cardHeight =
                            (constraints.maxHeight - (rows - 1) * 16) / rows;
                        final cardWidth = (constraints.maxWidth - 16) / 2;

                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: cardWidth / cardHeight,
                              ),
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            final item = menuItems[index];
                            return _buildMenuCard(
                              context,
                              label: item['label'],
                              icon: item['icon'],
                              page: item['page'],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget _buildMenuCard(
  BuildContext context, {
  required String label,
  required IconData icon,
  required Widget page,
}) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xff1a0a7f), Color(0xff3a2abf)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
