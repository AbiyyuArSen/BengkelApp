import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final res = await http.get(Uri.parse('https://xowudhicrbgjcplvkqnb.supabase.co/rest/v1/vehicle_brands?limit=1'), headers: {'apikey': 'sb_publishable__vbOvduayzWwqbeCY7a87Q_bzVVlXXo'});
  print(res.body);
}
