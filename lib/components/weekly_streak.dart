import 'package:flutter/material.dart';
import 'package:myapp/style/colors.dart';
import 'package:myapp/style/text_styles.dart';
import 'dart:ui';

class WeeklyStreakTile extends StatelessWidget {
  final String? petName;
  final int thisWeek;

  const WeeklyStreakTile({
    super.key,
    required this.thisWeek,
    required this.petName,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('lib/assets/images/streak_tile_bg.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Racha semanal",
              style: AppTextStyles.tileTitle.copyWith(color: AppColors.red),
            ),
            //SizedBox(height: 6),
            Text(
              "Hacé que $petName haga al menos 60 minutos de actividad al día para mantener la racha.",
              style: AppTextStyles.text,
            ),
            SizedBox(height: 6),

            Row(
              children:
                  'LMXJVSD'.split('').asMap().entries.map((entry) {
                    final i = entry.key;
                    final letra = entry.value;

                    final isWeekend = i >= 5;

                    final innerContent = Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          letra,
                          style: AppTextStyles.bigText.copyWith(fontSize: 20),
                        ),
                      ),
                    );

                    return Expanded(
                      child: Container(
                        height: 36,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child:
                                isWeekend
                                    ? Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 8,
                                            sigmaY: 8,
                                          ),
                                          child: Container(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.white40,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: innerContent,
                                        ),
                                      ],
                                    )
                                    : Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: innerContent,
                                    ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
