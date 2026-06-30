import 'dart:io';

void main() {
  final dir = Directory('lib');
  for (var entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      if (!content.contains('ScaffoldMessenger.of')) continue;
      
      String newContent = '';
      int i = 0;
      bool modified = false;
      
      while (i < content.length) {
        int idx = content.indexOf('ScaffoldMessenger.of', i);
        if (idx == -1) {
          newContent += content.substring(i);
          break;
        }
        
        newContent += content.substring(i, idx);
        
        // Find context: ScaffoldMessenger.of(context).showSnackBar(
        int ctxStart = content.indexOf('(', idx);
        int ctxEnd = content.indexOf(')', ctxStart);
        String ctxName = content.substring(ctxStart + 1, ctxEnd);
        
        int showStart = content.indexOf('showSnackBar(', ctxEnd);
        if (showStart == -1) {
           newContent += content.substring(idx, ctxEnd + 1);
           i = ctxEnd + 1;
           continue;
        }
        
        int parenCount = 0;
        int showEnd = -1;
        for (int j = showStart + 12; j < content.length; j++) {
           if (content[j] == '(') parenCount++;
           else if (content[j] == ')') {
              parenCount--;
              if (parenCount == 0) {
                 showEnd = j;
                 break;
              }
           }
        }
        
        if (showEnd != -1) {
           String snackBarContent = content.substring(showStart + 13, showEnd);
           
           // Check if it ends with );
           int afterParen = showEnd + 1;
           while (afterParen < content.length && (content[afterParen] == ' ' || content[afterParen] == '\n' || content[afterParen] == '\r')) {
              afterParen++;
           }
           if (afterParen < content.length && content[afterParen] == ';') {
              showEnd = afterParen;
           }
           
           // We have the full `ScaffoldMessenger.of(context).showSnackBar(...);` (or just `...`)
           // Let's parse the string from snackBarContent.
           // Usually it contains `content: Text('message')` or `Text("message")` or `Text(message)`
           String toastType = 'showInfo';
           if (snackBarContent.contains('Colors.green')) toastType = 'showSuccess';
           if (snackBarContent.contains('Colors.red')) toastType = 'showError';
           
           // Extract text inside Text(...)
           String message = "'Notifikasi'";
           int textStart = snackBarContent.indexOf('Text(');
           if (textStart != -1) {
              int tParen = 0;
              int tEnd = -1;
              for (int k = textStart + 4; k < snackBarContent.length; k++) {
                 if (snackBarContent[k] == '(') tParen++;
                 else if (snackBarContent[k] == ')') {
                    tParen--;
                    if (tParen == 0) {
                       tEnd = k;
                       break;
                    }
                 }
              }
              if (tEnd != -1) {
                 message = snackBarContent.substring(textStart + 5, tEnd);
              }
           }
           
           newContent += 'ToastUtils.$toastType($ctxName, $message)';
           if (content[showEnd] == ';') newContent += ';';
           
           modified = true;
           i = showEnd + 1;
        } else {
           newContent += content.substring(idx, showStart + 12);
           i = showStart + 12;
        }
      }
      
      if (modified) {
        // Add import
        final parts = entity.path.split(RegExp(r'[\\/]'));
        final libIndex = parts.indexOf('lib');
        final depth = parts.length - libIndex - 2;
        String importPrefix = depth == 0 ? 'core/utils/toast_utils.dart' : '${'../' * depth}core/utils/toast_utils.dart';
        String importLine = "import '$importPrefix';\n";
        
        if (!newContent.contains('toast_utils.dart')) {
           final firstImportIndex = newContent.lastIndexOf(RegExp(r'^import .*?;$', multiLine: true));
           if (firstImportIndex != -1) {
              final insertIndex = newContent.indexOf('\n', firstImportIndex) + 1;
              newContent = newContent.substring(0, insertIndex) + importLine + newContent.substring(insertIndex);
           } else {
              newContent = importLine + newContent;
           }
        }
        
        entity.writeAsStringSync(newContent);
        print('Fixed properly: ${entity.path}');
      }
    }
  }
}
