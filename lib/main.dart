import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/grades_screen.dart';
import 'screens/news_screen.dart';
import 'screens/contacts_screen.dart';

void main() {
  runApp(const StudentPortalApp());
}

class StudentPortalApp extends StatelessWidget {
  const StudentPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Студенческий портал',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProfileScreen(),
    const ScheduleScreen(),
    const GradesScreen(),
    const NewsScreen(),
    const ContactsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Студенческий портал'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: _screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профилек'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Расписанице'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Оценочки'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Новости'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_phone), label: 'Контактики'),
        ],
      ),
    );
  }
}
