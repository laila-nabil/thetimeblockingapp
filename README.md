# The time blocking app

Time blocking app made with Flutter,it is a powerful and intuitive task management tool designed to help users stay organized and productive. With features inspired by [ClickUp](https://clickup.com/), Apple Reminders, [TickTick](https://ticktick.com/), and [Sorted iOS app](https://www.sortedapp.com/), users can effortlessly create tasks, set due dates, priorities, and reminders, and categorize tasks using tags. The app's auto-scheduling feature intelligently organizes tasks based on their due dates and priorities. With a user-friendly interface, search functionality, and customizable settings, this app streamlines task management for individuals, ensuring efficient and stress-free workflow.

## Table of components

- [The time blocking app](#the-time-blocking-app)
  - [Table of components](#table-of-components)
    - [Tech stack \& tools used](#tech-stack--tools-used)
      - [Planning](#planning)
      - [Frontend](#frontend)
      - [Backend](#backend)
      - [Deployment and Hosting](#deployment-and-hosting)
      - [Additional Tools and Libraries](#additional-tools-and-libraries)
      - [Testing](#testing)
      - [Analytics and security](#analytics-and-security)
      - [Other](#other)


### Tech stack & tools used

#### Planning

- **Guide**: idea to MVP Series by [Essam Cafe](https://www.youtube.com/@essamcafe)
- **Visual Planning**: [draw.io](draw.io)
- Chatgpt

#### Frontend

- **Framework**: Flutter/Dart
- **State** Management: Bloc

#### Backend

- **Backend**: Clickup API or Firebase
- **Authentication**: Clickup API or Firebase

#### Deployment and Hosting

- **Hosting**: Firebase, Google Play
- **Deployment**: *maybe* shorebird
- **Continuous Integration / Continuous Deployment (CI/CD)**: *maybe* Github CI/CD

#### Additional Tools and Libraries

- *maybe* **Responsive UI package** :
  - [responsive_framework](https://pub.dev/packages/responsive_framework)
  - [sizer](https://pub.dev/packages/sizer)
  - [screen util](https://pub.dev/packages/flutter_screenutil)

#### Testing

- **Testing**:
  - [Test](https://pub.dev/packages/test)
  - [Flutter test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)
  - [Mochito](https://pub.dev/packages/mockito)
  - [Golden toolkit](https://pub.dev/packages/golden_toolkit)
  - *maybe* [bdd widget test](https://pub.dev/packages/bdd_widget_test)
  - *maybe* Patrol
- **Code Quality**: [Dart code metrics](https://dcm.dev/)

#### Analytics and security

- **Analytics**:
  - Firebase analytics or sentry or Instabug or posthog
  - Crashlytics
  
- **Security**:
  - *maybe* flutter secure storage
  - *maybe* hive
  - *maybe* http certificate pinning
  - *maybe* encrypt package

#### Other

- **Project Management**: Github issues with <https://zube.io/>
- **Design**:
  - *maybe* [visily.com](https://app.visily.ai/)
  - *maybe* [justinmind](https://www.justinmind.com/)
  - *maybe* [figma](https://www.figma.com/)
  - *maybe* [recraft](app.recraft.ai)
  - *maybe* <https://rydmike.com/flexcolorscheme/themesplayground-v7>
  - *maybe* <https://realtimecolors.com/>
  - *maybe* <https://rydmike.com/colorscheme>
  - *maybe* <https://rydmike.com/flexcolorpicker>
- *maybe* Firebase remote config
- *maybe* mason
- *maybe* freezed
- *maybe* logger
- *maybe* cached network image
- *maybe* accessability & tooltip
- *maybe* flavors or just prod-main and dev-main
- *maybe* permission handler package