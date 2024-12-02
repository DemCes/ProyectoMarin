import 'package:flutter/material.dart';

class Release_project extends StatefulWidget {
  const Release_project({super.key});

  @override
  _ReleaseProjectState createState() => _ReleaseProjectState();
}

class _ReleaseProjectState extends State<Release_project> {
 
  String dropdownvalue = 'Cliente 1';  
  String dropdownvalueSupplier = 'Proveedor 1';  
  var items = [    
    'Cliente 1',
    'Cliente 2',
    'Cliente 3',
    'Cliente 4',
    'Cliente 5',
  ];
   var itemsSupp = [    
    'Proveedor 1',
    'Proveedor 2',
    'Proveedor 3',
    'Proveedor 4',
    'Proveedor 5',
  ];
  final TextEditingController _Comments = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8470A1),
      body: SafeArea(
        child: Column(
          children: [
            buildTitle(context),
            buildFormContainer(),
          ],
        ),
      ),
    );
  }

  // Método para el título del formulario
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
          'Alta proyectos',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48),
      ],
    ),
  );
}

  
  Widget buildFormContainer() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2740),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              
             
              const SizedBox(height: 20),
              DropdownButton(
              value: dropdownvalue,
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF463D5E) ,
              icon: const Icon(Icons.keyboard_arrow_down),    
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) { 
                setState(() {
                  dropdownvalue = newValue!;
                },
                
                );
              },
          ),
           const SizedBox(height: 20),
           DropdownButton(
              value: dropdownvalueSupplier,
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF463D5E) ,
              icon: const Icon(Icons.keyboard_arrow_down),    
              items: itemsSupp.map((String itemsSupp) {
                return DropdownMenuItem(
                  value: itemsSupp,
                  child: Text(itemsSupp),
                );
              }).toList(),
              onChanged: (String? newValue) { 
                setState(() {
                  dropdownvalueSupplier = newValue!;
                },
                
                );
              },
          ),
           buildTextField(_Comments, 'Descripcion'),
            const SizedBox(height: 20),
           ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Agregar',
                  style: TextStyle(color: Color(0xFF2F2740), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  


  void submitForm() {
  
    print('Formulario enviado');
  }

  Widget buildTextField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF463D5E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
        ),
      ),
    );
  }


 
}



class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}