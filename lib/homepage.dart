import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cropguardaiapp2/croprecommenderpage.dart';
import 'package:cropguardaiapp2/diseasedetector.dart';
import 'package:cropguardaiapp2/weatherpage.dart';
import 'package:cropguardaiapp2/chatbot.dart'; // Create this file for chatbot functionality.
import 'package:weather/weather.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key, required this.title});
  final String title;

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final String _apiKey = '79e506522da81525d14cf96406bfc944';
  WeatherFactory? _weatherFactory;
  Weather? _currentWeather;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MainHomePage(title: "HomePage"),
    CropRecommenderPage(title: 'CropRecommender Page'),
    DiseaseDetectorPage(title: 'DiseaseDetector Page'),
    WeatherPage(title: 'Weather Page'),
  ];

  List<dynamic> _newsArticles = [];
  bool _isLoadingNews = true;

  @override
  void initState() {
    super.initState();
    _weatherFactory = WeatherFactory(_apiKey);
    _fetchWeather();
    _fetchNews();
  }

  Future<void> _fetchWeather() async {
    try {
      Weather weather = await _weatherFactory!.currentWeatherByCityName('Bhopal');
      setState(() {
        _currentWeather = weather;
      });
    } catch (e) {
      setState(() {
        _currentWeather = null;
      });
    }
  }

  Future<void> _fetchNews() async {
    const newsApiUrl =
        'https://newsdata.io/api/1/news?apikey=pub_5667614cf754bd2a4f7ea6a65d7f0a835e78e&q=agriculture&country=in&language=en,hi ';

    try {
      final response = await http.get(Uri.parse(newsApiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _newsArticles = data['results'] ?? [];
          _isLoadingNews = false;
        });
      } else {
        setState(() {
          _isLoadingNews = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingNews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF88C431),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: const AssetImage('assets/logo.png'),
          ),
        ),
        title: const Text(
          'CropGuardAI',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weather Info Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F5D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bhopal, Madhya Pradesh',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentWeather != null &&
                                      _currentWeather!.temperature != null
                                  ? '${_currentWeather!.temperature!.celsius!.toStringAsFixed(1)}°C'
                                  : 'Loading...',
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _currentWeather != null &&
                                      _currentWeather!.weatherDescription != null
                                  ? _currentWeather!.weatherDescription!
                                  : 'Unable to fetch weather',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/weather_icon.png',
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Recent News Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text(
                    'Recent News',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoadingNews
                    ? const Center(child: CircularProgressIndicator())
                    : _newsArticles.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No news articles available.'),
                            ),
                          )
                        : Container(
                            height: 300,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _newsArticles.length,
                              itemBuilder: (context, index) {
                                final article = _newsArticles[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE9F5D9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      article['image_url'] != null
                                          ? ClipRRect(
                                              borderRadius: const BorderRadius.vertical(
                                                  top: Radius.circular(12)),
                                              child: Image.network(
                                                article['image_url'],
                                                height: 150,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 150,
                                              child: Center(
                                                  child: Icon(Icons.image, size: 50)),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          article['title'] ?? 'No title available',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          article['description'] ??
                                              'No description available',
                                          style: const TextStyle(fontSize: 12),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                const SizedBox(height: 40),
                // About Us Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text(
                    'About Us',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: const Text(
                          'CropGuardAI uses cutting-edge AI technology to detect crop diseases, pests, and deficiencies. We provide real-time solutions to help farmers reduce losses, improve crop health, and boost agricultural productivity. Empowering farmers with knowledge, we aim to revolutionize modern farming practices.',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.asset(
                        'assets/slide10.png',
                        width: 150,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating ChatBot Icon
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatBotPage(title: "AgriBot"),
                  ),
                );
              },
              backgroundColor: const Color(0xFF88C431),
              child: const Icon(Icons.chat_bubble, color: Colors.white),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(178, 215, 159, 74),
        selectedItemColor: const Color(0xFF375709),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _pages[index],
            ),
          );
        },
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
