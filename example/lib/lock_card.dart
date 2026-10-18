
import 'package:flutter/material.dart';

class LockCard extends StatelessWidget {
  const LockCard({
    super.key,
    required this.roomName,
    required this.lockMac,
    required this.connected,
    this.battery,
    this.locked,
    required this.onTap,
  });

  final String roomName;
  final String lockMac;
  final bool connected;
  final int? battery;
  final bool? locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor:
                        colorScheme.primaryContainer,
                    child: Icon(
                      Icons.door_front_door_outlined,
                      color: colorScheme.onPrimaryContainer,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          roomName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lockMac,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    connected
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth_disabled,
                    color: connected
                        ? Colors.blue
                        : colorScheme.outline,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.battery_charging_full,
                      label: 'Baterai',
                      value: battery == null
                          ? 'Belum diperiksa'
                          : '$battery%',
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.lock_outline,
                      label: 'Status kunci',
                      value: locked == null
                          ? 'Belum diperiksa'
                          : locked!
                              ? 'Terkunci'
                              : 'Terbuka',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onTap,
                  child: const Text('Detail Smart Lock'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
