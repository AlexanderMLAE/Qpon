import 'package:flutter/material.dart';

class PrivacyCenterScreen extends StatelessWidget {
  const PrivacyCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Centro de privacidad', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        // White card with privacy text
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Aviso de Privacidad', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('Última actualización: [Fecha actual]'),
                              SizedBox(height: 12),
                              Text('1. Identidad del Responsable'),
                              SizedBox(height: 6),
                              Text('[Nombre de tu Empresa o Tu Nombre Completo] (en adelante, “El Desarrollador”), con domicilio en [Tu Dirección, Estado, etc.] es el responsable del uso y protección de los datos personales que recabamos a través de la aplicación móvil [Nombre de la App] (en adelante, “la Aplicación”).'),
                              SizedBox(height: 8),
                              Text('2. Datos Personales Recabados'),
                              SizedBox(height: 6),
                              Text('Para cumplir con las funcionalidades de la aplicación podemos recabar y tratar los siguientes datos personales:'),
                              SizedBox(height: 6),
                              Text('- Datos de Identificación: Nombre completo, correo electrónico (para creación de cuentas).'),
                              Text('- Datos de Geolocalización: Ubicación precisa u aproximada del dispositivo (solo si el usuario lo permite).'),
                              Text('- Datos de Uso: Historial de ubicaciones, cupones canjeados, opciones seleccionadas, tiendas visitadas.'),
                              SizedBox(height: 8),
                              Text('3. Finalidades del Tratamiento'),
                              SizedBox(height: 6),
                              Text('Las finalidades principales son: prestar el servicio, personalizar ofertas y mejorar la experiencia de usuario.'),
                              SizedBox(height: 8),
                              Text('4. Transferencia de Datos'),
                              SizedBox(height: 6),
                              Text('Los datos que se recaben podrán ser compartidos con terceros proveedores de servicios (p.ej. Firebase, Google Analytics) para funcionamiento de la aplicación.'),
                              SizedBox(height: 8),
                              Text('5. Derechos ARCO'),
                              SizedBox(height: 6),
                              Text('Usted tiene derecho a Acceder, Rectificar, Cancelar u Oponerse al tratamiento de sus datos personales (Derechos ARCO). Para ejercer estos derechos, deberá enviar una solicitud a [Tu correo de Soporte].'),
                              SizedBox(height: 12),
                              Text('6. Cambios al Aviso de Privacidad'),
                              SizedBox(height: 6),
                              Text('El presente aviso podrá actualizarse en cualquier momento; las modificaciones se publicarán en la propia aplicación.'),
                              SizedBox(height: 12),
                              Text('Si desea más información, contáctenos a [Tu correo de Soporte].'),
                              SizedBox(height: 18),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
