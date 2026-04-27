import 'package:app_taxi/screens/register_driver_screen.dart';
import 'package:app_taxi/screens/register_taxi_screen.dart';
import 'package:app_taxi/screens/taxi_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_taxi/widgets/menu_grid.dart';
import 'package:app_taxi/widgets/recent_activity.dart';
import 'package:app_taxi/widgets/bottom_nav_bar.dart';
import 'driver_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  /// 🔁 CLAVE: Keys para refrescar tabs
  final GlobalKey<TaxiScreenState> taxiKey = GlobalKey();
  final GlobalKey<DriverScreenState> driverKey = GlobalKey();

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  /// 🔄 REFRESCAR TAB ACTUAL
  void _refreshCurrentTab() {
    if (_selectedIndex == 2) {
      taxiKey.currentState?.fetchTaxis();
    } else if (_selectedIndex == 3) {
      driverKey.currentState?.fetchDrivers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // 🏠 HOME
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  color: const Color(0xFF2E4E73),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenido,',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        widget.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: const [
                        SizedBox(height: 16),
                        MenuGrid(),
                        SizedBox(height: 20),
                        RecentActivity(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 📜 Historial
            const Center(child: Text("Historial")),

            // 🚕 Taxis
            TaxiScreen(key: taxiKey),

            // 👥 Conductores
            DriverScreen(key: driverKey),

            // 👤 Perfil
            const Center(child: Text("Perfil")),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),

      /// 🔥 FAB INTELIGENTE
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF2E4E73),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterTaxiScreen()),
                );

                if (result == true) {
                  _refreshCurrentTab(); // 👈 clave
                }
              },
            )
          : _selectedIndex == 3
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF2E4E73),
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterDriverScreen(),
                  ),
                );

                if (result == true) {
                  _refreshCurrentTab(); // 👈 clave
                }
              },
            )
          : null,
    );
  }
}
