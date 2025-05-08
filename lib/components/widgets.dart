// Suggested code may be subject to a license. Learn more: ~LicenseLog:146425495.
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/big_number.dart';
import 'package:myapp/services/prefs_service.dart';
import 'package:myapp/services/relative_time.dart';
import 'package:myapp/style/colors.dart';
import 'package:myapp/style/text_styles.dart';

class WeightTile extends StatelessWidget {
  final double weight;
  final String idealWeight;
  final String statusWeight;
  final DateTime? lastUpdated;
  final VoidCallback onWeightUpdated;

  const WeightTile({
    super.key,
    required this.weight,
    required this.idealWeight,
    required this.statusWeight,
    required this.onWeightUpdated,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TextEditingController _pesoController = TextEditingController();
        showDialog(
          context: context,
          builder:
              (context) => Dialog(
                backgroundColor: AppColors.tile,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Introducir nuevo peso",
                        style: AppTextStyles.tileTitle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Último peso no está actualizado",
                        style: AppTextStyles.textDimmed,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _pesoController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: AppTextStyles.text,
                        decoration: InputDecoration(
                          hintText: "Ej: 12.5",
                          hintStyle: AppTextStyles.textDimmed,
                          filled: true,
                          fillColor: AppColors.tile,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.white60),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.white60),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancelar", style: AppTextStyles.text),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () async {
                              final peso =
                                  double.tryParse(_pesoController.text) ?? 0.0;
                              final now = DateTime.now();
                              await PrefsService.setDouble('pet_weight', peso);
                              await PrefsService.setDateTime(
                                'pet_weight_last_updated',
                                now,
                              );

                              onWeightUpdated();
                              Navigator.pop(context);
                            },
                            child: Text("Guardar", style: AppTextStyles.text),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: AppColors.tile,
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Text("Peso", style: AppTextStyles.tileTitle)]),
                Row(
                  children: [
                    Text(
                      "Último registro: ${lastUpdated != null ? formatFechaCustom(lastUpdated!) : "N/A"}", // Fixed variable
                      style: AppTextStyles.textDimmed,
                    ),
                    Icon(Icons.chevron_right, color: AppColors.white60),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BigNumber(amount: weight, unit: "kg"),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_sharp,
                          color: AppColors.yellow,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusWeight,
                          style: AppTextStyles.text.copyWith(
                            color: AppColors.yellow,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Ideal: $idealWeight", style: AppTextStyles.textDimmed),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final double barSpacing;
  final double average;

  static const double sidePadding = 8;

  _BarChartPainter({
    required this.data,
    required this.barSpacing,
    required this.average,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBar = Paint()..color = AppColors.primary;
    final paintLine =
        Paint()
          ..color = AppColors.white40
          ..strokeWidth = 1;

    final paintAvg =
        Paint()
          ..color = AppColors.primary.withOpacity(0.6)
          ..style = PaintingStyle.stroke;

    final rightPadding = 40.0;
    final totalSpaceForBars = size.width - 2 * sidePadding - rightPadding;

    // Ensure the maximum value is at least 60
    final maxValue = data
        .map((e) => e.toDouble())
        .reduce((a, b) => a > b ? a : b)
        .ceilToDouble()
        .clamp(0, 60);
    final topLimit = maxValue > 60 ? maxValue : 60;

    final barWidth =
        (totalSpaceForBars - (data.length - 1) * barSpacing) / data.length;

    final chartHeight = size.height;

    final y60 = chartHeight * (1 - 60 / topLimit);
    canvas.drawLine(
      Offset(0, y60),
      Offset(size.width - rightPadding, y60),
      paintLine,
    );

    // Draw horizontal line at 0m
    final y0 = chartHeight;
    canvas.drawLine(
      Offset(0, y0),
      Offset(size.width - rightPadding, y0),
      paintLine,
    );

    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final barHeight = chartHeight * (data[i].toDouble() / topLimit);
      final x = i * (barWidth + barSpacing) + sidePadding;
      final y = chartHeight - barHeight;

      final barRect = Rect.fromLTWH(x, y, barWidth, barHeight);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          barRect,
          topLeft: const Radius.circular(6),
          topRight: const Radius.circular(6),
        ),
        paintBar,
      );
    }

    // Draw day labels
    const dayLabels = ["L", "M", "X", "J", "V", "S", "D"];
    for (int i = 0; i < dayLabels.length; i++) {
      final x = i * (barWidth + barSpacing) + sidePadding;
      final textPainter = TextPainter(
        text: TextSpan(
          text: dayLabels[i],
          style: AppTextStyles.textSmallDimmed,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, chartHeight + 8),
      );
    }

    // Draw minute labels (0m, 60m)
    final textPainter0 = TextPainter(
      text: TextSpan(text: "0m", style: AppTextStyles.textSmallDimmed),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter0.paint(
      canvas,
      Offset(size.width - rightPadding + 10, y0 - textPainter0.height / 2),
    );

    final textPainter60 = TextPainter(
      text: TextSpan(text: "60m", style: AppTextStyles.textSmallDimmed),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter60.paint(
      canvas,
      Offset(size.width - rightPadding + 10, y60 - textPainter60.height / 2),
    );

    // Ajustar la línea de promedio para que se dibuje correctamente
    final avgY = chartHeight * (1 - average / topLimit);

    // Dibujar línea de promedio punteada
    const dashWidth = 5;
    const dashSpace = 4;
    double startX = 0;
    while (startX < size.width - rightPadding) {
      canvas.drawLine(
        Offset(startX, avgY),
        Offset(startX + dashWidth, avgY),
        paintAvg,
      );
      startX += dashWidth + dashSpace;
    }

    // Etiqueta "avg"
    final textPainter = TextPainter(
      text: TextSpan(
        text: "avg",
        style: const TextStyle(color: AppColors.primary, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(size.width - rightPadding + 10, avgY - 12),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WeekActivity extends StatelessWidget {
  final List<double> dailyMinutes;

  double get averageDailyMinutes =>
      (dailyMinutes.fold(0.0, (a, b) => a + b) / dailyMinutes.length)
          .floorToDouble();

  const WeekActivity({super.key, required this.dailyMinutes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: AppColors.tile,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Actividad esta semana", style: AppTextStyles.tileTitle),
              Text(
                "Avg. $averageDailyMinutes minutos",
                style: AppTextStyles.textDimmed,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _BarChartPainter(
                data: dailyMinutes,
                barSpacing: 12,
                average: averageDailyMinutes,
              ),
              size: Size(double.infinity, 200),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
