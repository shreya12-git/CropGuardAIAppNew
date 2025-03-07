import 'package:flutter/material.dart';
import 'package:cropguardaiapp2/homepage.dart';
import 'package:cropguardaiapp2/croprecommenderpage.dart';
import 'package:cropguardaiapp2/diseasedetector.dart';
import 'package:weather/weather.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key, required this.title});
  final String title;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String _apiKey = 'f69c4b0de2fbe1ed14638c29cd2ef9c4';
  WeatherFactory? _weatherFactory;
  Weather? _currentWeather;
  String? _cityName;
  int _selectedIndex = 3;

  final List<Widget> _pages = [
    MainHomePage(title: "HomePage"),
    CropRecommenderPage(title: 'CropRecommender Page'),
    DiseaseDetectorPage(title: 'DiseaseDetector Page'),
    WeatherPage(title: 'Weather Page'),
  ];

  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weatherFactory = WeatherFactory(_apiKey);
  }

  Future<void> _fetchWeather(String cityName) async {
    try {
      Weather weather =
          await _weatherFactory!.currentWeatherByCityName(cityName);
      setState(() {
        _currentWeather = weather;
        _cityName = cityName;
      });
    } catch (e) {
      setState(() {
        _currentWeather = null;
        _cityName = cityName;
      });
    }
  }

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF88C431),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(_selectedIndex<3){
              _navigateToPage(_selectedIndex-1);
            }
            else{
              _navigateToPage(0);
            }
             // Navigate back to the previous page
          },
        ),
        title: const Text('CropGuardAI',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/logo.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar with Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search City',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      final searchedCity = _cityController.text.trim();
                      if (searchedCity.isNotEmpty) {
                        _fetchWeather(searchedCity);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2A84F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Weather Information or Initial Prompt
              if (_currentWeather == null) ...[
                Center(
                  child: Text(
                    'Enter the city name to see the weather.',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF375709),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Weather For $_cityName',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Temperature Box
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF5E9),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Temperature',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Color(0xFF375709),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '${_currentWeather!.temperature!.celsius!.toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF375709),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Feels like ${_currentWeather!.tempFeelsLike!.celsius!.toStringAsFixed(1)}°C',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Humidity Box
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF5E9),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Humidity',
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Color(0xFF375709),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '${_currentWeather!.humidity}%',
                                style: const TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF375709),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Humidity is ${_currentWeather!.humidity}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(178, 215, 159, 74),
        selectedItemColor: const Color(0xFF375709),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _navigateToPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco),
            label: 'Crop Recommender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bug_report),
            label: 'Disease Detector',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Weather',
          ),
        ],
      ),
    );
  }
}
