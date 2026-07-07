import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';

class MentorsPage extends ConsumerStatefulWidget {
  const MentorsPage({super.key});

  @override
  ConsumerState<MentorsPage> createState() => _MentorsPageState();
}

class _MentorsPageState extends ConsumerState<MentorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
              itemCount: 4,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildMentorCard(
                    name: 'Saima Rahman',
                    role: 'Product Director @ TechFlow',
                    image: 'https://i.pravatar.cc/150?img=5',
                    tags: ['Technology', 'Product Mgmt', 'Class of \'14'],
                    bio: 'Passionate about building scalable B2B SaaS products. Happy to review resumes, prep for...',
                    isPending: false,
                  );
                } else if (index == 1) {
                  return _buildMentorCard(
                    name: 'Mahir Chowdhury',
                    role: 'VP Finance @ Apex Cap',
                    image: 'https://i.pravatar.cc/150?img=11',
                    tags: ['Finance', 'Inv. Banking', 'Class of \'08'],
                    bio: 'Over 15 years in M&A and corporate finance. Looking to mentor driven recent grads...',
                    isPending: false,
                  );
                } else if (index == 2) {
                  return _buildMentorCard(
                    name: 'Ananya Chowdhury',
                    role: 'Senior Data Scientist @ AI Dynamics',
                    image: 'https://i.pravatar.cc/150?img=9',
                    tags: ['Data Science', 'Machine Learning', 'Class of \'18'],
                    bio: 'Specializing in NLP and predictive modeling. Can help with portfolio reviews, algorithmic...',
                    isPending: false,
                  );
                } else {
                  return _buildMentorCard(
                    name: 'Tousif Ahmed',
                    role: 'Founder @ GreenTech Solutions',
                    image: 'https://i.pravatar.cc/150?img=12',
                    tags: ['Entrepreneurship', 'Sustainability', 'Class of \'11'],
                    bio: 'Navigating early-stage funding and sustainable business models. Happy to chat...',
                    isPending: true,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: Color(0xFF700000),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.push('${AppRoutes.directory}/akram_rafid'),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Mentors',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.black54),
                hintText: 'Search by name, industry, or company...',
                hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFilterChip('All Industries', Icons.tune),
              const SizedBox(width: 8),
              _buildFilterChip('Location', null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.black54),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard({
    required String name,
    required String role,
    required String image,
    required List<String> tags,
    required String bio,
    required bool isPending,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(image),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.bookmark_border, color: Colors.black54, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) => _buildTag(tag)).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            bio,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: isPending 
                ? const SizedBox.shrink() 
                : const Icon(Icons.handshake_outlined, color: Colors.white, size: 18),
              label: Text(
                isPending ? 'Pending Request...' : 'Request Mentorship',
                style: TextStyle(
                  color: isPending ? const Color(0xFF700000) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPending ? const Color(0xFFFDEAEA) : const Color(0xFF700000),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDEAEA), // Light red/pink bg
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF700000),
        ),
      ),
    );
  }
}
