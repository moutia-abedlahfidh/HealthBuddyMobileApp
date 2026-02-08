import 'package:flutter/material.dart';
import 'package:healthbuddy/settings/Edit/editcontroller.dart';
import 'package:provider/provider.dart';


// --- 3. Datenerfassungs- und Bearbeitungsseite (DataEditScreen) ---

class DataEditScreen extends StatefulWidget {
  const DataEditScreen({super.key});

  @override
  State<DataEditScreen> createState() => _DataEditScreenState();
}

class _DataEditScreenState extends State<DataEditScreen> {
  final _passwordController = TextEditingController(text: "********");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => EditController(),
    child: Consumer<EditController>(builder: (context, controller, child) {
      return Scaffold(
      appBar: AppBar(
        title: const Text("Daten bearbeiten"),
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Persönliche Daten",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 16),

            // Name
            DataEditField(
              label: "Name",
              controller: controller.nameController,
              hint: "Geben Sie Ihren Namen ein",
            ),
            const SizedBox(height: 16),

            // E-Mail
            DataEditField(
              label: "E-Mail",
              controller: controller.emailController,
              hint: "Geben Sie Ihre E-Mail ein",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Passwort
            DataEditField(
              label: "Passwort",
              controller: _passwordController,
              hint: "Geben Sie Ihr Passwort ein",
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Gewicht
            DataEditField(
              label: "Gewicht (kg)",
              controller: controller.weightController,
              hint: "Geben Sie Ihr Gewicht ein",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Größe
            DataEditField(
              label: "Größe (cm)",
              controller: controller.heightController,
              hint: "Geben Sie Ihre Größe ein",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Alter
            DataEditField(
              label: "Alter",
              controller: controller.ageController,
              hint: "Geben Sie Ihr Alter ein",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.changeParameter(context);
                },
                icon: const Icon(Icons.save),
                label: const Text("Daten speichern"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    },),);}
}

// Wiederverwendbares Textfeld-Widget
class DataEditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;

  const DataEditField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// --- Hilfs-Widgets ---

// Platzhalter für andere Seiten in der BottomNavigationBar
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title wird hier bald verfügbar sein!',
        style: TextStyle(fontSize: 24, color: Colors.grey.shade500),
      ),
    );
  }
}



// Widget für die Bearbeitung von Zielen in DataEditScreen
class DataEditCard extends StatelessWidget {
  final String title;
  final String currentValue;
  final IconData icon;
  final String hint;

  const DataEditCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.icon,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "Aktuell: $currentValue",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.indigo, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget für die manuelle Dateneingabe in DataEditScreen
class ManualDataEntryCard extends StatelessWidget {
  final String label;
  final String unit;
  final Color color;

  const ManualDataEntryCard({
    super.key,
    required this.label,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Wert eingeben",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(unit, style: const TextStyle(fontSize: 16, color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Hilfs-Widgets von der GraphikScreen (Unverändert übernommen) ---

// Widget für die Kennzahlen-Karten oben
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget für die Zusammenfassungs-Zeilen
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          unit,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}


 