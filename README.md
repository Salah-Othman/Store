# 🛒 Store App | Flutter & Firebase

A modern E-commerce mobile application built with **Flutter** and **Firebase**. The project follows the **MVVM (Model-View-ViewModel)** pattern and uses **Cubit** for efficient state management, focusing on clean code and a scalable folder structure.

## 🚀 Features
* **Authentication:** Secure user login and registration via Firebase Auth.
* **Product Catalog:** Real-time product listing and category filtering using Cloud Firestore.
* **Cart Management:** Add/remove items with real-time price calculation.
* **Payment:** Integrated **Cash on Delivery (COD)** checkout flow.
* **UI/UX:** Clean and responsive design inspired by Figma wireframes.

## 🏗️ Folder Structure
The project is organized into layers to ensure a clear separation of concerns, making it easy to maintain and scale:

```text
lib/
├── core/           # Constants, themes, and shared widgets.
├── data/           # Data models (Product, Order, etc.).
├── logic/          # Cubits for Business Logic (Auth, Products, Cart, Orders).
├── presentation/   # UI layer (Screens and localized widgets).
└── main.dart       # App entry point and Firebase initialization.