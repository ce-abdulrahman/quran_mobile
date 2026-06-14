import 'package:flutter/material.dart';
import '../../core/models/achievement_model.dart';

class AchievementDetailPage extends StatelessWidget {
  final AchievementModel achievement;

  const AchievementDetailPage({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = achievement.isCompleted;
    final double progress = achievement.progressFraction;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 100, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isCompleted
                      ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                      : [const Color(0xFF161622), const Color(0xFF1A1A2E)],
                ),
              ),
              child: Column(
                children: [
                  // Badge
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: isCompleted
                            ? [
                                const Color(0xFFFFD700).withOpacity(0.2),
                                Colors.transparent,
                              ]
                            : [Colors.white10, Colors.transparent],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        achievement.icon,
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name
                  Text(
                    achievement.name,
                    style: TextStyle(
                      color: isCompleted ? Colors.white : Colors.white70,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (achievement.category != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${achievement.category!.icon} ${achievement.category!.name}',
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFFFFD700).withOpacity(0.15)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCompleted
                            ? const Color(0xFFFFD700).withOpacity(0.4)
                            : Colors.white24,
                      ),
                    ),
                    child: Text(
                      isCompleted ? '✅ تەواوکرا' : '⏳ لەپرۆسەدایە',
                      style: TextStyle(
                        color: isCompleted ? const Color(0xFFFFD700) : Colors.white60,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Detail card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (achievement.description != null)
                    _InfoCard(
                      title: 'وصف',
                      child: Text(
                        achievement.description!,
                        style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Progress card
                  _InfoCard(
                    title: 'پێشکەوتن',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${achievement.progressValue} / ${achievement.conditionValue}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                color: isCompleted
                                    ? const Color(0xFFFFD700)
                                    : const Color(0xFF6366F1),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: Colors.white12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCompleted
                                  ? const Color(0xFFFFD700)
                                  : const Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        if (isCompleted && achievement.completedAt != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'کۆتایی پێهات: ${achievement.completedAt!.day}/${achievement.completedAt!.month}/${achievement.completedAt!.year}',
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Reward card
                  _InfoCard(
                    title: 'خەڵات',
                    child: Row(
                      children: [
                        const Text('🏅', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '+${achievement.rewardPoints} پوائنت',
                              style: const TextStyle(
                                color: Color(0xFFFFD700),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              achievement.rewardType,
                              style: const TextStyle(color: Colors.white38, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Metadata
                  _InfoCard(
                    title: 'وردەکاری',
                    child: Column(
                      children: [
                        _MetaRow(label: 'جۆری مەرج', value: achievement.conditionType),
                        _MetaRow(label: 'ئامانجی مەرج', value: achievement.conditionValue.toString()),
                        _MetaRow(label: 'وەشان', value: 'v${achievement.version}'),
                        _MetaRow(label: 'کلیل', value: achievement.key),
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
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
