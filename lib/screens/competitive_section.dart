import 'package:flutter/material.dart';

class Exam {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final String category;
  final int resources;

  Exam({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.category,
    required this.resources,
  });
}

class CompetitiveSection extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const CompetitiveSection({super.key, this.onProfileTap});

  @override
  State<CompetitiveSection> createState() => _CompetitiveSectionState();
}

class _CompetitiveSectionState extends State<CompetitiveSection> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  late AnimationController _animationController;

  final List<Exam> _exams = [
    Exam(
      id: '1',
      title: 'GATE',
      subtitle: 'Graduate Aptitude Test in Engineering',
      icon: '🔧',
      color: const Color(0xFF3b82f6),
      category: 'Engineering',
      resources: 933,
    ),
    Exam(
      id: '2',
      title: 'UPSC',
      subtitle: 'Union Public Service Commission',
      icon: '🏛️',
      color: const Color(0xFFF97316),
      category: 'Government',
      resources: 1228,
    ),
    Exam(
      id: '3',
      title: 'CAT',
      subtitle: 'Common Admission Test',
      icon: '🏢',
      color: const Color(0xFF8b5cf6),
      category: 'Management',
      resources: 719,
    ),
    Exam(
      id: '4',
      title: 'SSC',
      subtitle: 'Staff Selection Commission',
      icon: '📋',
      color: const Color(0xFF10b981),
      category: 'Government',
      resources: 779,
    ),
    Exam(
      id: '5',
      title: 'Banking',
      subtitle: 'Banking & Insurance Exams',
      icon: '🏦',
      color: const Color(0xFF10b981),
      category: 'Banking',
      resources: 1044,
    ),
    Exam(
      id: '6',
      title: 'JEE',
      subtitle: 'Joint Entrance Examination',
      icon: '⚡',
      color: const Color(0xFFef4444),
      category: 'Engineering',
      resources: 1035,
    ),
    Exam(
      id: '7',
      title: 'NEET',
      subtitle: 'National Eligibility cum Entrance Test',
      icon: '🔬',
      color: const Color(0xFFdc2626),
      category: 'Medical',
      resources: 901,
    ),
    Exam(
      id: '8',
      title: 'GRE',
      subtitle: 'Graduate Record Examination',
      icon: '🌐',
      color: const Color(0xFF06b6d4),
      category: 'International',
      resources: 847,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Exam> get _filteredExams {
    if (_searchQuery.isEmpty) {
      return _exams;
    }
    return _exams
        .where((exam) =>
            exam.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            exam.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFEF3C7),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF9ca3af), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search exams...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9ca3af),
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Select Your Exam Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Select Your Exam',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF064e3b),
                  decoration: TextDecoration.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Exam Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _filteredExams
                    .map((exam) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildExamCard(exam),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(Exam exam) {
    return GestureDetector(
      onTap: () {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${exam.title} selected!'),
            duration: const Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      },
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.98).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: exam.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    exam.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1f2937),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      exam.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6b7280),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF08A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            exam.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF92400e),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${exam.resources}+ resources',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6b7280),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: exam.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
