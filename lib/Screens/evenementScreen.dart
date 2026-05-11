import 'package:flutter/material.dart';
import '../Service/api_service.dart';
import '../Service/auth_service.dart';
import '../Classes/evenement.dart';

class EvenementPage extends StatefulWidget {
  const EvenementPage({Key? key}) : super(key: key);

  @override
  State<EvenementPage> createState() => _EvenementPageState();
}

class _EvenementPageState extends State<EvenementPage> {
  final ApiService _apiService = ApiService();
  List<Evenement> evenements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  Future<void> _loadEvenements() async {
    try {
      final data = await _apiService.fetchEvenement();
      setState(() {
        evenements = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Erreur de chargement : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Evenements',
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
          : Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            'Evénement',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1a0a7f),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 30,
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1a0a7f),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 30,
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Text(
                            'Prix',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1a0a7f),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color(0xff1a0a7f), thickness: 2, height: 0),
                  SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[400],
                      ),
                      padding: EdgeInsets.all(16),
                      child: ListView.separated(
                        itemCount: evenements.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[400],
                          thickness: 1,
                          height: 16,
                        ),
                        itemBuilder: (context, index) {
                          bool isEven = index % 2 == 0;
                          final Evenement evenement = evenements[index];

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: isEven
                                  ? Color(0xff1a0a7f)
                                  : Color(0xff8b7bb8),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Text(
                                    evenement.libelle,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                Expanded(
                                  child: Text(
                                    '${evenement.dateEvenement.day.toString().padLeft(2, '0')}/'
                                    '${evenement.dateEvenement.month.toString().padLeft(2, '0')}/'
                                    '${evenement.dateEvenement.year}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 30,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                Expanded(
                                  child: Text(
                                    '${evenement.prix.toStringAsFixed(2)} €',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
