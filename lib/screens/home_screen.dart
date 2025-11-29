import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../data/properties_data.dart';
import '../services/favorites_service.dart';
import 'property_details_screen.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  PropertyType? _selectedType;
  List<Property> _filteredProperties = sampleProperties;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // فلاتر متقدمة
  RangeValues _priceRange = const RangeValues(0, 5000000);
  RangeValues _areaRange = const RangeValues(0, 1000);
  int _minBedrooms = 0;
  int _minBathrooms = 0;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _applyFilters();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterProperties(PropertyType? type) {
    setState(() {
      _selectedType = type;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Property> filtered = sampleProperties;

    // تطبيق فلتر النوع
    if (_selectedType != null) {
      filtered = filtered
          .where((property) => property.type == _selectedType)
          .toList();
    }

    // تطبيق فلتر البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((property) {
        return property.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            property.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            property.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    // تطبيق فلتر السعر
    filtered = filtered.where((property) {
      return property.price >= _priceRange.start &&
          property.price <= _priceRange.end;
    }).toList();

    // تطبيق فلتر المساحة
    filtered = filtered.where((property) {
      return property.area >= _areaRange.start &&
          property.area <= _areaRange.end;
    }).toList();

    // تطبيق فلتر الغرف
    if (_minBedrooms > 0) {
      filtered = filtered.where((property) {
        return property.bedrooms >= _minBedrooms;
      }).toList();
    }

    // تطبيق فلتر الحمامات
    if (_minBathrooms > 0) {
      filtered = filtered.where((property) {
        return property.bathrooms >= _minBathrooms;
      }).toList();
    }

    _filteredProperties = filtered;
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 5000000);
      _areaRange = const RangeValues(0, 1000);
      _minBedrooms = 0;
      _minBathrooms = 0;
      _selectedType = null;
      _searchController.clear();
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 65 : 70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal.shade800,
                Colors.teal.shade600,
                Colors.cyan.shade400,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.shade300.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.business,
                    color: Colors.white,
                    size: isMobile ? 22 : 26,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المكتب العقاري',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 18 : 22,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'شريكك في عالم العقارات',
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              // أيقونة الإشعارات
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('لا توجد إشعارات جديدة'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        iconSize: isMobile ? 22 : 24,
                      ),
                    ),
                    // نقطة الإشعارات
                    Positioned(
                      right: 14,
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Consumer<FavoritesService>(
                  builder: (context, favoritesService, child) {
                    return IconButton(
                      icon: Badge(
                        label: Text(
                          '${favoritesService.favoritesCount}',
                          style: const TextStyle(fontSize: 10),
                        ),
                        isLabelVisible: favoritesService.favoritesCount > 0,
                        backgroundColor: Colors.red.shade600,
                        child: const Icon(Icons.favorite, color: Colors.white),
                      ),
                      onPressed: () {
                        // الانتقال لصفحة المفضلة
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'لديك ${favoritesService.favoritesCount} عقار في المفضلة',
                            ),
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'عرض',
                              textColor: Colors.yellow,
                              onPressed: () {
                                // استخدام المفتاح العام للتنقل إلى صفحة المفضلة (index 1)
                                mainNavigationKey.currentState?.navigateToTab(
                                  1,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      iconSize: isMobile ? 22 : 24,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // شريط البحث
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'ابحث عن عقار، مدينة، أو وصف...',
                hintStyle: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.teal.shade400,
                  size: isMobile ? 22 : 24,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade600,
                          size: isMobile ? 20 : 22,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 25 : 30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 25 : 30),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(isMobile ? 25 : 30),
                  borderSide: BorderSide(color: Colors.teal.shade300, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 12 : 14,
                ),
              ),
            ),
          ),

          // زر الفلاتر المتقدمة
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showFilters = !_showFilters;
                      });
                    },
                    icon: Icon(
                      _showFilters ? Icons.filter_alt_off : Icons.filter_alt,
                      size: isMobile ? 18 : 20,
                    ),
                    label: Text(
                      _showFilters ? 'إخفاء الفلاتر' : 'فلاتر متقدمة',
                      style: TextStyle(fontSize: isMobile ? 14 : 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade50,
                      foregroundColor: Colors.teal.shade700,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 24,
                        vertical: isMobile ? 12 : 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                if (_selectedType != null ||
                    _minBedrooms > 0 ||
                    _minBathrooms > 0) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'إعادة تعيين',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.orange.shade50,
                      foregroundColor: Colors.orange.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // لوحة الفلاتر المتقدمة
          if (_showFilters)
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان القسم
                  Row(
                    children: [
                      Icon(
                        Icons.tune,
                        color: Colors.teal.shade600,
                        size: isMobile ? 22 : 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'الفلاتر المتقدمة',
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // فلتر السعر
                  Text(
                    'السعر (ريال): ${_priceRange.start.toInt().toString()} - ${_priceRange.end.toInt().toString()}',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 5000000,
                    divisions: 50,
                    activeColor: Colors.teal.shade400,
                    inactiveColor: Colors.teal.shade100,
                    labels: RangeLabels(
                      _priceRange.start.toInt().toString(),
                      _priceRange.end.toInt().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _priceRange = values;
                        _applyFilters();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // فلتر المساحة
                  Text(
                    'المساحة (م²): ${_areaRange.start.toInt().toString()} - ${_areaRange.end.toInt().toString()}',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  RangeSlider(
                    values: _areaRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    activeColor: Colors.cyan.shade400,
                    inactiveColor: Colors.cyan.shade100,
                    labels: RangeLabels(
                      _areaRange.start.toInt().toString(),
                      _areaRange.end.toInt().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _areaRange = values;
                        _applyFilters();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // فلتر الغرف والحمامات
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الحد الأدنى للغرف',
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: List.generate(6, (index) {
                                return ChoiceChip(
                                  label: Text('$index'),
                                  selected: _minBedrooms == index,
                                  onSelected: (selected) {
                                    setState(() {
                                      _minBedrooms = index;
                                      _applyFilters();
                                    });
                                  },
                                  selectedColor: Colors.teal.shade400,
                                  backgroundColor: Colors.grey.shade100,
                                  labelStyle: TextStyle(
                                    color: _minBedrooms == index
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontSize: isMobile ? 12 : 13,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الحد الأدنى للحمامات',
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: List.generate(5, (index) {
                                return ChoiceChip(
                                  label: Text('$index'),
                                  selected: _minBathrooms == index,
                                  onSelected: (selected) {
                                    setState(() {
                                      _minBathrooms = index;
                                      _applyFilters();
                                    });
                                  },
                                  selectedColor: Colors.cyan.shade400,
                                  backgroundColor: Colors.grey.shade100,
                                  labelStyle: TextStyle(
                                    color: _minBathrooms == index
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontSize: isMobile ? 12 : 13,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // عدد النتائج
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.teal.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'عدد النتائج: ${_filteredProperties.length}',
                          style: TextStyle(
                            fontSize: isMobile ? 13 : 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // فلاتر نوع العقار مع أنيميشن
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('الكل', null, isMobile),
                  const SizedBox(width: 8),
                  _buildFilterChip('للبيع', PropertyType.sale, isMobile),
                  const SizedBox(width: 8),
                  _buildFilterChip('للإيجار', PropertyType.rent, isMobile),
                  const SizedBox(width: 8),
                  _buildFilterChip('للتمليك', PropertyType.ownership, isMobile),
                ],
              ),
            ),
          ),

          // عدد النتائج مع أنيميشن
          FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.teal.shade400,
                    size: isMobile ? 18 : 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'تم العثور على ${_filteredProperties.length} عقار',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // قائمة العقارات مع أنيميشن
          Expanded(
            child: _filteredProperties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: isMobile ? 60 : 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد عقارات متاحة',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 12 : 16,
                      ),
                      itemCount: _filteredProperties.length,
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          tween: Tween<double>(begin: 0, end: 1),
                          curve: Curves.easeOutCubic,
                          builder: (context, double value, child) {
                            return Transform.translate(
                              offset: Offset(0, 50 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: _buildPropertyCard(
                            _filteredProperties[index],
                            isMobile,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, PropertyType? type, bool isMobile) {
    final isSelected = _selectedType == type;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: isMobile ? 13 : 14,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) => _filterProperties(type),
        backgroundColor: Colors.white,
        selectedColor: Colors.teal,
        checkmarkColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 12,
          vertical: isMobile ? 6 : 8,
        ),
        elevation: isSelected ? 4 : 0,
        shadowColor: Colors.teal.shade200,
      ),
    );
  }

  Widget _buildPropertyCard(Property property, bool isMobile) {
    return Hero(
      tag: 'property-${property.id}',
      child: Card(
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
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PropertyDetailsScreen(property: property),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutCubic;
                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة العقار مع تأثيرات
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isMobile ? 12 : 16),
                ),
                child: Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                          stops: const [0.6, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.darken,
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
                    Positioned(
                      top: isMobile ? 8 : 12,
                      left: isMobile ? 8 : 12,
                      child: Consumer<FavoritesService>(
                        builder: (context, favoritesService, child) {
                          final isFavorite = favoritesService.isFavorite(
                            property.id,
                          );
                          return IconButton(
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
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                                size: 20,
                              ),
                            ),
                            onPressed: () {
                              favoritesService.toggleFavorite(property.id);
                            },
                          );
                        },
                      ),
                    ),
                    // شارات جديدة ومميزة وتقييم
                    Positioned(
                      bottom: isMobile ? 8 : 12,
                      left: isMobile ? 8 : 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (property.isNew)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.new_releases,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'جديد',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (property.isFeatured)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber.shade400,
                                    Colors.orange.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'مميز',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // التقييم في الزاوية اليمنى العلوية
                    if (property.rating != null)
                      Positioned(
                        bottom: isMobile ? 8 : 12,
                        right: isMobile ? 8 : 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber.shade600,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                property.rating!.toStringAsFixed(1),
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // نوع العقار في الأعلى
                    Positioned(
                      top: isMobile ? 8 : 12,
                      right: isMobile ? 8 : 12,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 12,
                          vertical: isMobile ? 5 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor(property.type),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _getTypeColor(
                                property.type,
                              ).withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          property.type.arabicName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 11 : 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                    SizedBox(height: isMobile ? 10 : 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (property.bedrooms > 0) ...[
                          _buildPropertyFeature(
                            Icons.bed,
                            '${property.bedrooms} غرف',
                            isMobile,
                          ),
                        ],
                        if (property.bathrooms > 0) ...[
                          _buildPropertyFeature(
                            Icons.bathroom,
                            '${property.bathrooms} حمام',
                            isMobile,
                          ),
                        ],
                        _buildPropertyFeature(
                          Icons.square_foot,
                          '${property.area.toInt()} م²',
                          isMobile,
                        ),
                      ],
                    ),
                    SizedBox(height: isMobile ? 10 : 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            _formatPrice(property.price, property.type),
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(isMobile ? 6 : 8),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: isMobile ? 14 : 16,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyFeature(IconData icon, String text, bool isMobile) {
    return Row(
      children: [
        Icon(icon, size: isMobile ? 14 : 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: isMobile ? 11 : 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(PropertyType type) {
    switch (type) {
      case PropertyType.sale:
        return Colors.blue;
      case PropertyType.rent:
        return Colors.orange;
      case PropertyType.ownership:
        return Colors.green;
    }
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
