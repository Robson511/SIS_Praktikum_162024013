/*
Tugas Akhir 2
ISB-311 Sistem Informasi Seluler
Halaman Profil dengan Sidebar dan Tab Interaktif
*/

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTab = 0;

  Widget _actionButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[700],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _tabButton(IconData icon, int index) {
    final bool isActive = _selectedTab == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive ? Colors.black : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Icon(icon, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, {bool selected = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      selected: selected,
      selectedColor: Colors.black,
      selectedTileColor: Colors.grey[400],
      onTap: () {
        _scaffoldKey.currentState!.closeEndDrawer();
        if (!selected) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Menu $title diklik')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _scaffoldKey.currentState!.closeEndDrawer(),
              ),
              const SizedBox(height: 16),
              _menuItem(Icons.person, 'Profile', selected: true),
              _menuItem(Icons.settings, 'Settings'),
              _menuItem(Icons.logout, 'Log Out'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'IlyasK__',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  CircleAvatar(radius: 45, backgroundColor: Colors.grey[700]),
                  const SizedBox(width: 24),
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(count: '3', label: 'Posts'),
                        _StatItem(count: '1234', label: 'Followers'),
                        _StatItem(count: '123', label: 'Following'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _actionButton('Edit Profile'),
                  const SizedBox(width: 12),
                  _actionButton('Share Profile'),
                ],
              ),
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey[700],
                child: const Icon(Icons.add, color: Colors.white),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  _tabButton(Icons.grid_on, 0),
                  _tabButton(Icons.bookmark, 1),
                  _tabButton(Icons.tag, 2),
                ],
              ),
              const SizedBox(height: 8),

              Expanded(
                child: GridView.builder(
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return Container(color: Colors.grey[700]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
