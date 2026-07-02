import 'package:flutter/material.dart';
import '../models/facility_model.dart';
import '../utils/dummy_data.dart';

class FacilityProvider extends ChangeNotifier {
  List<GedungModel> _gedungList = [];
  List<MaintenanceRecord> _maintenanceRecords = [];
  List<LaporanKerusakan> _laporanKerusakan = [];

  List<GedungModel> get gedungList => _gedungList;
  List<MaintenanceRecord> get maintenanceRecords => _maintenanceRecords;
  List<LaporanKerusakan> get laporanKerusakan => _laporanKerusakan;

  FacilityProvider() {
    _loadData();
  }

  void _loadData() {
    _gedungList = DummyData.gedungList;
    _maintenanceRecords = DummyData.maintenanceRecords;
    _laporanKerusakan = DummyData.laporanKerusakan;
    notifyListeners();
  }

  // ============================================================
  // DASHBOARD STATS
  // ============================================================
  int get totalGedung => _gedungList.length;

  int get totalAsset {
    int count = 0;
    for (var g in _gedungList) {
      for (var l in g.lantai) {
        for (var r in l.ruangan) {
          count += r.assets.length;
        }
      }
    }
    return count;
  }

  int get totalAssetBaik {
    int count = 0;
    for (var g in _gedungList) {
      for (var l in g.lantai) {
        for (var r in l.ruangan) {
          count += r.assets.where((a) => a.status == AssetStatus.baik).length;
        }
      }
    }
    return count;
  }

  int get totalAssetRusak {
    int count = 0;
    for (var g in _gedungList) {
      for (var l in g.lantai) {
        for (var r in l.ruangan) {
          count += r.assets.where((a) => a.status == AssetStatus.rusak).length;
        }
      }
    }
    return count;
  }

  int get totalAssetMaintenance {
    int count = 0;
    for (var g in _gedungList) {
      for (var l in g.lantai) {
        for (var r in l.ruangan) {
          count +=
              r.assets.where((a) => a.status == AssetStatus.maintenance).length;
        }
      }
    }
    return count;
  }

  int get totalLaporan => _laporanKerusakan.length;
  int get laporanBelumDitindak =>
      _laporanKerusakan.where((l) => !l.sudahDitindak).length;

  int get maintenanceAktif =>
      _maintenanceRecords
          .where((m) =>
              m.status == MaintenanceStatus.proses ||
              m.status == MaintenanceStatus.menunggu)
          .length;

  // ============================================================
  // GEDUNG OPERATIONS
  // ============================================================
  GedungModel? getGedungById(String id) {
    try {
      return _gedungList.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  List<AssetModel> getAllAssets() {
    List<AssetModel> all = [];
    for (var g in _gedungList) {
      for (var l in g.lantai) {
        for (var r in l.ruangan) {
          all.addAll(r.assets);
        }
      }
    }
    return all;
  }

  Map<String, int> get assetByCategory {
    Map<String, int> map = {};
    for (var asset in getAllAssets()) {
      map[asset.category] = (map[asset.category] ?? 0) + 1;
    }
    return map;
  }

  // ============================================================
  // MOBILE COMPUTING SPECIAL COMPONENT: Future & Stream Simulation
  // ============================================================

  // Untuk FutureBuilder: Simulasi pengambilan data gedung dari API dengan delay 1.5 detik
  Future<List<GedungModel>> getGedungListAsync() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return _gedungList;
  }

  // Untuk StreamBuilder: Aliran data log aktivitas sistem real-time setiap 4 detik
  Stream<String> get activityLogStream {
    final List<String> logs = [
      'Gedung Utama: Lift Lantai 2 berfungsi normal setelah maintenance.',
      'Gedung IT: Sensor suhu Ruang Server mendeteksi suhu aman (21°C).',
      'Gedung B: Petugas Sari memulai patroli rutin di Lantai 1.',
      'Gedung Utama: AC Ruang Rapat A dibersihkan oleh vendor.',
      'Gedung Utama: Penggantian lampu koridor Lantai 3 selesai.',
      'Gedung B: Pengecekan APAR di Lantai 2 terverifikasi aman.',
      'Gedung IT: Akses pintu Ruang Server dibuka oleh Admin.',
    ];
    return Stream.periodic(const Duration(seconds: 4), (count) {
      return logs[count % logs.length];
    });
  }
}
