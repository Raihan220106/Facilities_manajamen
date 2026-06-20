import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_theme.dart';
import '../../models/facility_model.dart';

class AssetListScreen extends StatelessWidget {
  final RuanganModel ruangan;
  final String lantaiName;
  final String gedungName;

  const AssetListScreen({
    super.key,
    required this.ruangan,
    required this.lantaiName,
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
                  ruangan.name,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$gedungName • $lantaiName',
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
                // Room summary
                _buildRoomSummary(),
                const SizedBox(height: 20),
                Text(
                  '${ruangan.assets.length} Aset di ${ruangan.name}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ...ruangan.assets.map((a) => _buildAssetCard(context, a)),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomSummary() {
    int baik = ruangan.assets.where((a) => a.status == AssetStatus.baik).length;
    int rusak =
        ruangan.assets.where((a) => a.status == AssetStatus.rusak).length;
    int maint = ruangan.assets
        .where((a) => a.status == AssetStatus.maintenance)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.room_rounded,
                  color: AppColors.primaryLight, size: 18),
              const SizedBox(width: 8),
              Text(
                ruangan.tipe,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              const Icon(Icons.people_rounded,
                  color: AppColors.textMuted, size: 16),
              const SizedBox(width: 4),
              Text(
                'Kapasitas: ${ruangan.kapasitas}',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _summaryItem('Baik', baik, AppColors.success),
              _summaryItem('Rusak', rusak, AppColors.danger),
              _summaryItem('Maintenance', maint, AppColors.warning),
              _summaryItem('Total', ruangan.assets.length, AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$count',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, AssetModel asset) {
    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (asset.status) {
      case AssetStatus.baik:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_rounded;
        statusLabel = 'Baik';
        break;
      case AssetStatus.rusak:
        statusColor = AppColors.danger;
        statusIcon = Icons.cancel_rounded;
        statusLabel = 'Rusak';
        break;
      case AssetStatus.maintenance:
        statusColor = AppColors.warning;
        statusIcon = Icons.build_circle_rounded;
        statusLabel = 'Maintenance';
        break;
      case AssetStatus.tidakAktif:
        statusColor = AppColors.textMuted;
        statusIcon = Icons.remove_circle_rounded;
        statusLabel = 'Tidak Aktif';
        break;
    }

    IconData categoryIcon;
    switch (asset.category) {
      case 'AC':
        categoryIcon = Icons.ac_unit_rounded;
        break;
      case 'Proyektor':
        categoryIcon = Icons.videocam_rounded;
        break;
      case 'Smart TV':
        categoryIcon = Icons.tv_rounded;
        break;
      case 'Printer':
        categoryIcon = Icons.print_rounded;
        break;
      case 'CCTV':
        categoryIcon = Icons.camera_outdoor_rounded;
        break;
      case 'Lampu':
        categoryIcon = Icons.lightbulb_rounded;
        break;
      case 'Server':
        categoryIcon = Icons.dns_rounded;
        break;
      case 'UPS':
        categoryIcon = Icons.battery_charging_full_rounded;
        break;
      case 'Genset':
        categoryIcon = Icons.electrical_services_rounded;
        break;
      case 'Audio':
        categoryIcon = Icons.speaker_rounded;
        break;
      case 'Konferensi':
        categoryIcon = Icons.video_call_rounded;
        break;
      case 'Keamanan':
        categoryIcon = Icons.security_rounded;
        break;
      default:
        categoryIcon = Icons.devices_rounded;
    }

    return GestureDetector(
      onTap: () => _showAssetDetail(context, asset, statusColor, statusLabel),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor.withOpacity(0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(categoryIcon, color: AppColors.accent, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        asset.category,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: GoogleFonts.outfit(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        asset.brand,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'SN: ${asset.serialNumber}',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Kondisi: ${asset.kondisi}',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(height: 4),
                Text(
                  statusLabel,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAssetDetail(
    BuildContext context,
    AssetModel asset,
    Color statusColor,
    String statusLabel,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Detail Aset',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      statusLabel,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _detailRow('Nama', asset.name),
              _detailRow('Kategori', asset.category),
              _detailRow('Brand', asset.brand),
              _detailRow('Serial Number', asset.serialNumber),
              _detailRow('Kondisi', asset.kondisi),
              _detailRow(
                'Terakhir Maintenance',
                '${asset.lastMaintenance.day}/${asset.lastMaintenance.month}/${asset.lastMaintenance.year}',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.build_rounded, size: 16),
                      label: const Text('Maintenance'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.warning,
                        side: const BorderSide(color: AppColors.warning),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
