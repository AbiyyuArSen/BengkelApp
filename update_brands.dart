import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://xowudhicrbgjcplvkqnb.supabase.co/rest/v1/vehicle_brands';
  final headers = {
    'apikey': 'sb_publishable__vbOvduayzWwqbeCY7a87Q_bzVVlXXo',
    'Authorization': 'Bearer sb_publishable__vbOvduayzWwqbeCY7a87Q_bzVVlXXo',
    'Content-Type': 'application/json',
    'Prefer': 'return=minimal'
  };

  // Motor
  final motorBrands = ['Kawasaki', 'Vespa', 'KTM', 'Yamaha'];
  for (var brand in motorBrands) {
    print('Updating $brand to Motor...');
    await http.patch(
      Uri.parse('$url?name=eq.$brand'),
      headers: headers,
      body: jsonEncode({'type': 'Motor'}),
    );
  }

  // Mobil
  final mobilBrands = ['Hyundai', 'Daihatsu', 'xiaomi', 'Toyota', 'Mercedes-Benz', 'Mazda', 'Mitsubishi', 'Wuling'];
  for (var brand in mobilBrands) {
    print('Updating $brand to Mobil...');
    await http.patch(
      Uri.parse('$url?name=eq.$brand'),
      headers: headers,
      body: jsonEncode({'type': 'Mobil'}),
    );
  }

  // Keduanya
  final bothBrands = ['Suzuki', 'BMW', 'Honda'];
  for (var brand in bothBrands) {
    print('Updating $brand to Keduanya...');
    await http.patch(
      Uri.parse('$url?name=eq.$brand'),
      headers: headers,
      body: jsonEncode({'type': 'Keduanya'}),
    );
  }

  print('Done updating vehicle brands!');
}
