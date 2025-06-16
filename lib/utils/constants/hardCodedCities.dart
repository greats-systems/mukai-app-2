class CityService {
  static Future<List<City>> getAllCities() async {
    // You can use the hardcodedCitiesInAfrica list instead of making an API call
    List<City> cities = hardcodedCitiesInAfrica;

    // If you want to simulate an asynchronous operation (e.g., fetching data from an API),
    // you can use Future.delayed as a placeholder
    await Future.delayed(const Duration(seconds: 1));

    return cities;
  }
}



class City {
  final String name;
  final String country;

  City({required this.name, required this.country});
    // Convert City instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
    };
  }

  // Create City instance from JSON
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
      country: json['country'] as String,
    );
  }
}

// Convert a List<City> to JSON
List<Map<String, dynamic>> citiesListToJson(List<City> cities) {
  return cities.map((city) => city.toJson()).toList();
}

// Create a List<City> from JSON
List<City> citiesListFromJson(List<Map<String, dynamic>> jsonList) {
  return jsonList.map((json) => City.fromJson(json)).toList();
}

List<City> hardcodedCitiesInAfrica = [
  City(name: 'Abidjan', country: 'Ivory Coast'),
  City(name: 'Abuja', country: 'Nigeria'),
  City(name: 'Accra', country: 'Ghana'),
  City(name: 'Addis Ababa', country: 'Ethiopia'),
  City(name: 'Algiers', country: 'Algeria'),
  City(name: 'Antananarivo', country: 'Madagascar'),
  City(name: 'Asmara', country: 'Eritrea'),
  City(name: 'Bamako', country: 'Mali'),
  City(name: 'Bangui', country: 'Central African Republic'),
  City(name: 'Banjul', country: 'Gambia'),
  City(name: 'Brazzaville', country: 'Republic of the Congo'),
  City(name: 'Cairo', country: 'Egypt'),
  City(name: 'Cape Town', country: 'South Africa'),
  City(name: 'Casablanca', country: 'Morocco'),
  City(name: 'Dakar', country: 'Senegal'),
  City(name: 'Dar es Salaam', country: 'Tanzania'),
  City(name: 'Djibouti City', country: 'Djibouti'),
  City(name: 'Douala', country: 'Cameroon'),
  City(name: 'Freetown', country: 'Sierra Leone'),
  City(name: 'Gaborone', country: 'Botswana'),
  City(name: 'Harare', country: 'Zimbabwe'),
  City(name: 'Johannesburg', country: 'South Africa'),
  City(name: 'Kampala', country: 'Uganda'),
  City(name: 'Khartoum', country: 'Sudan'),
  City(name: 'Kigali', country: 'Rwanda'),
  City(name: 'Kinshasa', country: 'Democratic Republic of the Congo'),
  City(name: 'Lagos', country: 'Nigeria'),
  City(name: 'Libreville', country: 'Gabon'),
  City(name: 'Lilongwe', country: 'Malawi'),
  City(name: 'Luanda', country: 'Angola'),
  City(name: 'Lusaka', country: 'Zambia'),
  City(name: 'Maputo', country: 'Mozambique'),
  City(name: 'Marrakech', country: 'Morocco'),
  City(name: 'Maseru', country: 'Lesotho'),
  City(name: 'Mbabane', country: 'Eswatini'),
  City(name: 'Mogadishu', country: 'Somalia'),
  City(name: 'Monrovia', country: 'Liberia'),
  City(name: 'Nairobi', country: 'Kenya'),
  City(name: 'Niamey', country: 'Niger'),
  City(name: 'Nouakchott', country: 'Mauritania'),
  City(name: 'Ouagadougou', country: 'Burkina Faso'),
  City(name: 'Port Louis', country: 'Mauritius'),
  City(name: 'Porto-Novo', country: 'Benin'),
  City(name: 'Praia', country: 'Cape Verde'),
  City(name: 'Pretoria', country: 'South Africa'),
  City(name: 'Rabat', country: 'Morocco'),
  City(name: 'Tripoli', country: 'Libya'),
  City(name: 'Tunis', country: 'Tunisia'),
  City(name: 'Victoria', country: 'Seychelles'),
  City(name: 'Windhoek', country: 'Namibia'),
  City(name: 'Yaoundé', country: 'Cameroon'),
];
