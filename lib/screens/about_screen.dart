import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // نظام ألوان موحد للتناسق
  static const primaryColor = Color(0xFF00897B); // Teal 600
  static const secondaryColor = Color(0xFF26C6DA); // Cyan 400
  static const accentColor = Color(0xFFFF6F00); // Orange 900
  static const cardBackground = Colors.white;
  static const textDark = Color(0xFF263238);
  static const textLight = Color(0xFF546E7A);

  // مسافات موحدة
  static const double sectionSpacing = 32.0;
  static const double cardSpacing = 16.0;
  static const double cardPadding = 24.0;
  static const double borderRadiusValue = 20.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // رأس الصفحة - تصميم نظيف وبسيط
          SliverAppBar(
            expandedHeight: isMobile ? 200 : 250,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'من نحن',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 20 : 24,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.business,
                    size: isMobile ? 80 : 100,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
            ),
          ),

          // المحتوى الرئيسي
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // قسم الإحصائيات
                    _buildStatisticsSection(isMobile),

                    const SizedBox(height: sectionSpacing),

                    // قسم من نحن
                    _buildAboutSection(isMobile),

                    const SizedBox(height: sectionSpacing),

                    // قسم الرؤية والرسالة
                    _buildVisionMissionSection(isMobile),

                    const SizedBox(height: sectionSpacing),

                    // قسم الخدمات
                    _buildServicesSection(isMobile),

                    const SizedBox(height: sectionSpacing),

                    // قسم الفريق
                    _buildTeamSection(isMobile),

                    const SizedBox(height: sectionSpacing),

                    // قسم التواصل
                    _buildContactSection(isMobile),

                    // مسافة إضافية كبيرة لتجنب إخفاء المحتوى خلف Bottom Navigation Bar
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة عنوان القسم - تصميم موحد
  Widget _buildSectionHeader(String title, IconData icon, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryColor, size: isMobile ? 24 : 28),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 22 : 28,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
      ],
    );
  }

  // قسم الإحصائيات
  Widget _buildStatisticsSection(bool isMobile) {
    final stats = [
      {
        'value': '+500',
        'label': 'عقار',
        'icon': Icons.home_work,
        'color': primaryColor,
      },
      {
        'value': '+1200',
        'label': 'عميل',
        'icon': Icons.people,
        'color': secondaryColor,
      },
      {
        'value': '15+',
        'label': 'سنة خبرة',
        'icon': Icons.access_time,
        'color': accentColor,
      },
      {
        'value': '%95',
        'label': 'رضا العملاء',
        'icon': Icons.star,
        'color': Colors.amber,
      },
    ];

    return Column(
      children: [
        _buildSectionHeader('إحصائياتنا', Icons.assessment, isMobile),
        const SizedBox(height: 24),
        Wrap(
          spacing: cardSpacing,
          runSpacing: cardSpacing,
          alignment: WrapAlignment.center,
          children: stats.map((stat) {
            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: isMobile
                        ? (MediaQuery.of(context).size.width - 48) / 2
                        : 150,
                    padding: const EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(borderRadiusValue),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (stat['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            stat['icon'] as IconData,
                            color: stat['color'] as Color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          stat['value'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            color: stat['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat['label'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            color: textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // قسم من نحن
  Widget _buildAboutSection(bool isMobile) {
    return Column(
      children: [
        _buildSectionHeader('قصتنا', Icons.auto_stories, isMobile),
        const SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(isMobile ? 20 : 32),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(borderRadiusValue),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مكتب العقارات المتميز',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'تأسس مكتبنا في عام 2010 برؤية واضحة: أن نكون الخيار الأول للعملاء في مجال العقارات. على مدار أكثر من 15 عاماً، نجحنا في بناء سمعة قوية قائمة على الثقة والمصداقية والاحترافية.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 17,
                  height: 1.8,
                  color: textLight,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                'نفخر بتقديم خدمات عقارية متكاملة تشمل البيع، الشراء، الإيجار، والاستثمار العقاري. فريقنا المتخصص يعمل بجد لضمان تحقيق أهداف عملائنا وتقديم تجربة استثنائية في كل مرحلة.',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 17,
                  height: 1.8,
                  color: textLight,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // قسم الرؤية والرسالة
  Widget _buildVisionMissionSection(bool isMobile) {
    return Column(
      children: [
        _buildSectionHeader('رؤيتنا ورسالتنا', Icons.visibility, isMobile),
        const SizedBox(height: 24),
        Wrap(
          spacing: cardSpacing,
          runSpacing: cardSpacing,
          alignment: WrapAlignment.center,
          children: [
            // بطاقة الرؤية
            _buildVisionMissionCard(
              title: 'رؤيتنا',
              icon: Icons.visibility,
              color: primaryColor,
              content:
                  'أن نكون الرواد في مجال الخدمات العقارية، ونساهم في تطوير القطاع العقاري من خلال تقديم حلول مبتكرة ومتميزة.',
              isMobile: isMobile,
            ),
            // بطاقة الرسالة
            _buildVisionMissionCard(
              title: 'رسالتنا',
              icon: Icons.track_changes,
              color: accentColor,
              content:
                  'تقديم خدمات عقارية عالية الجودة تتميز بالشفافية والمهنية، وبناء علاقات طويلة الأمد مع عملائنا تقوم على الثقة والنزاهة.',
              isMobile: isMobile,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisionMissionCard({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
    required bool isMobile,
  }) {
    return Container(
      width: isMobile ? double.infinity : 350,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: isMobile ? 15 : 16,
              height: 1.8,
              color: textLight,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  // قسم الخدمات
  Widget _buildServicesSection(bool isMobile) {
    final services = [
      {
        'title': 'بيع العقارات',
        'icon': Icons.sell,
        'color': primaryColor,
        'description': 'نساعدك في بيع عقارك بأفضل سعر وفي أقصر وقت ممكن',
      },
      {
        'title': 'تأجير العقارات',
        'icon': Icons.vpn_key,
        'color': secondaryColor,
        'description': 'خدمات تأجير شاملة للعقارات السكنية والتجارية',
      },
      {
        'title': 'التمليك',
        'icon': Icons.house,
        'color': accentColor,
        'description': 'حلول تمليك مرنة وميسرة لتحقيق حلم امتلاك المنزل',
      },
      {
        'title': 'الاستشارات',
        'icon': Icons.business_center,
        'color': Colors.purple,
        'description': 'استشارات عقارية متخصصة لمساعدتك في اتخاذ القرار الصحيح',
      },
    ];

    return Column(
      children: [
        _buildSectionHeader('خدماتنا', Icons.room_service, isMobile),
        const SizedBox(height: 24),
        Wrap(
          spacing: cardSpacing,
          runSpacing: cardSpacing,
          alignment: WrapAlignment.center,
          children: services.map((service) {
            return Container(
              width: isMobile ? double.infinity : 280,
              padding: EdgeInsets.all(isMobile ? 20 : 24),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(borderRadiusValue),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (service['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      service['icon'] as IconData,
                      color: service['color'] as Color,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    service['title'] as String,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    service['description'] as String,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 15,
                      color: textLight,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // قسم الفريق
  Widget _buildTeamSection(bool isMobile) {
    final team = [
      {'name': 'أحمد العلي', 'role': 'المدير التنفيذي', 'icon': Icons.person},
      {'name': 'فاطمة محمد', 'role': 'مديرة المبيعات', 'icon': Icons.person},
      {'name': 'خالد سعيد', 'role': 'مستشار عقاري', 'icon': Icons.person},
      {'name': 'نورة أحمد', 'role': 'خدمة العملاء', 'icon': Icons.person},
    ];

    return Column(
      children: [
        _buildSectionHeader('فريق العمل', Icons.groups, isMobile),
        const SizedBox(height: 24),
        Wrap(
          spacing: cardSpacing,
          runSpacing: cardSpacing,
          alignment: WrapAlignment.center,
          children: team.map((member) {
            return Container(
              width: isMobile
                  ? (MediaQuery.of(context).size.width - 48) / 2
                  : 160,
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(borderRadiusValue),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.7),
                          secondaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      member['icon'] as IconData,
                      color: Colors.white,
                      size: isMobile ? 32 : 36,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    member['name'] as String,
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    member['role'] as String,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      color: textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // قسم التواصل
  Widget _buildContactSection(bool isMobile) {
    final contacts = [
      {
        'icon': Icons.phone,
        'title': 'الهاتف',
        'value': '+966 50 123 4567',
        'color': primaryColor,
      },
      {
        'icon': Icons.email,
        'title': 'البريد الإلكتروني',
        'value': 'info@realestate.com',
        'color': secondaryColor,
      },
      {
        'icon': Icons.location_on,
        'title': 'العنوان',
        'value': 'الرياض، المملكة العربية السعودية',
        'color': accentColor,
      },
      {
        'icon': Icons.access_time,
        'title': 'ساعات العمل',
        'value': 'السبت - الخميس: 9 صباحاً - 6 مساءً',
        'color': Colors.purple,
      },
    ];

    return Column(
      children: [
        _buildSectionHeader('اتصل بنا', Icons.contact_phone, isMobile),
        const SizedBox(height: 24),
        ...contacts.map((contact) {
          return Container(
            margin: const EdgeInsets.only(bottom: cardSpacing),
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(borderRadiusValue),
              border: Border.all(
                color: (contact['color'] as Color).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: (contact['color'] as Color).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (contact['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    contact['icon'] as IconData,
                    color: contact['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['title'] as String,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact['value'] as String,
                        style: TextStyle(
                          fontSize: isMobile ? 15 : 17,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
