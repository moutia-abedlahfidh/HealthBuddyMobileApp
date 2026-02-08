import 'package:flutter/material.dart';
import 'package:healthbuddy/schafseite/schafcontroller.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Schlafscreen extends StatelessWidget {
  const Schlafscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Sclafcontroller(),
      child: Consumer<Sclafcontroller>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              title: const Text(
                "Schlafübersicht",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE8EDF6),
                    Color(0xFFDFE4ED),
                    Color(0xFFF5F6F6),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: controller.isLoading
                      ? _shimmerPlaceholder()
                      : Column(
                          children: [
                            _SchlafAuszeichnung(
                                value: controller.aufzeichnung),
                            const SizedBox(height: 10),
                            _schlafListe(),
                            const SizedBox(height: 10),
                            _tippContainer(),
                          ],
                        ),
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // SCHLAFLISTE
  // ============================================================

  Widget _schlafListe() {
    return Consumer<Sclafcontroller>(
      builder: (context, controller, _) {
        return _cardWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Schlafstunden der letzten Tage",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: controller.schlafaufzeichnung.length,
                  itemBuilder: (_, index) {
                    final entry = controller.schlafaufzeichnung[index];
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.shade50,
                      child: ListTile(
                        leading:
                            const Icon(Icons.nightlight_round, size: 26),
                        title: Text("${entry['date']}"),
                        trailing: Text(
                          "${entry['duration']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // CARD STYLE WRAPPER
  // ============================================================

  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // SHIMMER
  // ============================================================

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(height: 120, color: Colors.white),
          const SizedBox(height: 20),
          Container(height: 200, color: Colors.white),
          const SizedBox(height: 20),
          Container(height: 80, color: Colors.white),
        ],
      ),
    );
  }

  // ============================================================
  // TIPP
  // ============================================================

  Widget _tippContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F3FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline,
              color: Color(0xFF1A73E8), size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.4),
                children: [
                  TextSpan(
                      text: "Tipp: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "8 Stunden Schlaf passen dir am besten"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SCHLAF BUTTON CARD
// ============================================================

class _SchlafAuszeichnung extends StatelessWidget {
  final bool value;

  const _SchlafAuszeichnung({required this.value});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<Sclafcontroller>();

    final lastSleep = controller.schlafaufzeichnung.isNotEmpty
        ? controller.schlafaufzeichnung.last['duration']
        : "00 h 00 min";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Schlafzeit berechnen",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),

          // GRADIENT BUTTON
          Material(
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                value
                    ? controller.counterstoppen()
                    : controller.counterstarten();
              },
              child: Ink(
                height: 55,
                decoration: BoxDecoration(
                  gradient: value
                      ? const LinearGradient(
                          colors: [Colors.red, Colors.orange])
                      : const LinearGradient(
                          colors: [
                              Color(0xFF3898E6),
                              Color(0xFF6FC3FF)
                            ]),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    value
                        ? "🕒 Schlafzeit stoppen"
                        : "⏰ Schlafzeit starten",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            "Letzter Schlaf: $lastSleep",
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          if (value) const LiveUhr()
        ],
      ),
    );
  }
}

class LiveUhr extends StatelessWidget {
  const LiveUhr({super.key});

  @override
  Widget build(BuildContext context) {
    final laufzeit = context.watch<Sclafcontroller>().laufzeit;

    String two(int n) => n.toString().padLeft(2, '0');

    final h = two(laufzeit.inHours);
    final m = two(laufzeit.inMinutes.remainder(60));
    final s = two(laufzeit.inSeconds.remainder(60));

    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.grey,
      ),
      child: Column(
        children: [
          const Text(
            "Schlaf läuft seit",
            style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "$h : $m : $s",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}