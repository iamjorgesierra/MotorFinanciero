import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motor_financiero/ui/page/principal.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 29, 196),
      body: Container(
        // Fondo rojo
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 43, 29, 196)
                  .withOpacity(0.15), // Rojo con opacidad
              Colors.white.withOpacity(0.6), // Blanco con opacidad
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra el contenido verticalmente
            children: [
              Column(
                children: [
                  const SizedBox(height: 0),
                  Text(
                    "JS FINANCES", // Nombre de la app
                    style: GoogleFonts.varelaRound(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto blanco
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 400),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => const MiPantalla());
                      // Botón para ir al menú
                    },
                    style: ElevatedButton.styleFrom(
                      // ignore: deprecated_member_use
                      foregroundColor: const Color.fromARGB(255, 43, 29, 196),
                      // ignore: deprecated_member_use
                      primary: Colors.white, // Texto rojo
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Bordes redondeados
                      ),
                      fixedSize:
                          const Size(200, 50), // Tamaño fijo de los botones
                    ),
                    child: const Text("EMPEZAR"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
