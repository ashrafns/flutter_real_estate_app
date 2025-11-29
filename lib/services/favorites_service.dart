import 'package:flutter/foundation.dart';
import '../models/property.dart';

class FavoritesService extends ChangeNotifier {
  final List<String> _favoriteIds = [];

  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);

  bool isFavorite(String propertyId) {
    return _favoriteIds.contains(propertyId);
  }

  void toggleFavorite(String propertyId) {
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
    } else {
      _favoriteIds.add(propertyId);
    }
    notifyListeners();
  }

  List<Property> getFavoriteProperties(List<Property> allProperties) {
    return allProperties
        .where((property) => _favoriteIds.contains(property.id))
        .toList();
  }

  int get favoritesCount => _favoriteIds.length;
}
