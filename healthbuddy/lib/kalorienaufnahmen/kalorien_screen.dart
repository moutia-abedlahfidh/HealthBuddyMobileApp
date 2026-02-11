import 'package:flutter/material.dart';
import 'package:healthbuddy/home/homescreen.dart';
import 'package:healthbuddy/kalorienaufnahmen/kalorien_controller.dart';
import 'package:provider/provider.dart';

import 'produkt_detail_screen.dart';


class KalorienScreen extends StatelessWidget {
  const KalorienScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const gradientColors = [
      Color(0xFFE0F7FA),
      Color(0xFFF1F8E9),
      Color(0xFFFFFFFF),
    ];
    //final controller = Provider.of<KalorienController>(context);
    return ChangeNotifierProvider(
      create: (_) => KalorienController(),
      child: Consumer<KalorienController>(builder: (context, controller, child) {
        return Scaffold(
        extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors, 
            ),
          ),
        ),
        title: const Text(
          "Kalorien Übersicht",
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors, 
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.teal),
              onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Homescreen(),
          ),
        ),
            ),
          ),
        ),
      ),

        body: Builder(builder: (context)  {
          return Container(
          padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors
            )
        ),
        child: Column(
          children: [
            const SizedBox(height: 80,),
            SearchBar(
          leading: const Icon(Icons.search),
          hintText: "Such Kalorien deines Artikels",
          onChanged: (value) {
            controller.searchFood(value);
          },
        ),
      controller.foods.isNotEmpty ? Expanded(
  child: Consumer<KalorienController>(
    builder: (context, controller, _) {
      if (controller.foods.isNotEmpty) {
        return ListView.builder(
          itemCount: controller.foods.length,
          itemBuilder: (context, index) {
            final item = controller.foods[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProduktDetailScreen(
              image: "assests/food_drink_logo.jpg",
              name: item['food_name'], 
              kalorien: item['food_description'],
              isSearch: true,
              ),
          ),
        );
                
              },
              child: Card(
              child: ListTile(
                leading: const Icon(Icons.fastfood, color: Colors.teal),
                title: Text(item['food_name'] ?? ''),
                subtitle: Text(item['food_description'] ?? ''),
              ),
            ),
            );
          },
        );
      }

      return const SizedBox();
    },
  ),
) :
            const SizedBox(height: 20,),
            const Expanded(child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 10,
              children: [
                KardEssen(image: "assests/milka.png",title:"Milka Alpenmilch" ,kalorien: "ca. 539 kcal pro 100 g",),
                KardEssen(image: "assests/mayo.jpg",title:"Mayonnaise" ,kalorien: "ca. 705 kcal pro 100 g",),
                KardEssen(image: "assests/reis.jpg",title:"Basmati Reis" ,kalorien: "ca. 353 kcal pro 100 g",),
                KardEssen(image: "assests/spagetti.jpg",title:"Spaghetti" ,kalorien: "ca. 158 kcal pro 100 g",),
                KardEssen(image: "assests/ketchup.jpg",title:"Ketchup" ,kalorien: " 41 kcal pro 100 ml",),
                KardEssen(image: "assests/kinder_bueno.png",title:"Kinder Bueno" ,kalorien: "ca. 572 kcal pro 100 g",),
                KardEssen(image: "assests/Alpia_Noisette.png",title:"Alpia Noisette" ,kalorien: "ca. 559 kcal pro 100 g",),
                KardEssen(image: "assests/Cookies_Haselnuss.jpg",title:"Cookies Haselnuss" ,kalorien: "ca. 513 kcal pro 100 g",),
                KardEssen(image: "assests/Kinder_crunchy_cookies.jpg",title:"Kinder crunchy cookies" ,kalorien: "ca. 539 kcal pro 100 g",),
              ],
            ),
            ))
          ],
        )
        );
        }),
        floatingActionButton: Consumer<KalorienController>(
  builder: (context, controller, _) => FloatingActionButton(
    backgroundColor: Colors.teal,
    child: const Icon(Icons.shopping_cart),
    onPressed: () {
      if (controller.selectedFoods.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Keine Produkte ausgewählt")),
        );
      } else {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          builder: (_) => Container(
            padding: const EdgeInsets.all(16),
            height: 300,
            child: ListView.builder(
              itemCount: controller.selectedFoods.length,
              itemBuilder: (context, index) {
                final item = controller.selectedFoods[index];
                return ListTile(
                  leading: Image.asset(item.image, width: 40, height: 40),
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      controller.toggleSelection(item,context);
                    },
                  ),
                );
              },
            ),
          ),
        );
      }
    },
  ),
),
      );     },)) ;
  }
}

class KardEssen extends StatelessWidget {
  final String image ;
  final String kalorien ;
  final String title ;
  const KardEssen({super.key,required this.image,required this.title,required this.kalorien});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProduktDetailScreen(
              name: title,
              kalorien: kalorien,
              image: image,
              isSearch: false,
            ),
          ),
        );
      },
      child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 200,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Image.asset(
              image, 
              fit: BoxFit.contain,
              height: 100,
              width: 180,
            ),

           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  kalorien,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String image;

  Product({required this.id, required this.name, required this.image});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );
}

class ProductsPopup extends StatelessWidget {
  final List<Product> products;
  final Function(int id) onDelete;

  const ProductsPopup({
    super.key,
    required this.products,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      child: Column(
        children: [

          /// Title
          const Text(
            "Products",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          /// Product List
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),

                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        product.image,
                        width: 50,
                        height: 50,
                        //fit: BoxFit.cover,
                      ),
                    ),

                    title: Text(product.name),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => onDelete(product.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

