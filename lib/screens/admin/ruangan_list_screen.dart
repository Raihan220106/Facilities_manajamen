import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_theme.dart';
import '../../models/facility_model.dart';
import 'asset_list_screen.dart';

class RuanganListScreen extends StatelessWidget {
  final LantaiModel lantai;
  final String gedungName;

  const RuanganListScreen({
    super.key,
    required this.lantai,
    required this.gedungName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bgDark,
            floating: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lantai.name,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$gedungName • Daftar Ruangan',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded,
                    color: AppColors.textPrimary, size: 26),
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  '${lantai.ruangan.length} Ruangan di ${lantai.name}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ...lantai.ruangan
                    .map((r) => _buildRuanganCard(context, r)),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuanganCard(BuildContext context, RuanganModel ruangan) {
    int asetBaik =
        ruangan.assets.where((a) => a.status == AssetStatus.baik).length;
    int asetRusak =
        ruangan.assets.where((a) => a.status == AssetStatus.rusak).length;
    int asetMaintenance =
        ruangan.assets.where((a) => a.status == AssetStatus.maintenance).length;

    Color statusColor;
    String statusLabel;
    if (asetRusak > 0) {
      statusColor = AppColors.danger;
      statusLabel = '$asetRusak aset rusak';
    } else if (asetMaintenance > 0) {
      statusColor = AppColors.warning;
      statusLabel = '$asetMaintenance maintenance';
    } else {
      statusColor = AppColors.success;
      statusLabel = 'Semua baik';
    }

    IconData tipeIcon;
    switch (ruangan.tipe) {
      case 'Ruang Rapat':
        tipeIcon = Icons.meeting_room_rounded;
        break;
      case 'Ruang Kerja':
        tipeIcon = Icons.work_rounded;
        break;
      case 'Lobby':
        tipeIcon = Icons.door_sliding_rounded;
        break;
      case 'Ruang Eksekutif':
        tipeIcon = Icons.star_rounded;
        break;
      case 'Aula':
        tipeIcon = Icons.festival_rounded;
        break;
      case 'Gudang':
        tipeIcon = Icons.warehouse_rounded;
        break;
      default:
        tipeIcon = Icons.room_rounded;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AssetListScreen(
              ruangan: ruangan,
              lantaiName: lantai.name,
              gedungName: gedungName,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: statusColor.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(tipeIcon, color: AppColors.primaryLight, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ruangan.name,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _infoChip(ruangan.tipe, AppColors.accent),
                      const SizedBox(width: 6),
                      _infoChip(
                          '${ruangan.kapasitas} org', AppColors.textMuted),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_rounded,
                          color: AppColors.textMuted, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${ruangan.assets.length} Aset',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
