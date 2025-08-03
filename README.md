# 🚗 Car Route

**Car Route** is a Flutter application that allows users to select start and destination points on a map either by tapping or searching, and then displays real-time route information such as distance and estimated duration.

---

## ✨ Features

- 📍 Tap on the map to set start and destination points
- 🔍 Search by address to pinpoint locations
- 🛣️ View real-time route details including:
  - Start and destination names
  - Distance
  - Estimated time
- 📦 State management with Riverpod
- 🗺️ Interactive map using `flutter_osm_plugin`
- 🧭 User tracking with custom location markers
- 📱 Clean, modular folder structure with MVVM-style architecture

---


---

## 📸 Screens / UI Highlights

- **Feature Intro Bottom Sheet**: Guides users on app capabilities
- **OSMFlutter Map View**: Shows current position, taps for points
- **Route Info**: Displays real-time distance/time
- **Search & Select**: Choose location from geocoding suggestions

---

## 🧱 Dependencies

| Package               | Purpose                                |
|-----------------------|----------------------------------------|
| `flutter_osm_plugin`  | OpenStreetMap integration              |
| `flutter_riverpod`    | State management                       |
| `geocoding`           | Reverse geocoding (lat/long to address)|
| `location`            | For getting user's current location    |
| `flutter_screenutil`  | Responsive layout                      |

> _Note: All dependencies are defined in `pubspec.yaml`_

---

## 🔒 Permissions

Ensure the following permissions are added to your `AndroidManifest.xml` to enable location and network access:

```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
```


## 🚀 Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/yourusername/car_route.git
   cd car_route
   ```


