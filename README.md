# Rick & Morty Challenge

This application allows users to explore and view characters from the Rick and Morty universe. It was built with a focus on scalability, maintainability, and a polished user experience, providing a seamless way to discover the series' diverse cast.

### Key Features
*   **Infinite Scrolling**: Pagination is handled seamlessly as the user scrolls.
*   **Search & Filter**: Real-time name search (with debounce) and status filtering.
*   **Custom UI**: 
    *   *Portal Loading*: A custom-built, rotating portal animation instead of standard spinners.
    *   *Dynamic Detail View*: A header that blends a blurred background with a sharp foreground image for a high-quality visual effect.
*   **Error Handling**: Centralized error management with user-friendly messages for network and API issues.

## Architecture

The app follows **Clean Architecture** principles, enforcing a strict separation of concerns:

-   **Presentation Layer** (`MVVM`): SwiftUI Views and MainActor-isolated ViewModels. Handles state, user input, and navigation.
-   **Domain Layer**: Pure Swift entities, transparent Use Cases, and Repository protocols. This layer contains the business logic and is independent of frameworks.
-   **Data Layer**: Repository implementations and Networking. Responsible for fetching data, mapping DTOs, and handling errors.

### Dependency Injection
Dependencies are managed via initializer injection, originating from a Composition Root in `ContentView`. This ensures `ViewModel`s are decoupled from concrete data sources, making testing straightforward.

## Tech Stack

*   **SwiftUI** (iOS 17+)
*   **Swift Concurrency** (`async/await`)
*   **Combine** (Reactive search debounce)
*   **XCTest** (Unit & UI Testing)
*   **No 3rd Party Libraries**: All networking and image caching logic is native.

## Testing Strategy

The project includes a comprehensive test suite covering both logic and interface:

1.  **Unit Tests**:
    *   **ViewModel**: Validates state transitions, pagination logic, and search debounce behavior.
    *   **Networking**: Mocks `URLProtocol` to test API responses, decoding failures, and error mapping without making real network calls.

2.  **UI Tests**:
    *   Automated flows validating the core user journey: App Launch → List Load → Detail Navigation → Search/Filter interaction.
    *   Includes logic to verify element existence and screen transitions.

## Getting Started

### Prerequisites
*   Xcode 15+
*   iOS 17.0+ Simulator

### Installation
1.  Clone the repository.
2.  Open `rick-morty-challenge.xcodeproj`.
3.  Press `Cmd + R` to run character explorer.
4.  Press `Cmd + U` to execute the full test suite.

---

### Future Improvements

Given more time, the following areas would be prioritized to enhance the application's scalability and robustness:

*   **Extended E2E Testing**: Expand UI tests to cover edge cases, error states, and different device configurations (e.g., dynamic type, orientation changes) to ensure a flawless user experience across all scenarios.
*   **Snapshot Testing**: Implement snapshot testing to automatically detect visual regressions in the UI.
*   **Offline Support**: Integrate a local database (e.g., SwiftData or CoreData) to cache character data for offline access.
*   **Coordinator Pattern**: Extract navigation logic from Views to a dedicated Coordinator layer for more complex flows.
