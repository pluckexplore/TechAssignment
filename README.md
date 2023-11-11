# iOS User Management App

## Introduction

Hello there! I'm Polina, an iOS Engineer, and I'm excited to present my latest iOS application. 

## Features

### User List Screen

- **ViewController with TableView:** The primary screen showcases a list of users through a table view.
- **Input/Output Pattern:** The communication between View and ViewModel follows the Input/Output pattern, ensuring a modular and maintainable architecture.
- **Data Fetching:** Upon loading the screen, the app uses URLSession to fetch data from a remote source, seamlessly merging it into CoreData.
- **Responsive UI:** The fetched data is then elegantly displayed on the screen, providing users with a smooth and engaging experience.

### Add User Screen

- **ViewController with Inputs:** The second screen allows users to add new entries through intuitive input fields.
- **Validation Rules:** User Name and E-mail fields undergo validation. If validation is not successful, users receive clear feedback on what needs correction.
- **Duplicate Check:** The app checks for duplicates in the database, ensuring data integrity. Users are promptly notified about the success or errors of their actions.

## Project Details

- **API link:** [https://jsonplaceholder.typicode.com/users](https://jsonplaceholder.typicode.com/users)
- **Technology Stack:**
  - **Design Pattern:** MVVM (Model-View-ViewModel), ensuring a structured and scalable codebase.
  - **UIKit:** Harnessing the power of UIKit for building a sleek and user-friendly interface.
  - **Target:** iOS 15.0+, embracing the latest iOS capabilities.
  - **URLSession:** Handling data fetching from the remote API.
  - **CoreData:** Efficiently managing local data storage for enhanced user experiences.
  - **Structured Concurrency:** Employing asynchronous programming for responsive data handling.
  - **Combine:** Integrating the Combine framework for reactive and interactive UI updates.

## Getting Started

To run this app, make sure you have Xcode installed and set the deployment target to iOS 15.0 or later. Simply clone the repository, open the project in Xcode, and run the app on your iOS device or simulator.

Feel free to explore, contribute, and enhance the app. Happy coding! 
