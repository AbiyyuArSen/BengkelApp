import 'dart:io';

void main() {
  final dir = Directory('lib');
  
  // A regex to capture the entire ScaffoldMessenger block
  // We use non-greedy matching `.*?` to stop at the first `);` that closes showSnackBar.
  // This is a heuristic and might need multiple passes or manual checks.
  final regex = RegExp(r'ScaffoldMessenger\.of\(([a-zA-Z0-9_]+)\)\.showSnackBar\(\s*const\s*SnackBar\(content:\s*Text\((.*?)\)(?:,\s*backgroundColor:\s*Colors\.(green|red|orange))?\)\s*,\s*\);', dotAll: true);
  
  // A more robust regex:
  final scaffoldRegex = RegExp(r'ScaffoldMessenger\.of\((.*?)\)\.showSnackBar\(\s*(?:const\s*)?SnackBar\(\s*content:\s*(?:const\s*)?Text\((.*?)\)(?:(?:,\s*backgroundColor:\s*Colors\.(.*?))|(?:.*?))?\s*\)\s*,\s*\);', dotAll: true);

  for (var entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      var content = entity.readAsStringSync();
      if (!content.contains('ScaffoldMessenger.of')) continue;

      // Simplest string replace using a loop:
      bool modified = false;
      
      // We will just do manual replace for the most common patterns to be safe!
      content = content.replaceAllMapped(
        RegExp(r'ScaffoldMessenger\.of\((.*?)\)\.showSnackBar\(\s*(?:const\s*)?SnackBar\(\s*content:\s*(?:const\s*)?Text\((.*?)\)\s*,\s*backgroundColor:\s*Colors\.green(?:,)?\s*\)\s*,\s*\);', dotAll: true),
        (m) {
          modified = true;
          return 'ToastUtils.showSuccess(${m[1]}, ${m[2]});';
        }
      );
      
      content = content.replaceAllMapped(
        RegExp(r'ScaffoldMessenger\.of\((.*?)\)\.showSnackBar\(\s*(?:const\s*)?SnackBar\(\s*content:\s*(?:const\s*)?Text\((.*?)\)\s*,\s*backgroundColor:\s*Colors\.red(?:,)?\s*\)\s*,\s*\);', dotAll: true),
        (m) {
          modified = true;
          return 'ToastUtils.showError(${m[1]}, ${m[2]});';
        }
      );
      
      content = content.replaceAllMapped(
        RegExp(r'ScaffoldMessenger\.of\((.*?)\)\.showSnackBar\(\s*(?:const\s*)?SnackBar\(\s*content:\s*(?:const\s*)?Text\((.*?)\)\s*,\s*backgroundColor:\s*Colors\.orange(?:,)?\s*\)\s*,\s*\);', dotAll: true),
        (m) {
          modified = true;
          return 'ToastUtils.showInfo(${m[1]}, ${m[2]});';
        }
      );
      
      content = content.replaceAllMapped(
        RegExp(r'ScaffoldMessenger\.of\((.*?)\)\.showSnackBar\(\s*(?:const\s*)?SnackBar\(\s*content:\s*(?:const\s*)?Text\((.*?)\)\s*\)\s*,\s*\);', dotAll: true),
        (m) {
          modified = true;
          return 'ToastUtils.showInfo(${m[1]}, ${m[2]});';
        }
      );

      if (modified) {
        // Calculate relative path for import
        final parts = entity.path.split(RegExp(r'[\\/]'));
        final libIndex = parts.indexOf('lib');
        final depth = parts.length - libIndex - 2; // -1 for filename, -1 for lib
        
        String importPrefix = '';
        if (depth == 0) {
          importPrefix = 'core/utils/toast_utils.dart';
        } else {
          importPrefix = '${'../' * depth}core/utils/toast_utils.dart';
        }
        
        final importLine = "import '$importPrefix';\n";
        
        // Add import at the top after the first import block
        if (!content.contains('toast_utils.dart')) {
          final firstImportIndex = content.lastIndexOf(RegExp(r'^import .*?;$', multiLine: true));
          if (firstImportIndex != -1) {
            final insertIndex = content.indexOf('\n', firstImportIndex) + 1;
            content = content.substring(0, insertIndex) + importLine + content.substring(insertIndex);
          } else {
             content = importLine + content;
          }
        }
        
        entity.writeAsStringSync(content);
        print('Updated: ${entity.path}');
      }
    }
  }
}
