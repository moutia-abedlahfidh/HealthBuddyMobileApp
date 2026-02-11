import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthbuddy/kalorienaufnahmen/kalorien_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KalorienController extends ChangeNotifier {
  final Dio _dio = Dio();

  List<Map<String, dynamic>> foods = [];
  

  //List<Product> products = []  ;

  List<Product> selectedFoods =[];

  final String consumerKey = '12cfb651f1754f0d9d60c57342193cfc';
  final String consumerSecret = 'ec995eb6dffe41f7a1b412b2b8c41cc3';
  final String baseUrl = 'https://platform.fatsecret.com/rest/server.api';

  KalorienController() {
    _init();
    // optional: automatically test connection
    //connect();
  }

  void _init() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('selectedFoods');
    selectedFoods = jsonList
      ?.map((e) => Product.fromJson(jsonDecode(e)))
      .toList() ?? [];
      print("selectedFoods = $selectedFoods");
    notifyListeners();
  }

  void addProdukt(BuildContext context,String name,String image) async {
    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$name wurde gewählt ✅"),
                        backgroundColor: Colors.teal,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
    final prefs = await SharedPreferences.getInstance();
    // Load List 
    List<String>? jsonList = prefs.getStringList('selectedFoods');
    selectedFoods = jsonList
      ?.map((e) => Product.fromJson(jsonDecode(e)))
      .toList() ?? [];

    // Add new product
    selectedFoods.add(Product(id: selectedFoods.length + 1 ,name: name,image: image));

    //Save List
    List<String> listselectedasstring =  selectedFoods.map((p) => jsonEncode(p.toJson())).toList();
    prefs.setStringList('selectedFoods',listselectedasstring);
    
    //Navigator.pop(context);
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const KalorienScreen(),
          ),
        );
    notifyListeners();
  }

  
    void toggleSelection(dynamic food,BuildContext context) async{
      final prefs = await SharedPreferences.getInstance();
    if (selectedFoods.contains(food)) {
      selectedFoods.remove(food);
    } else {
      selectedFoods.add(food);
    }
    
    //Save List
    List<String> listselectedasstring =  selectedFoods.map((p) => jsonEncode(p.toJson())).toList();
    prefs.setStringList('selectedFoods',listselectedasstring);
    Navigator.pop(context);
    notifyListeners();
  }
  /// 🔹 Search for a food by name
  Future<void> searchFood(String query) async {
    final params = {
      'method': 'foods.search',
      'search_expression': query,
      'format': 'json',
    };

    final oauthParams = _oauthParams(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
      method: 'GET',
      url: baseUrl,
      params: params,
    );

    print("🔍 Searching for food: $query...");

    try {
      final response = await _dio.get(baseUrl, queryParameters: oauthParams);
      print('✅ Search successful');
      print('📦 Result: ${response.data}');
      // Parse the JSON safely
      final foodList = response.data['foods']?['food'];
      if (foodList is List) {
        foods = List<Map<String, dynamic>>.from(foodList);
      } else if (foodList is Map) {
        foods = [Map<String, dynamic>.from(foodList)];
      } else {
        foods = [];
      }
      notifyListeners();

    } catch (e) {
      foods = [];
      print('❌ Search failed: $e');
    }
  }

  /// 🔹 OAuth1 signature builder
  Map<String, String> _oauthParams({
    required String consumerKey,
    required String consumerSecret,
    required String method,
    required String url,
    required Map<String, String> params,
  }) {
    final oauth = {
      'oauth_consumer_key': consumerKey,
      'oauth_nonce': DateTime.now().microsecondsSinceEpoch.toString(),
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp':
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'oauth_version': '1.0',
    };

    final all = {...params, ...oauth};

    final sorted =
        (all.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    final paramString = sorted.map((e) => '${e.key}=${e.value}').join('&');
    final baseString =
        [method.toUpperCase(), url, paramString].map(Uri.encodeComponent).join('&');

    final key = utf8.encode('$consumerSecret&');
    final hmac = Hmac(sha1, key);
    final digest = hmac.convert(utf8.encode(baseString));
    final signature = base64Encode(digest.bytes);

    return {...all, 'oauth_signature': signature};
  }
}
