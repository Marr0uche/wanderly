import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wanderly/models/weather_data.dart';


class WeatherCard extends StatelessWidget {
  final WeatherData data;
  final String cityName;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const WeatherCard({
    super.key,
    required this.data,
    required this.cityName,
    required this.isFavorite,
    required this.onToggleFavorite,
  });
/*
  String _getBackground(String icon) {
    if (icon.startsWith("01")) return "assets/images/weather/sunny.jpg";
    if (icon.startsWith("02") || icon.startsWith("03") || icon.startsWith("04")) return "assets/images/weather/cloud.jpg";
    if (icon.startsWith("09") || icon.startsWith("10")) return "assets/images/weather/rain.jpg";
    if (icon.startsWith("11")) return "assets/images/weather/storm.jpg";
    if (icon.startsWith("13")) return "assets/images/weather/snow.jpg";
    if (icon.startsWith("50")) return "assets/images/weather/fog.jpg";
    return "assets/images/weather/default.jpg";
  }*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
  width: double.infinity,
  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: isDark ? const Color.fromARGB(255, 68, 99, 108) : const Color.fromARGB(255, 192, 204, 216),
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        blurRadius: 10,
        color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
        offset: const Offset(0, 5),
      ),
    ],
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                // City name
                Expanded(
                  child: Text(
                    cityName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: isDark ? Colors.white : const Color.fromARGB(255, 70, 68, 62),
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          // Favorite button
          IconButton(
            onPressed: onToggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
              size: 30,
            ),
          )
        ],
      ),
      const SizedBox(height: 14),
      Image.network(
        "https://openweathermap.org/img/wn/${data.iconCode}@2x.png",
        width: 60,
        height: 60,
        errorBuilder: (_, __, ___) => Icon(Icons.cloud, color: isDark ? Colors.white : const Color.fromARGB(255, 70, 68, 62)),
      ),
      Text(
        "${data.temperature}°C",
        style: theme.textTheme.displayMedium?.copyWith(
          color: isDark ? Colors.white : const Color.fromARGB(255, 70, 68, 62),
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
        ),
      ),
      const SizedBox(height: 18),
      // LINE WITH ALL DETAILS
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _smallInfo("Min/Max", "${data.minTemp}° / ${data.maxTemp}°", isDark),
          _smallInfo("Humidité", "${data.humidity}%", isDark),
          _smallInfo("Vent", "${data.windSpeed} km/h", isDark),
          _smallInfo("Ciel", data.description, isDark),
        ],
      ),
    ],
  ),
);
  }

  Widget _smallInfo(String title, String value, bool isDark) {
  final textColor = isDark ? Colors.white : const Color.fromARGB(255, 70, 68, 62);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(color: textColor, fontSize: 12)),
      const SizedBox(height: 3),
      Text(
        value,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
  }
}