import 'dart:io';

void main() {
  final file = File('lib/features/bengkel/views/bengkel_inventory_screen.dart');
  var content = file.readAsStringSync();

  // Fix 1: Add dashboardVM in _showAddEditSparepartDialog
  content = content.replaceFirst(
    'final inventoryVM = statefulCtx.read<BengkelInventoryViewModel>();',
    'final inventoryVM = statefulCtx.read<BengkelInventoryViewModel>();\n          final dashboardVM = statefulCtx.read<BengkelDashboardViewModel>();',
  );

  // Fix 2: Remove the Dark Header block
  final headerStart = content.indexOf('// Dark Header block');
  final headerEnd = content.indexOf('// Title, Search, Filters & Alert');
  
  if (headerStart != -1 && headerEnd != -1) {
    final before = content.substring(0, headerStart);
    final after = content.substring(headerEnd);
    content = before + after;
  }

  file.writeAsStringSync(content);
  print('Done applying fixes to bengkel_inventory_screen.dart');
}
