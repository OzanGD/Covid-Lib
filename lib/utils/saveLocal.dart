import 'package:shared_preferences/shared_preferences.dart';
import '../constants/globals.dart';

void saveLocal() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList('selectedCountries', selectedCountries);
  prefs.setStringList('selectedFlags', selectedFlags);
}
