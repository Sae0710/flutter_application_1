import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _openNewWindow(String title, String dataType) async {
    final window = await DesktopMultiWindow.createWindow(
      jsonEncode({'dataType': dataType, 'title': title}),
    );

    window
      ..setFrame(const Offset(100, 100) & const Size(800, 600))
      ..center()
      ..setTitle(title)
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pink Up - Panel de Administración')),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (index) {},
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                Icons.business_center,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Principal'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Ajustes'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.5,
                children: [
                  _buildDashboardCard(
                    context,
                    title: 'Consultar Clientes',
                    icon: Icons.people,
                    onTap: () =>
                        _openNewWindow('Consulta de Clientes', 'Clientes'),
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Consultar Empleados',
                    icon: Icons.badge,
                    onTap: () =>
                        _openNewWindow('Consulta de Empleados', 'Empleados'),
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Ver Artículos (Inventario)',
                    icon: Icons.inventory_2,
                    onTap: () =>
                        _openNewWindow('Inventario de Artículos', 'Articulos'),
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Historial de Pedidos',
                    icon: Icons.receipt_long,
                    onTap: () =>
                        _openNewWindow('Historial de Pedidos', 'Pedidos'),
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Gestión de Envíos',
                    icon: Icons.local_shipping,
                    onTap: () => _openNewWindow('Gestión de Envíos', 'Envios'),
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Proveedores',
                    icon: Icons.store,
                    onTap: () =>
                        _openNewWindow('Lista de Proveedores', 'Proveedores'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
