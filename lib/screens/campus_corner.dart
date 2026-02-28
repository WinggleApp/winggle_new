import 'package:flutter/material.dart';
import '../models/college.dart';
import 'college_details.dart';

class CampusCornnerScreen extends StatefulWidget {
  const CampusCornnerScreen({super.key});

  @override
  State<CampusCornnerScreen> createState() => _CampusCornnerScreenState();
}

class _CampusCornnerScreenState extends State<CampusCornnerScreen> {
  late List<College> colleges;
  late List<College> filteredColleges;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    colleges = College.getColleges();
    filteredColleges = colleges;
  }

  void _filterColleges(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredColleges = colleges;
      } else {
        filteredColleges = colleges
            .where((college) =>
                college.name.toLowerCase().contains(query.toLowerCase()) ||
                college.location.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCollege = colleges.firstWhere(
      (college) => college.isUserCollege,
      orElse: () => colleges.first,
    );

    final otherColleges =
        filteredColleges.where((college) => !college.isUserCollege).toList();

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
          'Campus Corner',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF10b981),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFe5e7eb), width: 1),
              ),
              child: TextField(
                controller: searchController,
                onChanged: _filterColleges,
                decoration: InputDecoration(
                  hintText: 'Search colleges...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9ca3af),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Your College Section
            const Text(
              'YOUR COLLEGE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF10b981),
              ),
            ),
            const SizedBox(height: 12),
            _buildCollegeCard(
              userCollege,
              isUserCollege: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CollegeDetailsScreen(
                      college: userCollege,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Other Colleges Section
            Text(
              'OTHER COLLEGES (${otherColleges.length})',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6b7280),
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: otherColleges.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildCollegeCard(
                  otherColleges[index],
                  isUserCollege: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollegeCard(
    College college, {
    required bool isUserCollege,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUserCollege
              ? const Color(0xFF10b981).withValues(alpha: 0.2)
              : const Color(0xFFe5e7eb),
          width: isUserCollege ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // College Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isUserCollege
                            ? const Color(0xFFe0f7f4)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.apartment,
                        color: isUserCollege
                            ? const Color(0xFF10b981)
                            : const Color(0xFF9ca3af),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // College Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            college.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF064e3b),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (college.degree.isNotEmpty)
                            Text(
                              college.degree,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6b7280),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (college.degree.isEmpty)
                            Text(
                              college.location,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6b7280),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isUserCollege
                                  ? const Color(0xFF10b981).withValues(alpha: 0.1)
                                  : const Color(0xFF10b981).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              college.isPartner ? 'Partner College' : 'Other',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isUserCollege
                                    ? const Color(0xFF10b981)
                                    : const Color(0xFF10b981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: const Color(0xFF9ca3af),
                    ),
                  ],
                ),
                // Student Count (only for other colleges)
                if (!isUserCollege) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 16,
                            color: Color(0xFF9ca3af),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${college.studentCount.toString()} students',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6b7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
