import 'dart:io';

void main() {
  final file = File('lib/features/bengkel/views/bengkel_orders_screen.dart');
  var content = file.readAsStringSync();

  // 1. Remove the entire appBar
  final appBarStart = content.indexOf('appBar: AppBar(');
  if (appBarStart != -1) {
    // Find where body starts
    final bodyStart = content.indexOf('body: Column(', appBarStart);
    if (bodyStart != -1) {
      final before = content.substring(0, appBarStart);
      final after = content.substring(bodyStart);
      content = before + after;
    }
  }

  file.writeAsStringSync(content);
  print('Removed AppBar from BengkelOrdersScreen.');
}
