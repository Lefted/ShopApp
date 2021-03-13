import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    // save old value
    final oldValue = isFavorite;

    // optimistic update
    isFavorite = !isFavorite;
    notifyListeners();

    // update product in database
    final url =
        'https://fluttercourse-shopapp-ea455-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';

    final result = await http.patch(url,
        body: json.encode({
          'title': this.title,
          'price': this.price,
          'description': this.description,
          'imageUrl': this.imageUrl,
          'isFavorite': this.isFavorite,
        }));

    if (result.statusCode < 200 || result.statusCode >= 400) {
      // revert back if update failed
      isFavorite = oldValue;
      notifyListeners();

      throw new HttpException('Error updating FavoriteStatus');
    }
  }
}
