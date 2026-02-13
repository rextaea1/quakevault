import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/earthquake.dart';

class EarthquakeCard extends StatelessWidget {
  final Earthquake earthquake;
  final bool isHighlighted;

  const EarthquakeCard({
    super.key,
    required this.earthquake,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isHighlighted 
          ? earthquake.magnitudeColor.withValues(alpha: 0.15)
          : null,
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Magnitude indicator
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: earthquake.magnitudeColor.withValues(
                    alpha: isHighlighted ? 0.3 : 0.2
                  ),
                  shape: BoxShape.circle,
                  border: isHighlighted
                      ? Border.all(
                          color: earthquake.magnitudeColor,
                          width: 2,
                        )
                      : null,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        earthquake.magnitudeString,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: earthquake.magnitudeColor,
                        ),
                      ),
                      const Text('M', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            earthquake.locationString,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isHighlighted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.5),
                              ),
                            ),
                            child: const Text(
                              'LATEST',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      earthquake.place,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          earthquake.timeAgo,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.arrow_downward, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          earthquake.depthString,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        if (earthquake.tsunami == 1) ...[
                          const SizedBox(width: 16),
                          Icon(Icons.warning, size: 12, color: Colors.red.shade400),
                          const SizedBox(width: 4),
                          Text(
                            'Tsunami',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1E35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Earthquake Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Magnitude', earthquake.magnitudeString),
              _buildDetailRow('Depth', earthquake.depthString),
              _buildDetailRow('Location', earthquake.place),
              _buildDetailRow(
                'Time',
                DateFormat('MMM dd, yyyy HH:mm:ss').format(earthquake.time),
              ),
              _buildDetailRow(
                'Coordinates',
                '${earthquake.latitude.toStringAsFixed(3)}, ${earthquake.longitude.toStringAsFixed(3)}',
              ),
              if (earthquake.tsunami == 1) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade700),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'TSUNAMI WARNING - Evacuate coastal areas',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(earthquake.usgsUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('View on USGS'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}