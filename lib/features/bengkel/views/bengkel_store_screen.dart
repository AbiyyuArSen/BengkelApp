import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../viewmodels/bengkel_dashboard_viewmodel.dart';
import 'bengkel_inventory_screen.dart';
import 'bengkel_orders_screen.dart';

class BengkelStoreScreen extends StatefulWidget {
  const BengkelStoreScreen({super.key});

  @override
  State<BengkelStoreScreen> createState() => _BengkelStoreScreenState();
}

class _BengkelStoreScreenState extends State<BengkelStoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardVM = context.watch<BengkelDashboardViewModel>();
    final bengkelName = dashboardVM.bengkelName.isNotEmpty
        ? dashboardVM.bengkelName
        : 'Bengkel Saya';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: const Color(0xFF1E2843),
        elevation: 0,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF2B300), Color(0xFFFF8C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                bengkelName.isNotEmpty ? bengkelName[0].toUpperCase() : 'B',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            bengkelName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFF2B300),
          indicatorWeight: 3,
          labelColor: const Color(0xFFF2B300),
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Inventori'),
            Tab(text: 'Pesanan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BengkelInventoryScreen(),
          BengkelOrdersScreen(),
        ],
      ),
    );
  }
}
