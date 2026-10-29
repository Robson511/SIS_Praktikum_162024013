/*
Nama : Wibi Raouf Sutama
NRP  : 162024013

Challenge Week 3
*/

import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warung IS',
      theme: ThemeData(primarySwatch: Colors.blue), // ThemeData
      home: SplashScreen(),
    ); // MaterialApp
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToNavigateToHome();
  }

  _goToNavigateToHome() async {
    await Future.delayed(Duration(seconds: 4));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // MaterialPageRoute
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/cafe.png'),
          width: 150,
          height: 150,
        ), // Image
      ), // Center
    ); // Scaffold
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> foodlist = [
    'Kopi Kenangan Mantan',
    'Americano',
    'Rasberry',
    'Oatside Kopi',
  ];

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Welcome')), // AppBar
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cari Minuman',
              ), // InputDecoration
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ), // TextField
          ), // Padding
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: foodlist
                  .where((food) => food.toLowerCase().contains(searchText))
                  .map((food) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ), // BoxDecoration
                      child: ListTile(
                        leading: Icon(Icons.food_bank_rounded),
                        title: Text(food, style: TextStyle(fontSize: 20)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DrinkDetailPage(drinkName: food),
                                  ),
                                );
                              },
                              child: Text('Detail'),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _showConfirmationDialog(context, food);
                              },
                              child: Text(
                                'Pesan',
                                style: TextStyle(fontSize: 16),
                              ),
                            ), // ElevatedButton
                          ],
                        ),
                      ), // ListTile
                    ); // Container
                  })
                  .toList(),
            ), // ListView
          ), // Expanded
        ],
      ), // Column
    ); // Scaffold
  }

  void _showConfirmationDialog(BuildContext context, String foodName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Pesanan'),
          content: Text('Apakah Anda yakin ingin memesan $foodName?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ), // TextButton
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessDialog(context, foodName);
              },
            ), // TextButton
          ],
        ); // AlertDialog
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String foodName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesanan Berhasil'),
          content: Text('Anda telah memesan $foodName.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ), // TextButton
          ],
        ); // AlertDialog
      },
    );
  }
}

// Drink Detail Page
class DrinkDetailPage extends StatefulWidget {
  final String drinkName;

  const DrinkDetailPage({super.key, required this.drinkName});

  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  int jumlah = 1;

  void tambahJumlah() {
    setState(() {
      jumlah++;
    });
  }

  void kurangiJumlah() {
    if (jumlah > 1) {
      setState(() {
        jumlah--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.drinkName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.coffee, size: 60, color: Colors.brown),
                    SizedBox(height: 8),
                    Text(
                      widget.drinkName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Jumlah:', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: kurangiJumlah,
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  iconSize: 32,
                ),
                Text(
                  '$jumlah',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: tambahJumlah,
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  iconSize: 32,
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showOrderDialog(context);
              },
              child: Text('Tambah Pesanan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesanan Berhasil'),
          content: Text(
            'Anda telah memesan ${widget.drinkName} sebanyak $jumlah cup',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
