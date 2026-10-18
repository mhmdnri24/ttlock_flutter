import 'package:flutter/material.dart';
import 'package:ttlock_flutter/ttlock.dart';
import 'add_card_page.dart';

/// Model lokal untuk menyimpan data kartu yang sudah ditambahkan
class CardModel {
  final String cardNumber;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  CardModel({
    required this.cardNumber,
    required this.name,
    required this.startDate,
    required this.endDate,
  });
}

/// Halaman manajemen kartu IC untuk satu smart lock
class CardPage extends StatefulWidget {
  const CardPage({
    Key? key,
    required this.lockData,
    required this.lockMac,
  }) : super(key: key);

  final String lockData;
  final String lockMac;

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  List<CardModel> _cards = [];
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchAllCards();
  }

  // ──────────────────────────────────────────────
  // SDK calls
  // ──────────────────────────────────────────────

  /// Ambil semua kartu yang tersimpan di lock
  void _fetchAllCards() {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    TTLock.getAllValidCards(
      widget.lockData,
      (cardList) {
        if (!mounted) return;
        final List<CardModel> parsed = [];
        for (final item in cardList) {
          final map = item as Map;
          parsed.add(CardModel(
            cardNumber: map['cardNumber']?.toString() ?? '',
            name: map['cardName']?.toString() ?? 'Kartu',
            startDate: DateTime.fromMillisecondsSinceEpoch(
                (map['startDate'] as int?) ?? 0),
            endDate: DateTime.fromMillisecondsSinceEpoch(
                (map['endDate'] as int?) ?? 0),
          ));
        }
        setState(() {
          _cards = parsed;
          _isLoading = false;
        });
      },
      (errorCode, errorMsg) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMsg = 'Gagal memuat kartu: $errorMsg (kode: $errorCode)';
        });
      },
    );
  }

  /// Hapus kartu berdasarkan cardNumber
  void _deleteCard(CardModel card) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kartu'),
        content: Text(
            'Yakin ingin menghapus kartu "${card.name}" (${card.cardNumber})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    TTLock.deleteCard(
      card.cardNumber,
      widget.lockData,
      () {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kartu berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchAllCards();
      },
      (errorCode, errorMsg) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus kartu: $errorMsg'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  /// Navigasi ke halaman tambah kartu
  void _goToAddCard() async {
    final result = await Navigator.push<CardModel>(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardPage(
          lockData: widget.lockData,
          lockMac: widget.lockMac,
        ),
      ),
    );
    if (result != null) {
      _fetchAllCards(); // Refresh list setelah kartu berhasil ditambahkan
    }
  }

  // ──────────────────────────────────────────────
  // UI helpers
  // ──────────────────────────────────────────────

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}';
  }

  bool _isExpired(DateTime endDate) {
    return endDate.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kartu IC'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchAllCards,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddCard,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kartu'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat data kartu...'),
          ],
        ),
      );
    }

    if (_errorMsg != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                _errorMsg!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _fetchAllCards,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.credit_card_off_outlined,
                size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Belum ada kartu terdaftar',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap tombol "+ Tambah Kartu" untuk mendaftarkan kartu IC',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 80), // ruang untuk FAB
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _cards.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _CardTile(
        card: _cards[index],
        isExpired: _isExpired(_cards[index].endDate),
        formatDate: _formatDate,
        onDelete: () => _deleteCard(_cards[index]),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Card tile widget
// ──────────────────────────────────────────────

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.card,
    required this.isExpired,
    required this.formatDate,
    required this.onDelete,
  });

  final CardModel card;
  final bool isExpired;
  final String Function(DateTime) formatDate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isExpired
                  ? Colors.grey.shade200
                  : colorScheme.primaryContainer,
              child: Icon(
                Icons.credit_card,
                color: isExpired
                    ? Colors.grey.shade500
                    : colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          card.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (isExpired)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Expired',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No. Kartu: ${card.cardNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Aktif: ${formatDate(card.startDate)} – ${formatDate(card.endDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isExpired
                          ? Colors.red.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Hapus kartu',
              icon:
                  Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

