import 'package:flutter/material.dart';
import 'academic_section.dart';
import 'competitive_section.dart';

class ResourceLibraryScreen extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const ResourceLibraryScreen({super.key, this.onProfileTap});

  @override
  State<ResourceLibraryScreen> createState() => _ResourceLibraryScreenState();
}

class _ResourceLibraryScreenState extends State<ResourceLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Column(
                children: [
                  Material(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF10b981),
                      unselectedLabelColor: const Color(0xFF9ca3af),
                      indicatorColor: const Color(0xFF10b981),
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'Academic'),
                        Tab(text: 'Competitive'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        AcademicSection(onProfileTap: widget.onProfileTap),
                        CompetitiveSection(onProfileTap: widget.onProfileTap),
                      ],
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resource Library',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF064e3b),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Explore learning resources',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6b7280),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: widget.onProfileTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10b981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Color(0xFF10b981),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
