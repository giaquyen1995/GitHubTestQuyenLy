# 🚀 GitHubTestQuyenLy

### Modern iOS GitHub User Explorer - Clean Architecture

GitHubTestQuyenLy is a modern iOS application that showcases GitHub users with detailed profiles. Built using Clean Architecture principles and a modular design approach to ensure scalability, testability, and maintainability.

![Demo](https://github.com/user-attachments/assets/5c433fcc-b827-4cb4-be9b-733f538e1645) 
![Users List](https://github.com/user-attachments/assets/f22b7011-e476-4878-ab81-d5c3ab790988)
![User Detail](https://github.com/user-attachments/assets/9f0e8b68-09f0-48f1-a27c-80e9c31630df)

## 📋 Overview

This project demonstrates:
- **Clean Architecture** with separate layers and modules
- **SwiftUI** for modern, declarative UI
- **Combine** for reactive programming
- **Realm** for efficient local data persistence

## 🏛️ Application Architecture

The application is designed following **Clean Architecture** principles to create a maintainable, flexible, and testable system. The architecture is divided into separate modules, each with clearly defined responsibilities.

| 📱 **Presentation** | 🧠 **Domain** | 💾 **Data** |
| :---: | :---: | :---: |

### 📱 Module Presentation

This module handles all user interactions and data display.

- **Views**: UI built with modern SwiftUI
  - `UsersListView`: Displays the list of GitHub users
  - `UserDetailView`: Shows detailed information about a user

- **ViewModels**: Manages state and UI logic
  - `UsersListViewModel`: Handles data and state for the list screen
  - `UserDetailViewModel`: Handles data and state for the detail screen

- **State Management**: Manages application state
  - `UsersListState`, `UserDetailState`: Tracks loading, error, and success states

- **Components**: Reusable UI components
  - `UserProfileCardView`, `UserStatView`: Components used across multiple screens

- **Router**: Handles navigation between screens

### 🧠 Module Domain

This core module contains business logic and is completely independent of any framework or platform.

- **Entities**: Business models
  - `UserEntity`: Represents a GitHub user in the application

- **UseCases**: Implements specific business logic
  - `UsersListUseCase`: Handles logic for retrieving user lists, caching, and pagination
  - `UserDetailUseCase`: Handles logic for retrieving user details

- **Repository Interfaces**: Defines interfaces for the data layer
  - `UserListRepositoryProtocol`, `UserDetailRepositoryProtocol`: Ensures Domain doesn't depend on the Data layer

### 💾 Module Data

This module is responsible for data interactions, including API and local storage.

- **Repository Implementations**: Implements interfaces from the Domain layer
  - `UserListRepository`, `UserDetailRepository`: Implements methods from Repository protocols

- **Data Sources**:
  - **Local**: Uses Realm for offline data storage
  - **Remote**: Calls GitHub API through URLSession

- **API Service**: Manages network requests
  - Handles errors, logging, and request configuration

### 🔄 Application Layer

- **Dependency Injection**: 
  - `AppDIContainer`: Manages all dependencies in the application

- **Navigation**: 
  - `NavigationHandler`: Coordinates navigation between screens

---

## 📊 Dependency Flow

![Architecture Diagram](https://github.com/user-attachments/assets/335701f5-d9c4-4971-b316-c59603423bc7)

| **Dependency Direction** | **Relationship** |
| --- | --- |
| Presentation → Domain | Presentation depends on Domain abstractions |
| Domain ↔️  | Domain has no external dependencies |
| Data → Domain | Data implements interfaces defined in Domain |

---

## 🧪 Testing Strategy

Each module is tested independently to ensure correctness and isolate errors:

- **🧩 Presentation**: Tests ViewModels with mock UseCases, focusing on state transitions and error handling
  
- **🧠 Domain**: Tests pure business logic with mock repositories, ensuring business logic works correctly
  
- **📦 Data**: Tests repositories with mock network and local storage, ensuring data is processed correctly

---

## ✨ Key Features

- 🔍 Display list of GitHub users
- 📜 Support for pagination when scrolling
- 👤 View detailed user profiles
- 💾 Offline caching with Realm
- 🔄 Pull-to-refresh functionality

---

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.0+

### Installation
1. Clone the repository
```bash
git clone https://github.com/giaquyen1995/GitHubTestQuyenLy
```

2. Open the project in Xcode
```bash
cd GitHubTestQuyenLy
open GitHubTestQuyenLy.xcworkspace
```

3. Build and run the project on your simulator or device

---

[![Created by Quyen Ly](https://img.shields.io/badge/Created%20by-Quyen%20Ly-blue?style=for-the-badge)](https://github.com/giaquyen1995)
