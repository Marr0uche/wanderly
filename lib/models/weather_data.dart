class WeatherData {
  final int temperature;
  final String description;
  final int humidity;
  final int minTemp;
  final int maxTemp;
  final double windSpeed;
  final String windDirection;
  final String iconCode;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.minTemp,
    required this.maxTemp,
    required this.windSpeed,
    required this.windDirection,
    required this.iconCode,
  });
}
