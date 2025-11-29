// نموذج العقار
class Property {
  final String id;
  final String title;
  final String description;
  final PropertyType type;
  final double price;
  final String location;
  final String city;
  final int bedrooms;
  final int bathrooms;
  final double area; // بالمتر المربع
  final List<String> imageUrls;
  final String contactPhone;
  final String contactName;
  final DateTime datePosted;
  final List<String> features;
  final bool isNew; // جديد
  final bool isFeatured; // مميز
  final double? rating; // التقييم

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.price,
    required this.location,
    required this.city,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.imageUrls,
    required this.contactPhone,
    required this.contactName,
    required this.datePosted,
    required this.features,
    this.isNew = false,
    this.isFeatured = false,
    this.rating,
  });
}

// أنواع العقارات
enum PropertyType {
  sale, // للبيع
  rent, // للإيجار
  ownership, // للتمليك
}

extension PropertyTypeExtension on PropertyType {
  String get arabicName {
    switch (this) {
      case PropertyType.sale:
        return 'للبيع';
      case PropertyType.rent:
        return 'للإيجار';
      case PropertyType.ownership:
        return 'للتمليك';
    }
  }

  String get englishName {
    switch (this) {
      case PropertyType.sale:
        return 'For Sale';
      case PropertyType.rent:
        return 'For Rent';
      case PropertyType.ownership:
        return 'For Ownership';
    }
  }
}
