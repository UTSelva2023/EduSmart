// ignore_for_file: prefer_final_fields, avoid_print
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../api/conexion.dart';
import '../constants.dart';

class PerfilEdit extends StatefulWidget {
  const PerfilEdit({
    super.key});

  @override
  State<PerfilEdit> createState() => _PerfilEdiState();
}

class _PerfilEdiState extends State<PerfilEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _appController = TextEditingController();
  TextEditingController _apmController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  bool _alertas = false;
  // ignore: non_constant_identifier_names
  int _id_alumno = 0;
  String matricula="";
  File? _image;
  String foto="";


  bool isLoading = true;
  final Conexion _conexion = Conexion();

  @override
  void initState() {
    super.initState();
    _conexion.getalumnoData();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        //Guardar la URL de la foto actual.
        _id_alumno = _conexion.userData!['id_alumno'];
        matricula = _conexion.userData!['matricula'];
        _correoController.text = _conexion.userData!['correo'];
        _nombreController.text = _conexion.userData!['nombre'];
        _appController.text = _conexion.userData!['app'];
        _apmController.text = _conexion.userData!['apm'];
        _telefonoController.text =_conexion.userData!['telefono'];
        foto = _conexion.userData!["foto"];

      });
    });
  }

  // Función para simular la actualización de datos
  Future<void> _alerta() async {
    setState(() {
      _alertas = true;
    });
    // Esperar unos segundos antes de redirigir al usuario
    // Validación exitosa, enviar la solicitud PUT para actualizar los datos del alumno.
    await _conexion.actualizarDatosAlumno(
        _telefonoController.text,
        _correoController.text,
        _nombreController.text,
        _appController.text,
        _apmController.text,
        _id_alumno,
        context);
        if(_image  != null){
          _conexion.uploadImage(_image!, matricula);
        }else{
         print("No se selecciono ni una foto");
        }
        //Ocultamos el indicador
      setState(() {
        _alertas = false;
      });
  }

  Future<void> _selectAndUploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<PickedFile>(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de la Galería'),
              onTap: () async {
                Navigator.pop(context,
                    // ignore: deprecated_member_use
                    await picker.getImage(source: ImageSource.gallery));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar una Foto'),
              onTap: () async {
                Navigator.pop(
                    // ignore: deprecated_member_use
                    context, await picker.getImage(source: ImageSource.camera));
              },
            ),
          ],
        );
      },
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
    }else {
        _image = File(foto);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _alertas
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(color: azul_oscuro),
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(), // Indicador de carga
                    SizedBox(height: 20),
                    Text(
                      'Actualizando datos...',
                      style: TextStyle(color: blanco, fontFamily: "Poppins"),
                    ), // Mensaje de cierre de sesión
                  ],
                ))
            : Container(
                height: double.infinity,
                decoration: const BoxDecoration(color: azul_oscuro),
                padding: const EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 70.0),
                      _conexion.userData == null
                          ? Visibility(
                              visible:
                                  isLoading, // Muestra el loading cuando isLoading es true
                              child:const Padding(
                                padding: EdgeInsets.symmetric(vertical: 300),
                                child: Center(
                                child:
                                    CircularProgressIndicator(), // Puedes personalizar el loading según tus necesidades
                              ), 
                              )
                              
                            )
                          : Visibility(
                              visible: !isLoading,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,  
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    _image == null
                                    ? Center(child: CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: NetworkImage(
                                          'http://${_conexion.ip}/get-image/${_conexion.userData!['foto']}'), // Replace with your image path
                                    )
                                    ):
                                    Center(
                                      child: CircleAvatar(
                                      radius:60.0 ,
                                      backgroundImage: FileImage(_image!),
                                    )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1, bottom: 1),
                                      child: Center(
                                        child: TextButton(
                                          onPressed: () {
                                            _selectAndUploadPhoto();
                                          },
                                          child: const Text('Cambiar Foto',
                                              style: TextStyle(
                                                color: blanco,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.normal,
                                              )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    //Campo Nombre
                                    const Text(
                                        "Nombre",
                                        style: TextStyle(
                                          color: blanco,
                                          fontWeight: FontWeight.bold,
                                        
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                                      child: TextFormField(
                                          style: const TextStyle(color: blanco),
                                          controller: _nombreController,
                                          keyboardType: TextInputType.name,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Por favor, ingrese su nombre";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: blanco)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: blanco)),
                                          )),
                                    ),
                                    //Campo App
                                    const Text(
                                        "Apellido Paterno",
                                        style: TextStyle(
                                          color: blanco,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                                      child: TextFormField(
                                          controller: _appController,
                                          style: const TextStyle(color: blanco),
                                          keyboardType: TextInputType.name,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Por favor, ingrese su Apellido Paterno";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: blanco)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: blanco)),
                                          )),
                                    ),
                                    //Campo Apm
                                     const Text(
                                        "Apellido Materno",
                                        style: TextStyle(
                                          color: blanco,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                                      child: TextFormField(
                                          controller: _apmController,
                                          style: const TextStyle(color: blanco),
                                          keyboardType: TextInputType.name,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Por favor, ingrese su Apellido Materno";
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: blanco)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: blanco)),
                                          )),
                                    ),
                                    //Campo email
                                    const Text(
                                        "Correo electrónico",
                                        style: TextStyle(
                                            color: blanco,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    
                                    Padding(
                                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                                        child: TextFormField(
                                            cursorColor: blanco,
                                            controller: _correoController,
                                            style:
                                                const TextStyle(color: blanco),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Por favor, ingrese un correo electrónico.";
                                              }
                                              final emailRex = RegExp(
                                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                                  caseSensitive: false,
                                                  multiLine: false);
                                              if (!emailRex.hasMatch(value)) {
                                                return 'Por favor, ingrese un correo electrónico válido';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: blanco)),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: blanco)),
                                            ))),
                                    //Campo Teléfono
                                    const Text(
                                        "Teléfono",
                                        style: TextStyle(
                                            color: blanco,
                                            fontWeight: FontWeight.bold),
                                      ),
                                     Padding(
                                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                                        child: TextFormField(
                                            cursorColor: blanco,
                                            maxLength: 10,
                                            controller: _telefonoController,
                                            style:
                                                const TextStyle(color: blanco),
                                            keyboardType:
                                                TextInputType.phone,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Por favor, ingrese su número de teléfono.";
                                              }else if (value.length < 10) {
                                                return 'Se requiere al menos 10 dígitos.';
                                              }
                                              return null;
                                            },
                                            decoration: const  InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: blanco)),
                                              focusedBorder:
                                                   UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: blanco)),
                                              counterStyle: TextStyle(
                                                color: blanco
                                              )
                                            ))),
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 30, left: 50, right: 50),
                                        height: 80.0,
                                        width: 300.0,
                                        color: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: blanco,
                                                  style: BorderStyle.solid,
                                                  width: 1.0),
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(40.0)),
                                          child: TextButton(
                                            //al precionarlo indicamos la ruta al cual se va diriguir
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                  _alerta();
                                              }
                                            },
                                            child: const Center(
                                              child: Text(
                                                'Guardar',
                                                style: TextStyle(
                                                    color: blanco,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Inter',
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              )),
                    ],
                  ),
                )),
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            color: blanco,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
            Navigator.pop(context);
            },
          ),
        ),
        const Positioned(
            top: 55,
            right: 135,
            child: Text(
              "Editar Perfil",
              style: TextStyle(
                  color: blanco,
                  fontFamily: "Poppins",
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
      ],
    ));
  }
}
