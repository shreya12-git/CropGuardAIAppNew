import 'package:cropguardaiapp2/diseasedetector.dart';
import 'package:cropguardaiapp2/weatherpage.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class CropRecommenderPage extends StatefulWidget {
  const CropRecommenderPage({super.key, required this.title});
  final String title;

  @override
  State<CropRecommenderPage> createState() => _CropRecommenderPageState();
}

class _CropRecommenderPageState extends State<CropRecommenderPage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const MainHomePage(title: "HomePage"),
    const CropRecommenderPage(title: 'CropRecommender Page'),
    const DiseaseDetectorPage(title: 'DiseaseDetector Page'),
    const WeatherPage(title: 'Weather Page'),
  ];

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
            if (_selectedIndex > 0) {
              _navigateToPage(_selectedIndex - 1);
            } else {
              _navigateToPage(0);
            }
          },
        ),
        title: const Text(
          'CropGuardAI',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
            ),
          ),
        ],
      ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Crop Recommender",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF375709),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    ...[
                      "Nitrogen",
                      "Phosphorus",
                      "Potassium",
                      "Temperature",
                      "Humidity",
                      "pH",
                      "Rainfall"
                    ].map((label) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8, // Center inputs and limit width
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: label,
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: const Color(0xFFF1F8E9),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle generate report logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Generate Report",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Why you should use it?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "CropGuardAI offers personalized farming insights by analyzing soil, nutrients, and weather data. It helps farmers make smarter decisions, boost yields, reduce risks, adopt sustainable practices, and contribute to agricultural and economic growth.",
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/farming_image.png', // Replace with your image asset path
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "How to use it?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter the necessary details and click 'Generate Report' to receive a comprehensive report. It includes ideal crop recommendations, potential failures, and factors like soil quality, nutrients, and weather conditions for informed decision-making.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
