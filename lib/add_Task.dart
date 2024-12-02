import 'package:flutter/material.dart';

class AsignarTareasScreen extends StatefulWidget {
  @override
  _AsignarTareasScreenState createState() => _AsignarTareasScreenState();
}

class _AsignarTareasScreenState extends State<AsignarTareasScreen> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  String prioridadSeleccionada = 'Media';
  String estatusSeleccionado = 'Activo';
  DateTime? fechaLimite;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8470A1),
      
      body: Column(
        children: [
          buildTitle(context),
          buildContentContainer(),
        ],
      ),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo Título
                  buildTextField(tituloController, "Titulo de la tarea"),
                  SizedBox(height: 16.0),

                  // Campo Descripción
                  buildTextField(descripcionController, "Descripcion"),
                  SizedBox(height: 16.0),

                  // Desplegable de Prioridad
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Prioridad",
                      labelStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      
                      filled: true,
                      fillColor:  const Color(0xFF463D5E),
                    ),
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: const Color(0xFF463D5E) ,
                    icon: const Icon(Icons.keyboard_arrow_down), 
                    value: prioridadSeleccionada,
                    items: ['Alta', 'Media', 'Baja']
                        .map((prioridad) => DropdownMenuItem(
                              value: prioridad,
                              child: Text(prioridad, style: TextStyle(
                                color: Colors.white54
                              ) ),
                             
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        prioridadSeleccionada = value!;
                      });
                    },
                    
                  ),
                  SizedBox(height: 16.0),

                  // Selector de Fecha
                  Row(
                    children: [
                      Text(
                        'Fecha Límite:',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        fechaLimite == null
                            ? 'No seleccionada'
                            : '${fechaLimite!.day}/${fechaLimite!.month}/${fechaLimite!.year}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      ElevatedButton(

                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              fechaLimite = pickedDate;
                            });
                          }
                        },
                        child: Text('Seleccionar Fecha',style: TextStyle(color: Color(0xFF2F2740), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),

                  // Botones de Estatus
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['Completadas', 'Cancelado']
                        .map(
                          (estatus) => ChoiceChip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            label: Text(estatus),
                            selected: estatusSeleccionado == estatus,
                            onSelected: (selected) {
                              setState(() {
                                estatusSeleccionado = estatus;
                              });
                            },
                            labelStyle: TextStyle(
                              color: estatusSeleccionado == estatus
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            selectedColor:  const Color(0xFF463D5E),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 16.0),

                  // Botones de Acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Acción de guardar
                          print('Tarea Guardada');
                        },
                        style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                        child: Text('Guardar',style: TextStyle(color: Color(0xFF2F2740), fontWeight: FontWeight.bold),),
                      ),
                      ElevatedButton(
                        
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        
                        child: Text('Cancelar',style: TextStyle(color: Color(0xFF2F2740), fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
        const Text(
          'Asignar Tareas',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 48),
      ],
    ),
  );
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
        ),
      ),
    );
  }
}

