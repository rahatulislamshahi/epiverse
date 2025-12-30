
# Project Blueprint

## Overview

This is a real-time chat application built with Flutter and Firebase. It allows users to create an account, log in, search for other users, chat with them in real-time, and manage their profile. The application is designed to be fully responsive, providing an optimal user experience across a wide range of devices, including mobile phones, tablets, and web browsers.

## Features

* **Authentication:**
    * User registration with email, password, and username.
    * User login with email and password.
    * Persistent login sessions.
* **User Search:**
    * Search for users by their username.
    * Navigates to a chat screen with the selected user.
* **Real-time Chat:**
    * Send and receive messages in real-time.
    * Messages are stored in Cloud Firestore.
    * Chat UI with message bubbles for sent and received messages.
    * Display of recent chats on the home screen, ordered by the most recent message.
    * Preview of the last message in the chat list.
* **User Profile:**
    * A dedicated screen for users to manage their profile.
    * Ability to update their display name and username.
    * A "Logout" button to sign out of the application.
    * A "Delete Account" option with a confirmation dialog for permanent account removal.
* **Responsive UI:**
    * **Adaptive Layout:** The application adapts its layout to different screen sizes.
    * **Constrained Forms:** The authentication and profile forms are centered and constrained in width, ensuring a comfortable user experience on wider screens.
    * **Master-Detail View:** For larger screens (tablets and web), the home screen features a master-detail layout, displaying the chat list on the left and the selected conversation on the right. On smaller screens, it presents a single-column view, navigating to a full screen for each chat.

## Project Structure

```
lib/
├── auth/
│   ├── auth_screen.dart
│   ├── login_tab.dart
│   └── registration_tab.dart
├── chat/
│   └── chat_screen.dart
├── home/
│   ├── home_screen.dart
│   └── user_search_delegate.dart
├── profile/
│   └── profile_screen.dart
├── main.dart
└── firebase_options.dart
```

## Firebase Setup

* **Authentication:** Firebase Authentication is used for user management.
* **Cloud Firestore:** Firestore is used to store user information and chat messages.
    * `users` collection: Stores user information (username, email).
    * `chats` collection: Stores chat messages between two users. Each document in this collection has a subcollection called `messages`. The document also contains a `users` array with the UIDs of the two users in the chat, the `lastMessage` text, and a `timestamp` of the last message.
