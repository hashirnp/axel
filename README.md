# Axel ToDo App (Flutter)

**Axel ToDo App** is a Flutter application developed as part of the **Axel Technologies Pvt Ltd machine test**.  
The project follows **Clean Architecture principles**, uses **BLoC** for state management, and supports **multi-user local authentication** with **offline-first behavior**.

---

## ✨ Features

### 🔐 Authentication
- Local multi-user authentication
- Username uniqueness validation
- Password strength validation
- login attempt lock after multiple failed attempts
- **Remember Me** option
- Persistent login session using local storage

---

### 📝 To-Do Management
- Fetch todos from public API  
  `https://jsonplaceholder.typicode.com/todos`
- Pagination (lazy loading)
- Pull-to-refresh
- Search with debounce
- Offline caching
- Per-user favorites stored locally
- Favorites persist across app restarts
- Proper handling of:
  - Loading states
  - Empty states
  - Error states

---

### 👤 Profile Management
- Profile stored per user
- Edit profile details:
  - Name
  - Date of Birth
  - Profile picture
- Profile data isolated per user session
- Local persistence

---

### ⚙️ Settings
- Light / Dark theme toggle
- Clear cached data
- Logout

---

## 🏗 Architecture
The application follows **Clean Architecture** with a clear separation of concerns:

- **Domain Layer** – Business logic and use cases
- **Data Layer** – Repositories, API, and local storage

Each feature is isolated and independently manageable.

---

## 🔄 State Management
- `flutter_bloc`
- Feature-specific blocs:
  - `AuthBloc`
  - `TodoBloc`
  - `ProfileBloc`
  - `SettingsBloc`
- `AppBloc` for global coordination:
  - User session changes
  - Cache clearing
  - Resetting user-scoped states

User-scoped blocs automatically refresh when the active user changes.

---

## 🌐 Network Layer
- `Dio` for API communication
- Separate Dio clients for each flavor
- Centralized error handling
- Repository pattern for data access

---

## 💾 Local Storage
- `SharedPreferences`
- Users stored as a map (`username → user data`)
- Profiles stored per user
- Favorites stored per user
- Offline todo caching
- Safeguards against corrupted local data

---

## 🧪 App Flavors

### Available Flavors
- `staging`
- `production`

### Run Commands

**Staging**
```bash
flutter run --flavor staging
```

**Production**
```bash
flutter run --flavor production
```

---

## 🧩 Dependency Injection
- `injectable`
- `get_it`
- Lazy singleton pattern
- Dependency initialization performed during splash screen

---

## 📱 Platform Support
- Android

---

## ⏱ Time Constraint
This project was developed within the **4-hour machine test duration**, focusing on:
- Clean architecture
- Scalable state management
- Real-world use cases
- Code quality and maintainability

---

## 👨‍💻 Author
**Hashir N P**  
Flutter Developer

---

## 📝 Final Notes
This project emphasizes **clean code**, **maintainability**, and **real-world architectural patterns**, rather than only minimal UI implementation.

The structure and state flow are designed to **scale easily** and support future feature additions.