import 'package:flutter/material.dart';

class Release_Client extends StatefulWidget {
  final Function(Map<String, String>)? onSave;
  final Map<String, String>? client;

  const Release_Client({super.key, this.onSave, this.client});
  @override
  _ReleaseClientState createState() => _ReleaseClientState();
}

class _ReleaseClientState extends State<Release_Client> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _representativeController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Si hay un cliente para editar, llenar los campos con sus datos
    if (widget.client != null) {
      _nameController.text = widget.client!['Nombre'] ?? '';
      _representativeController.text = widget.client!['Representante'] ?? '';
      _rfcController.text = widget.client!['RFC'] ?? '';
      _addressController.text = widget.client!['Direccion'] ?? '';
      _phoneController.text = widget.client!['Telefono'] ?? '';
      _emailController.text = widget.client!['Correo Electronico'] ?? '';
    }
  }

  @override
  void dispose() {
    // Limpiar los controladores cuando se destruye el widget
    _nameController.dispose();
    _representativeController.dispose();
    _rfcController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
            buildFormContainer(),
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
          Text(
            widget.client == null ? 'Registro de Clientes' : 'Editar Cliente',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildTextField(_nameController, 'Nombre del Cliente'),
                buildTextField(_representativeController, 'Representante'),
                buildTextField(_rfcController, 'RFC'),
                buildTextField(_addressController, 'Dirección'),
                buildTextField(_phoneController, 'Teléfono'),
                buildTextField(_emailController, 'Correo Electrónico'),
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
                  child: Text(
                    widget.client == null ? 'Agregar' : 'Guardar Cambios',
                    style: const TextStyle(
                      color: Color(0xFF2F2740),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  void submitForm() {
    if (widget.onSave != null) {
      // Validar que los campos no estén vacíos
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _rfcController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, complete todos los campos obligatorios'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final clientData = {
        'Nombre': _nameController.text,
        'Correo Electronico': _emailController.text,
        'Representante': _representativeController.text,
        'RFC': _rfcController.text,
        'Direccion': _addressController.text,
        'Telefono': _phoneController.text,
      };
      
      widget.onSave!(clientData);
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.client == null 
              ? 'Cliente creado exitosamente'
              : 'Cliente actualizado exitosamente'
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Si es un nuevo cliente, limpiar los campos
      if (widget.client == null) {
        _nameController.clear();
        _emailController.clear();
        _representativeController.clear();
        _rfcController.clear();
        _addressController.clear();
        _phoneController.clear();
      } else {
        // Si estamos editando, volver a la pantalla anterior
        Navigator.pop(context);
      }
    }
  }
}