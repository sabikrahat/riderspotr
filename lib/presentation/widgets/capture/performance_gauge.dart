import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PerformanceGaugeWidget extends StatelessWidget {
  final double accel1;
  final double accel2;
  final double accel3;
  final double topSpeed;
  final String speedUnit;

  const PerformanceGaugeWidget({
    super.key,
    this.accel1 = 2.8,
    this.accel2 = 2.8,
    this.accel3 = 2.8,
    this.topSpeed = 200.0,
    this.speedUnit = 'km/h',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87, // Dark background to match the image
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAccelBadge(true, accel1),
              _buildAccelBadge(false, accel2),
              _buildAccelBadge(false, accel3),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200, // Adjust height as needed
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: topSpeed,
                  startAngle: 180,
                  endAngle: 0,
                  showLabels: false,
                  showAxisLine: true,
                  ticksPosition: ElementsPosition.outside,
                  majorTickStyle: const MajorTickStyle(
                    length: 8,
                    thickness: 2,
                    color: Colors.white,
                  ),
                  minorTicksPerInterval: 4,
                  minorTickStyle: const MinorTickStyle(
                    length: 4,
                    thickness: 1,
                    color: Colors.white70,
                  ),
                  axisLineStyle: AxisLineStyle(
                    thickness: 12,
                    gradient: const SweepGradient(
                      colors: [Colors.blueAccent, Colors.cyanAccent],
                      stops: [0.0, 1.0],
                    ),
                  ),
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: topSpeed, // Point to max for "top speed"
                      needleLength: 0.95,
                      needleStartWidth: 0,
                      needleEndWidth: 4,
                      needleColor: Colors.blueAccent,
                      knobStyle: const KnobStyle(knobRadius: 0),
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            topSpeed.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            speedUnit,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      angle: 270,
                      positionFactor: 0.35, // Position above the bottom arc
                    ),
                    GaugeAnnotation(
                      widget: const Text(
                        'TOP SPEED',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      angle: 270,
                      positionFactor: 0.8, // Below the value
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccelBadge(bool hasLightning, double value) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blueAccent, width: 1.5),
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasLightning)
            const Icon(
              Icons.bolt,
              color: Colors.white,
              size: 20,
            ),
          Text(
            value.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            '0-60 mph',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
