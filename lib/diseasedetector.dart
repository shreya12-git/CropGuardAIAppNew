import 'package:cropguardaiapp2/weatherpage.dart';
import 'package:flutter/material.dart';

import 'croprecommenderpage.dart';
import 'homepage.dart';

class DiseaseDetectorPage extends StatefulWidget {
  const DiseaseDetectorPage({super.key, required this.title});
  final String title;

  @override
  State<DiseaseDetectorPage> createState() => _DiseaseDetectorPageState();
}

class _DiseaseDetectorPageState extends State<DiseaseDetectorPage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    MainHomePage(title: "HomePage"),
    CropRecommenderPage(title: 'CropRecommender Page'),
    DiseaseDetectorPage(title: 'DiseaseDetector Page'),
    WeatherPage(title: 'Weather Page'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Disease Detection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF375709)),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/crop_disease.png'), // Replace with your image asset
            ),
            const SizedBox(height: 20),
            const Text(
              'How to use?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload or capture an image of the infected part of your crop directly through the app. Our advanced AI model will analyze the image to predict the disease affecting your crop. For tailored advice and medication suggestions, you can rely on our KrishiBot, your smart agricultural assistant.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Upload image action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(205, 137, 172, 83),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Text('Upload Image', style: TextStyle(fontSize: 16,color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Capture image action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(220, 226, 167, 79),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Text('Capture Image', style: TextStyle(fontSize: 16,color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(178, 215, 159, 74),
        selectedItemColor: const Color(0xFF375709),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          _navigateToPage(index);
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
