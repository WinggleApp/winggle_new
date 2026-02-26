import 'package:flutter/material.dart';
import '../widgets/user_avatar.dart';

class LoopScreen extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const LoopScreen({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final stories = [
      {'name': 'Your Story', 'initial': '+', 'color': const Color(0xFF10b981)},
      {'name': 'Stuet Don', 'initial': 'S', 'color': const Color(0xFF10b981)},
      {'name': 'John', 'initial': 'J', 'color': const Color(0xFF10b981)},
      {'name': 'Emily', 'initial': 'E', 'color': const Color(0xFF10b981)},
      {'name': 'Clubs', 'initial': 'C', 'color': const Color(0xFF10b981)},
    ];

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey[300]!, width: .5))),
                child: Row(children: [
                  const Text('Loop',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF10b981))),
                  const Spacer(),
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12)),
                      child:
                          const Icon(Icons.search, color: Color(0xFF059669))),
                  const SizedBox(width: 8),
                  UserAvatar(
                    onTap: onProfileTap,
                  ),
                ]),
              ),

              // Stories row
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final s = stories[index];
                    return Container(
                      width: 140,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFF10b981)
                                .withValues(alpha: 0.12)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 6,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 22,
                              backgroundColor: s['color'] as Color,
                              child: Text(s['initial'] as String,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(s['name'] as String,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF064e3b)),
                                  overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 6),
                          Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF10b981),
                                  shape: BoxShape.circle)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
