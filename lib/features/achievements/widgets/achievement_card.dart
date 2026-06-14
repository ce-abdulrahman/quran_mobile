import 'package:flutter/material.dart';
import '../../../core/models/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final VoidCallback? onTap;

  const AchievementCard({super.key, required this.achievement, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isHidden = achievement.isStillHidden;
    final bool isCompleted = achievement.isCompleted;
    final double progress = achievement.progressFraction;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: isCompleted
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                )
              : null,
          color: isCompleted ? null : const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? const Color(0xFFFFD700).withOpacity(0.5)
                : Colors.white.withOpacity(0.08),
            width: isCompleted ? 1.5 : 1,
          ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + completed badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon with greyscale for locked
                ColorFiltered(
                  colorFilter: isCompleted || !isHidden
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.saturation)
                      : const ColorFilter.matrix([
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0,      0,      0,      1, 0,
                        ]),
                  child: Text(
                    isHidden ? '🔒' : achievement.icon,
                    style: TextStyle(
                      fontSize: 36,
                      color: isCompleted ? null : Colors.white38,
                    ),
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '✅',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Name
            Text(
              isHidden ? '???' : achievement.name,
              style: TextStyle(
                color: isCompleted ? Colors.white : Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Description or locked hint
            Text(
              isHidden
                  ? 'دەستکەوتەی نهێنی'
                  : (achievement.description ?? ''),
              style: const TextStyle(color: Colors.white38, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Progress bar (only for in-progress non-hidden)
            if (!isCompleted && !isHidden && achievement.conditionValue > 1) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${achievement.progressValue} / ${achievement.conditionValue}',
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],

            // Reward points
            if (achievement.rewardPoints > 0 && isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${achievement.rewardPoints} pts',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Unlock date
            if (isCompleted && achievement.completedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '${achievement.completedAt!.day}/${achievement.completedAt!.month}/${achievement.completedAt!.year}',
                  style: const TextStyle(color: Colors.white30, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
