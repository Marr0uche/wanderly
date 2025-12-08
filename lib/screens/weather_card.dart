import 'package:flutter/material.dart';
import 'package:wanderly/models/weather_data.dart';


class WeatherCard extends StatelessWidget {
  final WeatherData data;

  const WeatherCard(this.data, {super.key});
String _getBackground(String icon) {
  // ciel clair
  if (icon.startsWith("01")) {
    return "assets/images/weather/sunny.jpg"; 
  }

  // nuageux
  if (icon.startsWith("02") || icon.startsWith("03") || icon.startsWith("04")){
    return "assets/images/weather/cloud.jpg";                                 
  }

  // pluie
  if (icon.startsWith("09") || icon.startsWith("10")){
    return "assets/images/weather/rain.jpg";          
  }

  // orage
  if (icon.startsWith("11")) return "assets/images/weather/storm.jpg";

  // neige
  if (icon.startsWith("13")) return "assets/images/weather/snow.jpg";      
  
    
  if (icon.startsWith("50")) return "assets/images/weather/fog.jpg";

  return "assets/images/weather/default.jpg";
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return 
    Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.all(18),

      // ⬇️ Nouvelle décoration avec image dynamique
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        image: DecorationImage(
          image: AssetImage(_getBackground(data.iconCode)),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(isDark ? 0.45 : 0.25),
            BlendMode.darken,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
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
                      color: Colors.white,
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
                  _infoColumn(theme, title: "Min/Max", value: "${data.minTemp}° / ${data.maxTemp}°"),
                ],
              ),

              const SizedBox(height: 16),

              // Humidité + Vent
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn(theme, title: "Humidité", value: "${data.humidity}%"),
                  _infoColumn(theme, title: "Vent", value: "${data.windSpeed} km/h ${data.windDirection}"),
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
