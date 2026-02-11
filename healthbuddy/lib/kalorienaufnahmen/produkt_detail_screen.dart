import 'package:flutter/material.dart';
import 'package:healthbuddy/kalorienaufnahmen/kalorien_controller.dart';
import 'package:provider/provider.dart';

class ProduktDetailScreen extends StatelessWidget {
  final String name;
  final String kalorien;
  final String image;
  final bool isSearch ;

  const ProduktDetailScreen({
    super.key,
    required this.name,
    required this.kalorien,
    required this.image,
    required this.isSearch
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=> KalorienController(),
    child: Consumer<KalorienController>(builder: (context, controller, child) {
      return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFF1F8E9),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product image card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Hero(
                    tag: name,
                    child: Image.asset(
                      image,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Product name
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 12),

                // Calories info
                isSearch==false ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    kalorien,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ) : Container(),

                SizedBox(height: isSearch==false ? 30 : 5),

                // Nutrition info (example placeholder)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Nährwertinformationen",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      isSearch==false ? const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NutrientBox(label: "Fett", value: "30 g"),
                          _NutrientBox(label: "Kohlenhydrate", value: "55 g"),
                          _NutrientBox(label: "Protein", value: "8 g"),
                        ],
                      ) : Center(
                      child: Text(
                        kalorien,
                        style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        ),
                      ),),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // "Wählen" Button
                ElevatedButton.icon(
                  onPressed: () {
                    controller.addProdukt(context,name,image);
                  },
                  icon: const Icon(Icons.check_circle_outline, size: 24),
                  label: const Text(
                    "Wählen",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.tealAccent.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
    },),);}
}

// 📊 Small nutrient box widget
class _NutrientBox extends StatelessWidget {
  final String label;
  final String value;

  const _NutrientBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

