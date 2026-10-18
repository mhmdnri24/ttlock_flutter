import 'package:flutter/material.dart';
import 'package:ttlock_flutter/ttlock.dart';
import 'card_page.dart';

/// Halaman proses pendaftaran kartu IC ke smart lock.
///
/// Flow:
/// 1. Pilih tanggal berlaku (opsional, default 30 hari)
/// 2. Ketuk "Mulai Daftar Kartu"
/// 3. Tempelkan kartu ke lock → SDK mendeteksi otomatis
/// 4. Kartu berhasil didaftarkan → kembali ke CardPage dengan data kartu baru
class AddCardPage extends StatefulWidget {
  const AddCardPage({
    Key? key,
    required this.lockData,
    required this.lockMac,
  }) : super(key: key);

  final String lockData;
  final String lockMac;

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  // ──────────────────────────────────────────────
  // State
  // ──────────────────────────────────────────────

  final _cardNameController = TextEditingController(text: 'Kartu Baru');

  DateTime _startDate = DateTime.now();
  DateTime _endDate =
      DateTime.now().add(const Duration(days: 30));

  _AddCardStatus _status = _AddCardStatus.idle;
  String _statusMessage = 'Siap untuk mendaftarkan kartu';

  @override
  void dispose() {
    _cardNameController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // SDK call
  // ──────────────────────────────────────────────

  void _startAddCard() {
    setState(() {
      _status = _AddCardStatus.waiting;
      _statusMessage = 'Menunggu… Tempelkan kartu IC ke sensor kunci';
    });

    TTLock.addCard(
      null, // cycleList — null berarti kartu biasa (non-cyclic)
      _startDate.millisecondsSinceEpoch,
      _endDate.millisecondsSinceEpoch,
      widget.lockData,
      // progressCallback — dipanggil saat lock siap menerima kartu
      () {
        if (!mounted) return;
        setState(() {
          _status = _AddCardStatus.waiting;
          _statusMessage = 'Lock siap — tempelkan kartu IC sekarang...';
        });
      },
      // successCallback — dipanggil saat kartu berhasil terdaftar
      (cardNumber) {
        if (!mounted) return;
        setState(() {
          _status = _AddCardStatus.success;
          _statusMessage = 'Kartu berhasil didaftarkan!\nNo. Kartu: $cardNumber';
        });

        // Kembalikan data kartu baru ke CardPage
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          Navigator.pop(
            context,
            CardModel(
              cardNumber: cardNumber,
              name: _cardNameController.text.trim().isEmpty
                  ? 'Kartu'
                  : _cardNameController.text.trim(),
              startDate: _startDate,
              endDate: _endDate,
            ),
          );
        });
      },
      // failedCallback
      (errorCode, errorMsg) {
        if (!mounted) return;
        setState(() {
          _status = _AddCardStatus.error;
          _statusMessage = 'Gagal: $errorMsg\n(kode: $errorCode)';
        });
      },
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

  // ──────────────────────────────────────────────
  // Date pickers
  // ──────────────────────────────────────────────

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  // ──────────────────────────────────────────────
  // UI helpers
  // ──────────────────────────────────────────────

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  bool get _isProcessing => _status == _AddCardStatus.waiting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kartu IC'),
        centerTitle: true,
        leading: _isProcessing
            ? const SizedBox() // nonaktifkan back saat proses berlangsung
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Ilustrasi / animasi ──
              _StatusCard(
                status: _status,
                message: _statusMessage,
              ),

              const SizedBox(height: 32),

              // ── Form nama kartu ──
              if (_status == _AddCardStatus.idle) ...[
                _SectionTitle('Nama Kartu'),
                const SizedBox(height: 8),
                TextField(
                  controller: _cardNameController,
                  maxLength: 40,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Kartu Pintu Utama',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Tanggal berlaku ──
                _SectionTitle('Masa Berlaku'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _DateButton(
                        label: 'Mulai',
                        value: _fmt(_startDate),
                        onTap: _pickStartDate,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('–',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: _DateButton(
                        label: 'Selesai',
                        value: _fmt(_endDate),
                        onTap: _pickEndDate,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // ── Tombol mulai ──
                FilledButton.icon(
                  onPressed: _startAddCard,
                  icon: const Icon(Icons.credit_card),
                  label: const Text(
                    'Mulai Daftar Kartu',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],

              // ── Saat proses menunggu ──
              if (_status == _AddCardStatus.waiting) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _cancel,
                  child: const Text('Batalkan'),
                ),
              ],

              // ── Saat error ──
              if (_status == _AddCardStatus.error) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => setState(() {
                    _status = _AddCardStatus.idle;
                    _statusMessage = 'Siap untuk mendaftarkan kartu';
                  }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _cancel,
                  child: const Text('Kembali'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Status enum
// ──────────────────────────────────────────────

enum _AddCardStatus { idle, waiting, success, error }

// ──────────────────────────────────────────────
// Status card widget
// ──────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, required this.message});

  final _AddCardStatus status;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    IconData icon;
    Color bgColor;
    Color iconColor;
    bool showSpinner = false;

    switch (status) {
      case _AddCardStatus.idle:
        icon = Icons.credit_card_outlined;
        bgColor = colorScheme.primaryContainer.withOpacity(0.3);
        iconColor = colorScheme.primary;
        break;
      case _AddCardStatus.waiting:
        icon = Icons.nfc;
        bgColor = Colors.blue.shade50;
        iconColor = Colors.blue.shade700;
        showSpinner = true;
        break;
      case _AddCardStatus.success:
        icon = Icons.check_circle_outline;
        bgColor = Colors.green.shade50;
        iconColor = Colors.green.shade700;
        break;
      case _AddCardStatus.error:
        icon = Icons.error_outline;
        bgColor = Colors.red.shade50;
        iconColor = Colors.red.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          if (showSpinner)
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(iconColor),
                    strokeWidth: 3,
                  ),
                ),
                Icon(icon, size: 40, color: iconColor),
              ],
            )
          else
            Icon(icon, size: 64, color: iconColor),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: iconColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Helper widgets
// ──────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.grey.shade700,
            letterSpacing: 0.5,
          ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

