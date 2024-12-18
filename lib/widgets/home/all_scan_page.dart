
import 'package:eat_this_app/app/data/models/history_model.dart';
import 'package:eat_this_app/app/modules/home/controllers/home_controller.dart';
import 'package:eat_this_app/app/utils/date_utils.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:get/get.dart';

class AllScanPage extends GetView<HomeController> {
  const AllScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scan History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'All History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTodayScans(),
            _buildAllScans(),
          ],
        ),
      ),
    );
  }

Widget _buildTodayScans() {
  return Obx(() {
    if (controller.isLoadingScans.value) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter untuk scan hari ini
    final todayScans = controller.recentScans.where((scan) {
      if (scan.pivot?.createdAt == null) return false;
      
      try {
        return DateUtils.isToday(scan.pivot?.createdAt);
      } catch (e) {
        print('Error filtering today scans: $e');
        return false;
      }
    }).toList();

    // Sort by time (newest first)
    todayScans.sort((a, b) {
      if (a.pivot?.createdAt == null || b.pivot?.createdAt == null) return 0;
      
      final dateA = DateTime.parse(a.pivot!.createdAt!).toLocal();
      final dateB = DateTime.parse(b.pivot!.createdAt!).toLocal();
      return dateB.compareTo(dateA);
    });

    if (todayScans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No scans today',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadRecentScans(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: todayScans.length,
        itemBuilder: (context, index) {
          print("berapa index di history: $index");
          final scan = todayScans[index];
          return Column(
            children: [
              if (index == 0 || _shouldShowTimeHeader(scan, todayScans[index - 1]))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: Text(
                    DateUtils.formatTimeOnly(scan.pivot?.createdAt),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              _buildScanCard(scan),
            ],
          );
        },
      ),
    );
  });
}

bool _shouldShowTimeHeader(Products currentScan, Products previousScan) {
  if (currentScan.pivot?.createdAt == null || previousScan.pivot?.createdAt == null) {
    return false;
  }

  final currentTime = DateTime.parse(currentScan.pivot!.createdAt!).toLocal();
  final previousTime = DateTime.parse(previousScan.pivot!.createdAt!).toLocal();

  return currentTime.hour != previousTime.hour || 
         currentTime.minute != previousTime.minute;
}

  Widget _buildAllScans() {
    return Obx(() {
      if (controller.isLoadingScans.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.recentScans.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No scan history',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      // Group scans by date
      final groupedScans = <String, List<Products>>{};
   for (var scan in controller.recentScans) {
      if (scan.pivot?.createdAt != null) {
        final date = DateUtils.formatDateOnly(scan.pivot?.createdAt);
        groupedScans.putIfAbsent(date, () => []);
        groupedScans[date]!.add(scan);
      }
   }

      return RefreshIndicator(
        onRefresh: () => controller.loadRecentScans(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupedScans.length,
          itemBuilder: (context, index) {
            final date = groupedScans.keys.elementAt(index);
            final scans = groupedScans[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ...scans.map((scan) => _buildScanCard(scan)).toList(),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      );
    });
  }

  Widget _buildScanCard(Products scan) {
 final scanTime = DateUtils.formatTimeOnly(scan.pivot?.createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: scan.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  scan.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              )
            : Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
        title: Text(
          scan.name ?? 'Unknown Product',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scanTime),
            if (scan.nutriscore != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getNutriscoreColor(scan.nutriscore),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Nutriscore ${scan.nutriscore?.toUpperCase() ?? ""}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () => Get.toNamed('/product/alternative', arguments: scan.id),
      ),
    );
  }

  Color _getNutriscoreColor(String? score) {
    switch (score?.toLowerCase()) {
      case 'a':
        return Colors.green;
      case 'b':
        return Colors.lightGreen;
      case 'c':
        return Colors.yellow[700]!;
      case 'd':
        return Colors.orange;
      case 'e':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}