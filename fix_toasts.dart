import 'dart:io';

void main() {
  final dir = Directory('lib');
  for (var entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      var content = entity.readAsStringSync();
      if (!content.contains('ToastUtils')) continue;
      
      bool modified = false;
      var lines = content.split('\n');
      for (int i = 0; i < lines.length; i++) {
        var line = lines[i];
        if (line.contains('ToastUtils.show')) {
          // Remove leftover `)),` if present
          if (line.endsWith(')),')) {
            lines[i] = line.substring(0, line.length - 3) + ');';
            modified = true;
          }
          // Remove leftover `)), backgroundColor: Colors.red),` or similar
          final regex = RegExp(r'\)\),\s*backgroundColor:\s*Colors\.[a-zA-Z]+\s*\),?');
          if (regex.hasMatch(line)) {
             lines[i] = line.replaceAll(regex, ');');
             modified = true;
          }
          
          final regex2 = RegExp(r'\),\s*backgroundColor:\s*Colors\.[a-zA-Z]+\s*\),?');
          if (regex2.hasMatch(line)) {
             lines[i] = line.replaceAll(regex2, ');');
             modified = true;
          }
          
          final regex3 = RegExp(r'\)\)\s*,\s*');
          if (line.endsWith(')),')) {
            lines[i] = line.replaceAll(regex3, ');');
            modified = true;
          }
          
          if (line.endsWith(')),')) {
             lines[i] = line.replaceFirst(')),', ');');
             modified = true;
          }
          
          // Also some might just end with `),` instead of `);`
          // Actually ToastUtils... should end with `;` instead of `,`
          if (line.trim().endsWith('),') && line.contains('ToastUtils.show')) {
             // Let's be careful. It might be inside a list or a lambda.
             // But ToastUtils is void. If it's used inside a function, e.g. onPressed: () => ToastUtils...(),
             // Wait, `=> ToastUtils.show(...)` shouldn't end with `,` unless it's in a list.
             // But it could be `onPressed: () => ToastUtils.show(...),` which is valid Dart!
          }
        }
      }
      
      if (modified) {
        entity.writeAsStringSync(lines.join('\n'));
        print('Fixed: ${entity.path}');
      }
    }
  }
}
