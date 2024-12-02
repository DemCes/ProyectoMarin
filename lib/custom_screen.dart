import 'package:flutter/material.dart';
import 'package:flutter_application_1/see_Supplier.dart';
import 'package:flutter_application_1/release_Client.dart';
import 'package:flutter_application_1/release_Supplier.dart';
import 'package:flutter_application_1/disable_Client.dart';
import 'package:flutter_application_1/disable_Supplier.dart';
import 'package:flutter_application_1/see_Projects.dart';
import 'package:flutter_application_1/add_Task.dart';
import 'package:flutter_application_1/see_Client.dart';

class CustomScreen extends StatefulWidget {
  const CustomScreen({super.key});

  @override
  _CustomScreenState createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8470A1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF2F2740),
        title: const Text(
          "Main",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
          ],
        ),
      ),
      bottomNavigationBar: buildCurvedBottomNavigationBar(),
    );
  }



  Widget buildCurvedBottomNavigationBar() {
    return ClipPath(
      clipper: BottomNavClipper(),
      child: Container(
        color: const Color(0xFF2F2740),
        height: 72,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.person, size: 28),
              ),
              label: 'Clientes',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.group, size: 28),
              ),
              label: 'proveedor',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.book, size: 28),
              ),
              label: 'Proyectos',
            ),
          ],
          onTap: (index) {
            if (index == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SeeClient()));
            } else if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SeeSupplier()));
            }
            else if (index ==2){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>const SeeProjects()));
            }
          },
        ),
      ),
    );
  }
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 20);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(3 * size.width / 4, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



