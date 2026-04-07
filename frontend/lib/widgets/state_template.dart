import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Ortak state template widget - Loading, Error, Empty, Success durumları için
class StateTemplate<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T data) dataBuilder;
  final String? emptyMessage;
  final String? errorTitle;
  final VoidCallback? onRetry;
  final Widget? customLoading;
  final Widget? customError;
  final Widget? customEmpty;

  const StateTemplate({
    Key? key,
    required this.asyncValue,
    required this.dataBuilder,
    this.emptyMessage,
    this.errorTitle,
    this.onRetry,
    this.customLoading,
    this.customError,
    this.customEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (data) {
        // Empty state kontrolü
        if (_isEmpty(data)) {
          return customEmpty ?? _buildEmptyState(context);
        }
        return dataBuilder(data);
      },
      loading: () => customLoading ?? _buildLoadingState(),
      error: (error, stackTrace) => customError ?? _buildErrorState(context, error),
    );
  }

  bool _isEmpty(T data) {
    if (data is List) return data.isEmpty;
    if (data is Map) return data.isEmpty;
    if (data is String) return data.isEmpty;
    return data == null;
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Yükleniyor...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              errorTitle ?? 'Bir Hata Oluştu',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(error),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage ?? 'Henüz veri bulunmuyor',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  String _getErrorMessage(Object error) {
    if (error.toString().contains('Network')) {
      return 'İnternet bağlantınızı kontrol edin';
    } else if (error.toString().contains('timeout')) {
      return 'Bağlantı zaman aşımına uğradı';
    } else if (error.toString().contains('404')) {
      return 'İstenen kaynak bulunamadı';
    } else if (error.toString().contains('500')) {
      return 'Sunucu hatası oluştu';
    } else {
      return 'Beklenmeyen bir hata oluştu\n${error.toString()}';
    }
  }
}
