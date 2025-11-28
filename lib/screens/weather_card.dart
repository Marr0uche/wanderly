import 'package:flutter/material.dart';
import 'package:wanderly/models/weather_data.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData data;

  const WeatherCard(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 350;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // température + icône
              Row(
                children: [
                  Image.network(
                    "https://openweathermap.org/img/wn/${data.iconCode}@2x.png",
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 40);
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${data.temperature}°",
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmall ? 42 : 56,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Météo row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn(theme, title: "Météo", value: data.description),
                  _infoColumn(
                    theme,
                    title: "Min/Max",
                    value: "${data.minTemp}° / ${data.maxTemp}°",
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Humidité + Vent
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn(theme, title: "Humidité", value: "${data.humidity}%"),
                  _infoColumn(
                    theme,
                    title: "Vent",
                    value: "${data.windSpeed} km/h ${data.windDirection}",
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoColumn(
    ThemeData theme, {
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
