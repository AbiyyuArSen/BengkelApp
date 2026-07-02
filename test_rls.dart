import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xowudhicrbgjcplvkqnb.supabase.co',
    anonKey: 'sb_publishable__vbOvduayzWwqbeCY7a87Q_bzVVlXXo',
  );
  
  final client = Supabase.instance.client;
  
  try {
    final res = await client.from('bengkels').select().limit(1);
    if (res.isNotEmpty) {
       print('SUCCESS. Keys: ${res[0].keys}');
    } else {
       print('SUCCESS but table is empty');
    }
  } catch (e) {
    print('ERROR: $e');
  }
}
