import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/see_PJ.dart';
import 'package:flutter_application_1/see_Supplier.dart';
import 'package:flutter_application_1/release_Client.dart';
import 'package:flutter_application_1/release_Supplier.dart';
import 'package:flutter_application_1/disable_Client.dart';
import 'package:flutter_application_1/disable_Supplier.dart';
import 'package:flutter_application_1/see_Projects.dart';
import 'package:flutter_application_1/add_Task.dart';
import 'package:flutter_application_1/release_Project.dart';
import 'package:flutter_application_1/see_Client.dart';
import 'package:flutter_application_1/see_C.dart';
import 'package:flutter_application_1/see_P.dart';
import 'package:flutter_application_1/see_PJ.dart';

class SeeProjects extends StatefulWidget {
  const SeeProjects({super.key});

  @override
  State<SeeProjects> createState() => _SeeProjectsState();
}

class _SeeProjectsState extends State<SeeProjects>  with SingleTickerProviderStateMixin{
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Cambia el número de pestañas según lo que necesites
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
      body: SafeArea(
        child: Column(
          children: [
            buildTitle(context),
            buildTabMenu(),
            Expanded(child: buildTabContent()),
           
          ],
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
          
          const Text(
            'Proyectos',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }


   Widget buildTabMenu() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      tabs: const [
        Tab(text: "Proyectos"),
        Tab(text: 'Crear Proyectos'),
        Tab(text: 'Agregar Tareas'),
      ],
    );
  }

  Widget buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        SeePJ(),
        Release_project(),
        AsignarTareasScreen(),
      ],
    );
  }
    Widget buildContentContainer() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2740),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _searchText.isEmpty ? '' : 'Resultados para "$_searchText"',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}