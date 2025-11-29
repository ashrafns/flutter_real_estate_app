import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../data/properties_data.dart';
import '../services/favorites_service.dart';
import 'property_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المفضلة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 18 : 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade400],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: Consumer<FavoritesService>(
        builder: (context, favoritesService, child) {
          final favoriteProperties = favoritesService.getFavoriteProperties(
            sampleProperties,
          );

          if (favoriteProperties.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: isMobile ? 80 : 100,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: isMobile ? 16 : 20),
                  Text(
                    'لا توجد عقارات مفضلة',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  Text(
                    'ابحث عن عقارات وأضفها للمفضلة',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(
              left: isMobile ? 12 : 16,
              right: isMobile ? 12 : 16,
              top: isMobile ? 12 : 16,
              bottom: 100, // مسافة إضافية لتجنب Bottom Bar
            ),
            itemCount: favoriteProperties.length,
            itemBuilder: (context, index) {
              final property = favoriteProperties[index];
              return _buildPropertyCard(
                context,
                property,
                isMobile,
                favoritesService,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPropertyCard(
    BuildContext context,
    Property property,
    bool isMobile,
    FavoritesService favoritesService,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
      elevation: 2,
      shadowColor: Colors.teal.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsScreen(property: property),
            ),
          );
        },
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة العقار
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isMobile ? 12 : 16),
                  ),
                  child: Image.network(
                    property.imageUrls.first,
                    height: isMobile ? 180 : 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: isMobile ? 180 : 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.grey.shade200,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // زر إزالة من المفضلة
                Positioned(
                  top: isMobile ? 8 : 12,
                  left: isMobile ? 8 : 12,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    onPressed: () {
                      favoritesService.toggleFavorite(property.id);
                    },
                  ),
                ),
              ],
            ),
            // معلومات العقار
            Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isMobile ? 6 : 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: isMobile ? 14 : 16,
                        color: Colors.teal.shade400,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.city,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: isMobile ? 13 : 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 8 : 10),
                  Text(
                    _formatPrice(property.price, property.type),
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
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

  String _formatPrice(double price, PropertyType type) {
    if (type == PropertyType.rent) {
      return '${price.toInt()} ريال/شهر';
    } else {
      if (price >= 1000000) {
        return '${(price / 1000000).toStringAsFixed(1)} مليون ريال';
      } else if (price >= 1000) {
        return '${(price / 1000).toInt()} ألف ريال';
      } else {
        return '${price.toInt()} ريال';
      }
    }
  }
}
