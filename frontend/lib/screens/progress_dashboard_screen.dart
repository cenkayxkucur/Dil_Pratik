import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/progress.dart';
import '../screens/home_screen.dart';

// Progress providers
final progressDataProvider = StateProvider<List<Progress>>((ref) => []);
final selectedTimeRangeProvider = StateProvider<String>((ref) => 'week');

class ProgressDashboardScreen extends ConsumerStatefulWidget {
  const ProgressDashboardScreen({super.key});

  @override
  ConsumerState<ProgressDashboardScreen> createState() => _ProgressDashboardScreenState();
}

class _ProgressDashboardScreenState extends ConsumerState<ProgressDashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    setState(() => _isLoading = true);
    
    try {
      // TODO: Implement actual progress data loading from API
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));
        final mockProgress = <Progress>[
        // Mock progress data
      ];
        ref.read(progressDataProvider.notifier).state = mockProgress;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlerleme verileri yüklenemedi: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final timeRange = ref.watch(selectedTimeRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedLanguage?.flag ?? ''} İlerleme Takibi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            initialValue: timeRange,
            onSelected: (value) {
              ref.read(selectedTimeRangeProvider.notifier).state = value;
              _loadProgressData();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'week', child: Text('Bu Hafta')),
              const PopupMenuItem(value: 'month', child: Text('Bu Ay')),
              const PopupMenuItem(value: 'year', child: Text('Bu Yıl')),
              const PopupMenuItem(value: 'all', child: Text('Tüm Zamanlar')),
            ],
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.date_range),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Cards
                  _buildOverviewCards(),
                  const SizedBox(height: 24),
                  
                  // Weekly Progress Chart
                  _buildWeeklyProgressChart(),
                  const SizedBox(height: 24),
                  
                  // Skills Breakdown
                  _buildSkillsBreakdown(),
                  const SizedBox(height: 24),
                  
                  // Achievement Badges
                  _buildAchievementBadges(),
                  const SizedBox(height: 24),
                  
                  // Recent Activities
                  _buildRecentActivities(),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Toplam Seans', '24', Icons.play_circle_outline, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Toplam Dakika', '180', Icons.access_time, Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard('Haftalık Hedef', '85%', Icons.track_changes, Colors.orange)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Haftalık İlerleme',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}dk');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Text(days[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 15),
                        const FlSpot(1, 25),
                        const FlSpot(2, 20),
                        const FlSpot(3, 30),
                        const FlSpot(4, 35),
                        const FlSpot(5, 10),
                        const FlSpot(6, 20),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beceri Dağılımı',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSkillProgress('Gramer', 0.75, Colors.blue),
            const SizedBox(height: 12),
            _buildSkillProgress('Kelime Bilgisi', 0.60, Colors.green),
            const SizedBox(height: 12),
            _buildSkillProgress('Telaffuz', 0.45, Colors.orange),
            const SizedBox(height: 12),
            _buildSkillProgress('Konuşma', 0.80, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillProgress(String skill, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill, style: Theme.of(context).textTheme.bodyLarge),
            Text('${(progress * 100).toInt()}%', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildAchievementBadges() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Başarı Rozetleri',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildBadge('İlk Adım', Icons.star, Colors.amber, true),
                _buildBadge('Haftalık Kahraman', Icons.local_fire_department, Colors.orange, true),
                _buildBadge('Gramer Ustası', Icons.school, Colors.blue, false),
                _buildBadge('Konuşma Şampiyonu', Icons.mic, Colors.green, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String title, IconData icon, Color color, bool earned) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: earned ? color : Colors.grey[300],
          ),
          child: Icon(
            icon,
            color: earned ? Colors.white : Colors.grey[600],
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: earned ? Colors.black : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Son Aktiviteler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _buildActivityItem(
                  'Gramer Dersi Tamamlandı',
                  'Present Simple konusunda 95% başarı',
                  '2 saat önce',
                  Icons.check_circle,
                  Colors.green,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
