
   # TMDB Movies App

   An iOS application that displays movies using The Movie Database (TMDB) API.

   ## Features

   - Browse popular and top-rated movies
   - Search for movies
   - View detailed information about each movie
   - Display movie posters

   ## Setup

   1. Clone the repository:
      ```bash
      git clone https://github.com/aniketsingh55/TMDB-Movies-App.git
      ```
   2. Navigate to the project directory:
      ```bash
      cd TMDB-Movies-App
      ```
   3. Open the project in Xcode:
      ```bash
      open TMDB-Movies-App.xcodeproj
      ```
   4. Install dependencies if any (e.g., using CocoaPods or Swift Package Manager).

   ## Architecture Decisions

   - Utilizes MVVM (Model-View-ViewModel) architecture for better separation of concerns.
   - Network requests are handled using URLSession.
   - Image loading is managed with SDWebImage for efficient caching.

   ## License

   This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
