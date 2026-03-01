import 'package:flutter/material.dart';
import 'btech_departments_screen.dart';

class AcademicSection extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const AcademicSection({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search degrees...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey[400]),
              ),
            ),
          ),
        ),
        
        // Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select Your Degree',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Degree cards list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // B.Tech - Clickable
              _buildDegreeCard(
                context,
                'B.Tech',
                'Bachelor of Technology',
                '5 Departments',
                '959+ resources',
                Icons.engineering,
                const Color(0xFF2196F3),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BTechDepartmentsScreen(),
                    ),
                  );
                },
              ),
              
              // Diploma
              _buildDegreeCard(
                context,
                'Diploma',
                'Diploma in Engineering',
                '6 Departments',
                '405+ resources',
                Icons.description,
                const Color(0xFFFF9800),
                null,
              ),
              
              // BA
              _buildDegreeCard(
                context,
                'BA',
                'Bachelor of Arts',
                '8 Departments',
                '644+ resources',
                Icons.menu_book,
                const Color(0xFF9C27B0),
                null,
              ),
              
              // B.Com
              _buildDegreeCard(
                context,
                'B.Com',
                'Bachelor of Commerce',
                '7 Departments',
                '586+ resources',
                Icons.account_balance_wallet,  
                  const Color(0xFF4CAF50),      
                null,
                ),
              
              // BCA
              _buildDegreeCard(
                context,
                'BCA',
                'Bachelor of Computer Applications',
                '8 Departments',
                '817+ resources',
                Icons.computer,
                const Color(0xFF00BCD4),
                null,
              ),
              
              // BBA
              _buildDegreeCard(
                context,
                'BBA',
                'Bachelor of Business Administration',
                '6 Departments',
                '423+ resources',
                Icons.business_center,
                const Color(0xFFE91E63),
                null,
              ),
              
              // B.Sc
              _buildDegreeCard(
                context,
                'B.Sc',
                'Bachelor of Science',
                '7 Departments',
                '604+ resources',
                Icons.science,
                const Color(0xFF673AB7),
                null,
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDegreeCard(
    BuildContext context,
    String title,
    String subtitle,
    String departments,
    String resources,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF064e3b),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            departments,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF10b981),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            resources,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
