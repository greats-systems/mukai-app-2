class CountryService {
  static Future<List<Country>> getAllCountries() async {
    // Use the hardcodedCountries list
    List<Country> countries = hardcodedCountries;

    // If you want to append additional countries, you can do so
    countries.add(Country(code: 'US', name: 'United States'));
    countries.add(Country(code: 'CA', name: 'Canada'));
    countries.add(Country(code: 'GB', name: 'United Kingdom'));

    // You can also replace or modify existing countries as needed

    // Simulate an asynchronous operation (e.g., fetching data from an API)
    await Future.delayed(const Duration(seconds: 1));

    return countries;
  }
}

class Country {
  final String code;
  final String name;

  Country({required this.code, required this.name});
  // Convert Country instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }

  // Create Country instance from JSON
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}

// Convert a List<Country> to JSON
List<Map<String, dynamic>> countriesListToJson(List<Country> countries) {
  return countries.map((country) => country.toJson()).toList();
}

// Create a List<Country> from JSON
List<Country> countriesListFromJson(List<Map<String, dynamic>> jsonList) {
  return jsonList.map((json) => Country.fromJson(json)).toList();
}

List<Country> hardcodedCountries = [
  Country(code: 'DZ', name: 'Algeria'),
  Country(code: 'AO', name: 'Angola'),
  Country(code: 'BJ', name: 'Benin'),
  Country(code: 'BW', name: 'Botswana'),
  Country(code: 'BF', name: 'Burkina Faso'),
  Country(code: 'BI', name: 'Burundi'),
  Country(code: 'CM', name: 'Cameroon'),
  Country(code: 'CV', name: 'Cape Verde'),
  Country(code: 'CF', name: 'Central African Republic'),
  Country(code: 'TD', name: 'Chad'),
  Country(code: 'KM', name: 'Comoros'),
  Country(code: 'CG', name: 'Congo (Congo-Brazzaville)'),
  Country(code: 'CD', name: 'Congo (Congo-Kinshasa)'),
  Country(code: 'DJ', name: 'Djibouti'),
  Country(code: 'EG', name: 'Egypt'),
  Country(code: 'GQ', name: 'Equatorial Guinea'),
  Country(code: 'ER', name: 'Eritrea'),
  Country(code: 'ET', name: 'Ethiopia'),
  Country(code: 'GA', name: 'Gabon'),
  Country(code: 'GM', name: 'Gambia'),
  Country(code: 'GH', name: 'Ghana'),
  Country(code: 'GN', name: 'Guinea'),
  Country(code: 'GW', name: 'Guinea-Bissau'),
  Country(code: 'CI', name: 'Ivory Coast'),
  Country(code: 'KE', name: 'Kenya'),
  Country(code: 'LS', name: 'Lesotho'),
  Country(code: 'LR', name: 'Liberia'),
  Country(code: 'LY', name: 'Libya'),
  Country(code: 'MG', name: 'Madagascar'),
  Country(code: 'MW', name: 'Malawi'),
  Country(code: 'ML', name: 'Mali'),
  Country(code: 'MR', name: 'Mauritania'),
  Country(code: 'MU', name: 'Mauritius'),
  Country(code: 'MA', name: 'Morocco'),
  Country(code: 'MZ', name: 'Mozambique'),
  Country(code: 'NA', name: 'Namibia'),
  Country(code: 'NE', name: 'Niger'),
  Country(code: 'NG', name: 'Nigeria'),
  Country(code: 'RW', name: 'Rwanda'),
  Country(code: 'ST', name: 'São Tomé and Príncipe'),
  Country(code: 'SN', name: 'Senegal'),
  Country(code: 'SC', name: 'Seychelles'),
  Country(code: 'SL', name: 'Sierra Leone'),
  Country(code: 'SO', name: 'Somalia'),
  Country(code: 'ZA', name: 'South Africa'),
  Country(code: 'SS', name: 'South Sudan'),
  Country(code: 'SD', name: 'Sudan'),
  Country(code: 'SZ', name: 'Eswatini'),
  Country(code: 'TZ', name: 'Tanzania'),
  Country(code: 'TG', name: 'Togo'),
  Country(code: 'TN', name: 'Tunisia'),
  Country(code: 'UG', name: 'Uganda'),
  Country(code: 'ZM', name: 'Zambia'),
  Country(code: 'ZW', name: 'Zimbabwe'),
];
List<String> africanCountries = [
  'Algeria',
  'Angola',
  'Benin',
  'Botswana',
  'Burkina Faso',
  'Burundi',
  'Cameroon',
  'Cape Verde',
  'Central African Republic',
  'Chad',
  'Comoros',
  'Congo (Brazzaville)',
  'Congo (Kinshasa)',
  'Djibouti',
  'Egypt',
  'Equatorial Guinea',
  'Eritrea',
  'Ethiopia',
  'Gabon',
  'Gambia',
  'Ghana',
  'Guinea',
  'Guinea-Bissau',
  'Ivory Coast',
  'Kenya',
  'Lesotho',
  'Liberia',
  'Libya',
  'Madagascar',
  'Malawi',
  'Mali',
  'Mauritania',
  'Mauritius',
  'Morocco',
  'Mozambique',
  'Namibia',
  'Niger',
  'Nigeria',
  'Rwanda',
  'São Tomé and Príncipe',
  'Senegal',
  'Seychelles',
  'Sierra Leone',
  'Somalia',
  'South Africa',
  'South Sudan',
  'Sudan',
  'Eswatini',
  'Tanzania',
  'Togo',
  'Tunisia',
  'Uganda',
  'Zambia',
  'Zimbabwe'
];
// Create this at the class level, not inside the function
final _countryCodeMap = {
  for (var country in hardcodedCountries)
    country.name.toLowerCase(): country.code
};

String getCountryCode(String countryName) {
  // Clean the input
  final cleanedInput =
      countryName.replaceAll(RegExp(r'\([^)]*\)'), '').trim().toLowerCase();

  // Try direct lookup
  return _countryCodeMap[cleanedInput] ??
      // Handle special cases
      switch (cleanedInput) {
        'ivory coast' => 'CI',
        'eswatini' => 'SZ',
        'congo brazzaville' => 'CG',
        'congo kinshasa' => 'CD',
        _ => '', // default if not found
      };
}
