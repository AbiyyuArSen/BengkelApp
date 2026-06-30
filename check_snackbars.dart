import 'dart:io';

void main() {
  final dir = Directory('lib');
  final regex = RegExp(r'ScaffoldMessenger\.of\(context\)\.showSnackBar\((.*?)\);', dotAll: true);
  int count = 0;
  
  for (var entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      final matches = regex.allMatches(content);
      if (matches.isNotEmpty) {
        print('--- ${entity.path} ---');
        for (var m in matches.take(2)) {
          print(m.group(0));
        }
        count++;
        if (count >= 5) break;
      }
    }
  }
}
