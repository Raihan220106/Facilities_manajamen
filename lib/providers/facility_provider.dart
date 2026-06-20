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
}
