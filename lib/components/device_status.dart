import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/style/colors.dart';
import 'package:myapp/style/text_styles.dart';

class DeviceTile extends StatelessWidget {
  final String deviceName;
  final String batteryText; // ej: "36% de batería (aprox. 22h)"
  final String imageAsset; // ruta a tu asset, ej "assets/petlink.png"
  final VoidCallback onSync;
  final VoidCallback onFind;
  final VoidCallback onViewPetId;

  const DeviceTile({
    Key? key,
    required this.deviceName,
    required this.batteryText,
    required this.imageAsset,
    required this.onSync,
    required this.onFind,
    required this.onViewPetId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), // mismo radio que el Container
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(60),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- fila de imagen + textos ---
              Row(
                children: [
                  Image.asset(imageAsset, height: 64, fit: BoxFit.contain),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deviceName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.battery_100,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            batteryText,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- fila de botones de acción ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionButton(
                    icon: Icons.sync,
                    label: 'Sincronizar',
                    onTap: onSync,
                  ),
                  SizedBox(width: 8),
                  ActionButton(
                    icon: Icons.location_searching,
                    label: 'Encontrar',
                    onTap: onFind,
                  ),
                  SizedBox(width: 8),
                  ActionButton(
                    icon: Icons.qr_code,
                    label: 'Ver PetID',
                    onTap: onViewPetId,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // vos definís la lógica afuera
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white40,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(height: 4),
                Text(label, style: AppTextStyles.textSmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
