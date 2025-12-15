# wanderly

<div align="center"> 
  <img src="/assets/screenshots/wanderly.gif" alt="demo" />
</div>

Wanderly est une application Flutter permettant de découvrir une ville, d'explorer ses lieux d'intérêt, de gérer des villes et lieux favoris, et d'ajouter des lieux personnalisés avec notes et évaluations.

L'application fonctionne sur **mobile, web et desktop** et s'appuie sur des données OpenStreetMap.

## Structure du projet
Le projet est organisé de manière modulaire afin de séparer clairement la logique métier, l'interface utilisateur et l'accès aux données.
```bash
lib/
├── app.dart
├── main.dart
│
├── db/
│ └── database_helper.dart
│
├── models/
│ ├── city_location.dart
│ ├── lieu.dart
│ └── weather_data.dart
│
├── providers/
│ ├── map_provider.dart
│ ├── favorites_provider.dart
│ ├── favorite_places_provider.dart
│ └── theme_provider.dart
│
├── screens/
│ ├── accueil_screen.dart
│ ├── home_page.dart
│ ├── map_page.dart
│ └── favorites_page.dart
│
├── utils/
│ ├── location_service.dart
│ ├── nominatim_service.dart
│ ├── overpass_service.dart
│ ├── weather_service.dart
│ ├── place_details.dart
│ └── map_dialogs.dart
│
├── widgets/
│ └── FavoriteCities/
│     ├── delete_confirmation_modal.dart
│     ├── favorite_city_card.dart
│     └── empty_cities_page.dart
│
│ └── favoritePlaces/
│     ├── favorite_place_card.dart
│     └── favoriteplaces.dart
│
│ └── PlaceDetails/
│     ├── place_details_header.dart
│     ├── place_details_info.dart
│     ├── place_details_sheet.dart
│     ├── place_details_additional_info_card.dart
│     ├── place_details_contact_card.dart
│     ├── place_details_image_card.dart
│     ├── place_details_user_review_card.dart
│     └── place_note_dialog.dart
│
│ ├── category_button.dart
│ ├── map_search_bar.dart
│ ├── map_widget.dart
│ ├── search_city.dart
│ └── weather_card.dart
```
---


## Choix techniques

### APIs et services utilisés

- **OpenStreetMap**
  - Données cartographiques
- **Nominatim**
  - Recherche de villes
  - Suggestions de villes
  - Recherche de lieux par nom
- **Overpass API**
  - Récupération des lieux d'intérêt (parcs, musées, restaurants, universités, etc.)
- **OpenWeather**  
  - Affichage de la météo de la ville sélectionnée

### Gestion d'état

- **Provider**
   - `MapProvider` : gestion de la carte, de la ville courante et des recherches
   - `FavoritesProvider` : gestion des villes favorites
   - `FavoritePlacesProvider` : gestion des lieux favoris (avec notes et évaluations)
   - `ThemeProvider` : gestion du thème clair / sombre

### 🗄️ Modèle de données & persistance

- **SQLite (sqflite / sqflite_common_ffi)**
- Stockage local pour :
  - villes favorites
  - lieux favoris
  - notes personnelles
  - lieux personnalisés ajoutés par l'utilisateur

---


## 🖼️ Captures d'écran
### Page d'accueil
<div align="center"> 
  <img src="/assets/screenshots/welcome_page.png" alt="welcome_page" width="200"/>
</div>

### Page principale avec carte et météo
<div align="center"> 
  <img src="/assets/screenshots/home_screen.png" alt="home_screen" width="600"/>
  <hr>
  <img src="/assets/screenshots/home_screen2.png" alt="home_screen2" width="600"/>
</div>

### Barre de Menu
<div align="center"> 
  <img src="/assets/screenshots/menu_bar.png" alt="menu_bar" width="400"/>
</div>

### Page des villes favorites
<div align="center">
  <img src="/assets/screenshots/favorite_cities.png" alt="favorite_cities" width="400"/>
</div>

### Page des détails d'un lieu
<div align="center">
  <img src="/assets/screenshots/location_details.png" alt="location_details" width="400"/>
</div>



## 🚀 Lancement du projet

1. Installer Flutter  
2. Récupérer les dépendances :
```bash
flutter pub get
```
3. Ajouter un fichier `.env` à la racine du projet ainsi que dans /assets avec la clé API API_KEY_OPENWEATHER.
4. Lancer l'application :
```bash
flutter run
```
