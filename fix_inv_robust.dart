import 'dart:io';

void main() {
  final file = File('lib/features/bengkel/views/bengkel_inventory_screen.dart');
  var content = file.readAsStringSync();

  // 1. Add dashboardVM
  content = content.replaceFirst(
    'final inventoryVM = statefulCtx.read<BengkelInventoryViewModel>();',
    'final inventoryVM = statefulCtx.read<BengkelInventoryViewModel>();\n          final dashboardVM = statefulCtx.read<BengkelDashboardViewModel>();',
  );
  print('Added dashboardVM');

  // 2. Remove Dark Header
  final headerStart = content.indexOf('// Dark Header block');
  final headerEnd = content.indexOf('// Title, Search, Filters & Alert');
  
  if (headerStart != -1 && headerEnd != -1) {
    final before = content.substring(0, headerStart);
    final after = content.substring(headerEnd);
    content = before + after;
    print('Dark Header removed.');
  }

  // 3. Fix brand grouping logic
  final startMarker = content.indexOf('Belum ada merek kendaraan terdaftar.');
  if (startMarker != -1) {
    final columnStart = content.indexOf(': Column(', startMarker);
    if (columnStart != -1) {
      final columnEnd = content.indexOf(').toList(),', columnStart);
      if (columnEnd != -1) {
        final endMarker = content.indexOf('),', columnEnd + 10);
        
        if (endMarker != -1) {
          final before = content.substring(0, columnStart);
          final after = content.substring(endMarker + 2);
          
          final replacement = ''': Builder(
                        builder: (ctx) {
                          final spec = dashboardVM.specialization.toLowerCase();
                          final bool showMotor = spec.contains('motor') || spec.contains('keduanya');
                          final bool showMobil = spec.contains('mobil') || spec.contains('keduanya');
                          
                          final bothBrands = inventoryVM.allBrands.where((b) => b.type.toLowerCase() == 'keduanya').toList();
                          final motorBrands = inventoryVM.allBrands.where((b) => b.type.toLowerCase() == 'motor').toList();
                          final mobilBrands = inventoryVM.allBrands.where((b) => b.type.toLowerCase() == 'mobil').toList();
                          
                          Widget buildBrandGroup(String title, List<VehicleBrandModel> brands) {
                            if (brands.isEmpty) return const SizedBox();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                ),
                                ...brands.map((brand) {
                                  final isChecked = selectedBrandIds.contains(brand.id);
                                  return CheckboxListTile(
                                    title: Text(brand.name, style: const TextStyle(fontSize: 13)),
                                    value: isChecked,
                                    dense: true,
                                    enabled: !isSaving,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (bool? val) {
                                      setDialogState(() {
                                        if (val == true) {
                                          selectedBrandIds.add(brand.id);
                                        } else {
                                          selectedBrandIds.remove(brand.id);
                                        }
                                      });
                                    },
                                  );
                                }),
                              ],
                            );
                          }
                          
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildBrandGroup('KEDUANYA (UMUM)', bothBrands),
                              if (showMotor) buildBrandGroup('MOTOR', motorBrands),
                              if (showMobil) buildBrandGroup('MOBIL', mobilBrands),
                            ],
                          );
                        }
                      )''';
          
          content = before + replacement + after;
          print('Successfully replaced grouping logic.');
        } else {
          print('endMarker not found');
        }
      } else {
        print('columnEnd not found');
      }
    } else {
      print('columnStart not found');
    }
  } else {
    print('startMarker not found');
  }

  file.writeAsStringSync(content);
}
