import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../services/client_service.dart';

class Release_Client extends StatefulWidget {
  final ClientModel? client;
  final int? clientIndex;

  const Release_Client({
    super.key,
    this.client,
    this.clientIndex,
  });

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
  final ClientService _clientService = ClientService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
    if (widget.client != null) {
      _nameController.text = widget.client!.nombre ?? '';
      _representativeController.text = widget.client!.representante ?? '';
      _rfcController.text = widget.client!.rfc ?? '';
      _addressController.text = widget.client!.direccion ?? '';
      _phoneController.text = widget.client!.telefono ?? '';
      _emailController.text = widget.client!.correoElectronico ?? '';
    }
  }

  Future<void> _initializeService() async {
    try {
      await _clientService.init();
    } catch (e) {
      print('Error inicializando servicio: $e');
    }
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                if (_isLoading)
                  const CircularProgressIndicator()
                else
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

  Future<void> submitForm() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final clientData = ClientModel(
        nombre: _nameController.text,
        correoElectronico: _emailController.text,
        representante: _representativeController.text,
        rfc: _rfcController.text,
        direccion: _addressController.text,
        telefono: _phoneController.text,
        isActive: true,
      );

      if (widget.client == null) {
        await _clientService.addClient(clientData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente agregado exitosamente')),
        );
        _clearForm();
      } else if (widget.clientIndex != null) {
        await _clientService.updateClient(widget.clientIndex!, clientData);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente actualizado exitosamente')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error en submitForm: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _representativeController.clear();
    _rfcController.clear();
    _addressController.clear();
    _phoneController.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _representativeController.dispose();
    _rfcController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}