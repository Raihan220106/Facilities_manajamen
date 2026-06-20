import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/facility_provider.dart';
import '../../utils/app_theme.dart';
import '../../models/facility_model.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen>
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
    final facility = context.watch<FacilityProvider>();
    final belumDitindak =
        facility.laporanKerusakan.where((l) => !l.sudahDitindak).toList();
    final sudahDitindak =
        facility.laporanKerusakan.where((l) => l.sudahDitindak).toList();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bgDark,
            floating: true,
            title: Text(
              'Laporan Kerusakan',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(96),
              child: Column(
                children: [
                  // Stats row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        _topStat('Total Laporan',
                            '${facility.laporanKerusakan.length}',
                            AppColors.accent),
                        const SizedBox(width: 10),
                        _topStat('Belum Ditindak', '${belumDitindak.length}',
                            AppColors.danger),
                        const SizedBox(width: 10),
                        _topStat('Selesai', '${sudahDitindak.length}',
                            AppColors.success),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primaryLight,
                    labelColor: AppColors.primaryLight,
                    unselectedLabelColor: AppColors.textMuted,
                    labelStyle: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: [
                      Tab(
                          text:
                              'Belum Ditindak (${belumDitindak.length})'),
                      Tab(text: 'Sudah Ditindak (${sudahDitindak.length})'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(belumDitindak),
                _buildList(sudahDitindak),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<LaporanKerusakan> laporan) {
    if (laporan.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: AppColors.success, size: 56),
            const SizedBox(height: 12),
            Text(
              'Tidak ada laporan',
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: laporan.length,
      itemBuilder: (_, i) => _buildCard(laporan[i]),
    );
  }

  Widget _buildCard(LaporanKerusakan laporan) {
    Color prioritasColor;
    IconData prioritasIcon;

    switch (laporan.prioritas) {
      case 'tinggi':
        prioritasColor = AppColors.danger;
        prioritasIcon = Icons.priority_high_rounded;
        break;
      case 'sedang':
        prioritasColor = AppColors.warning;
        prioritasIcon = Icons.remove_rounded;
        break;
      default:
        prioritasColor = AppColors.info;
        prioritasIcon = Icons.arrow_downward_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: laporan.sudahDitindak
              ? AppColors.border
              : prioritasColor.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: prioritasColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(prioritasIcon, color: prioritasColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      laporan.assetName,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      laporan.ruangan,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: prioritasColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      laporan.prioritas.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: prioritasColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (laporan.sudahDitindak)
                    const Icon(Icons.verified_rounded,
                        color: AppColors.success, size: 18)
                  else
                    const Icon(Icons.pending_rounded,
                        color: AppColors.warning, size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            laporan.deskripsi,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person_rounded,
                  color: AppColors.textMuted, size: 13),
              const SizedBox(width: 4),
              Text(
                laporan.pelaporName,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              const Icon(Icons.calendar_today_rounded,
                  color: AppColors.textMuted, size: 13),
              const SizedBox(width: 4),
              Text(
                '${laporan.tanggalLapor.day}/${laporan.tanggalLapor.month}/${laporan.tanggalLapor.year}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (!laporan.sudahDitindak) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_rounded, size: 16),
                label: const Text('Tandai Ditindak'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ],
      ),
    );
  }
}
