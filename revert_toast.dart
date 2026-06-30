import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib directory not found!');
    return;
  }

  int modifiedCount = 0;
  // Use multi-line (dotAll) to match multi-line ToastUtils
  final regex = RegExp(r'ToastUtils\.show(Success|Error|Info)\(([^,]+),\s*(.*?)\);', dotAll: true);
  final importRegex1 = RegExp(r"import '.*?toast_utils\.dart';\n?");
  final importRegex2 = RegExp(r"import 'package:toastification/toastification\.dart';\n?");

  for (final file in libDir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      String content = file.readAsStringSync();
      bool modified = false;

      if (content.contains('ToastUtils.show')) {
        content = content.replaceAllMapped(regex, (match) {
          final type = match.group(1)!;
          final ctx = match.group(2)!;
          final msg = match.group(3)!;
          
          String color = 'Colors.blue';
          if (type == 'Success') color = 'Colors.green';
          if (type == 'Error') color = 'Colors.red';

          return 'ScaffoldMessenger.of($ctx).showSnackBar(\n'
                 '  SnackBar(content: Text($msg), backgroundColor: $color),\n'
                 ');';
        });
        modified = true;
      }

      if (content.contains('toast_utils.dart') || content.contains('toastification')) {
        content = content.replaceAll(importRegex1, '');
        content = content.replaceAll(importRegex2, '');
        modified = true;
      }

      if (modified) {
        file.writeAsStringSync(content);
        modifiedCount++;
      }
    }
  }

  print('Modified $modifiedCount files.');
}
