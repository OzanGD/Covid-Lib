import 'package:shared_preferences/shared_preferences.dart';
import '../constants/globals.dart';

void getLocal() async {
  final prefs = await SharedPreferences.getInstance();
  selectedCountries =
      prefs.getStringList('SelectedCountries') ?? <String>['Turkey', 'Germany'];
  selectedFlags = prefs.getStringList('SelectedFlags') ??
      <String>[
        'https://disease.sh/assets/img/flags/tr.png',
        'https://disease.sh/assets/img/flags/de.png'
      ];
}
