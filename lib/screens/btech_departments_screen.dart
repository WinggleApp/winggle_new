import 'package:flutter/material.dart';
import 'department_semesters_screen.dart';

class BTechDepartmentsScreen extends StatelessWidget {
  const BTechDepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF064e3b)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'BTech Departments',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF064e3b),
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf0fdf4), Color(0xFFecfdf5), Color(0xFFd1fae5)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 20),
            _buildDepartmentCard(
              context,
              'Computer Science',
              'CSE',
              Icons.computer,
              const Color(0xFF10b981),
              '12 Subjects',
              '150+ Resources',
              'AI, ML, DSA, Web Dev, DBMS, OS, Networks, Cloud Computing, Cyber Security',
            ),
            _buildDepartmentCard(
              context,
              'Electrical Engineering',
              'EE',
              Icons.electrical_services,
              const Color(0xFFf59e0b),
              '10 Subjects',
              '120+ Resources',
              'Power Systems, Electrical Machines, Control Systems, Power Electronics, Signals',
            ),
            _buildDepartmentCard(
              context,
              'Electronics & Telecom',
              'ECE',
              Icons.settings_input_antenna,
              const Color(0xFF3b82f6),
              '11 Subjects',
              '135+ Resources',
              'Digital Electronics, Communication Systems, Microprocessors, VLSI, Signal Processing',
            ),
            _buildDepartmentCard(
              context,
              'Mechanical Engineering',
              'ME',
              Icons.precision_manufacturing,
              const Color(0xFF8b5cf6),
              '10 Subjects',
              '125+ Resources',
              'Thermodynamics, Fluid Mechanics, Manufacturing, Machine Design, CAD/CAM',
            ),
            _buildDepartmentCard(
              context,
              'Civil Engineering',
              'CE',
              Icons.apartment,
              const Color(0xFFec4899),
              '9 Subjects',
              '110+ Resources',
              'Structural Engineering, Construction, Surveying, Transportation, Environmental',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10b981).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10b981).withOpacity(0.1),
            blurRadius: 10,
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
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10b981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bachelor of Technology',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF064e3b),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Choose your department',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6b7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip('5', 'Departments', Icons.business),
              _buildStatChip('52', 'Total Subjects', Icons.menu_book),
              _buildStatChip('640+', 'Resources', Icons.description),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF10b981), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF064e3b),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6b7280),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentCard(
    BuildContext context,
    String name,
    String shortName,
    IconData icon,
    Color color,
    String subjects,
    String resources,
    String specializations,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DepartmentSemestersScreen(
                  departmentName: name,
                  departmentShort: shortName,
                  departmentIcon: icon,
                  departmentColor: color,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: Colors.white, size: 32),
                          const SizedBox(height: 4),
                          Text(
                            shortName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
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
                            name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF064e3b),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.book, size: 12, color: color),
                                    const SizedBox(width: 4),
                                    Text(
                                      subjects,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFf0fdf4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.description, size: 12, color: Color(0xFF6b7280)),
                                    const SizedBox(width: 4),
                                    Text(
                                      resources,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF6b7280),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf9fafb),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 14, color: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          specializations,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6b7280),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
