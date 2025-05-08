// File: lib/pages/home_page.dart
// ------------------------------
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/device_status.dart';
import 'package:myapp/components/weekly_streak.dart';
import 'package:myapp/components/widgets.dart';
import 'package:myapp/pages/petlinkid_page.dart';
import 'package:myapp/services/prefs_service.dart' as prefs_service;
import 'package:url_launcher/url_launcher.dart';
import '../style/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _petWeight;
  DateTime? _lastUpdatedWeight;

  @override
  void initState() {
    super.initState();
    _loadPeso();
  }

  Future<void> _loadPeso() async {
    final peso =
        await prefs_service.PrefsService.getDouble('pet_weight') ?? 0.0;
    final lastUpdated = await prefs_service.PrefsService.getDateTime(
      'pet_weight_last_updated',
    );
    setState(() {
      _petWeight = peso;
      _lastUpdatedWeight = lastUpdated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Image.asset("lib/assets/images/header_bg.png"),
                SafeArea(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SvgPicture.asset(
                              "lib/assets/logo_horizontal.svg",
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SvgPicture.asset(
                              "lib/assets/icons/setting.svg",
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DeviceTile(
                              onSync: () {},
                              onFind: () async {
                                if (Platform.isIOS) {
                                  final uri = Uri.parse('findmy://');
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'No se pudo abrir "Find My".',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Sistema no compatible con "Find My".',
                                      ),
                                    ),
                                  );
                                }
                              },

                              onViewPetId: () {
                                final route =
                                    Theme.of(context).platform ==
                                            TargetPlatform.iOS
                                        ? CupertinoPageRoute(
                                          builder: (_) => const PetLinkIDPage(),
                                        )
                                        : MaterialPageRoute(
                                          builder: (_) => const PetLinkIDPage(),
                                        );

                                Navigator.of(context).push(route);
                              },

                              imageAsset: "lib/assets/images/collar.png",
                              deviceName: "Petlink de Juana",
                              batteryText: "80% (aprox. 3 días)",
                            ),
                            WeightTile(
                              lastUpdated: _lastUpdatedWeight,
                              onWeightUpdated: () => _loadPeso(),
                              weight: _petWeight ?? 0.0,
                              idealWeight: "12 - 20",
                              statusWeight: "statusWeight",
                            ),
                            WeeklyStreakTile(thisWeek: 7),
                            WeekActivity(
                              dailyMinutes: [60, 30, 19, 31, 13, 20, 0],
                            ),
                          ],
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
    );
  }
}
