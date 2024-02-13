# The time blocking app

**Time blocking app** is made with Flutter,it is a task management tool designed  to help users stay organized and productive for **personal** use. With features inspired by [ClickUp](https://clickup.com/), Apple Reminders, [TickTick](https://ticktick.com/), and [Sorted app](https://www.sortedapp.com/), users can effortlessly create tasks, set due dates, priorities, and reminders, and categorize tasks using tags. With a user-friendly interface, search functionality, and customizable settings, this app streamlines task management for individuals, ensuring efficient and stress-free workflow.

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
    - [Plan](#plan)
      - [Opportunity canvas](#opportunity-canvas)
      - [Evaluating idea using Cynefin framework](#evaluating-idea-using-cynefin-framework)
      - [Event Storming and User Stories](#event-storming-and-user-stories)
      - [Design](#design)
        - [Competitors analysis](#competitors-analysis)
        - [MVP Wireframes](#mvp-wireframes)
          - [Splash screen](#splash-screen)
          - [Authentication screens](#authentication-screens)
          - [Schedule screens](#schedule-screens)
          - [Add a task](#add-a-task)
          - [Lists screens](#lists-screens)
          - [Tags screens](#tags-screens)
          - [Settings screen](#settings-screen)

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
  - **Design Tools**:
    - Mainly [figma](https://www.figma.com/)
    - *maybe* [visily.com](https://app.visily.ai/)
    - *maybe* [justinmind](https://www.justinmind.com/)
    - *maybe* [recraft](app.recraft.ai)
    - *maybe* <https://rydmike.com/flexcolorscheme/themesplayground-v7>
    - *maybe* <https://realtimecolors.com/>
    - *maybe* <https://rydmike.com/colorscheme>
    - *maybe* <https://rydmike.com/flexcolorpicker>
  - **Design Resources**:
    - [Design systems](https://component.gallery/design-systems/)
      - [Material 3 Design Kit](https://www.figma.com/community/file/1035203688168086460/Material-3-Design-Kit)
- *maybe* Firebase remote config
- *maybe* mason
- *maybe* freezed
- *maybe* logger
- *maybe* cached network image
- *maybe* accessability & tooltip
- *maybe* flavors or just prod-main and dev-main
- *maybe* permission handler package

### Plan

When planning for this project,I followed idea to MVP Series by [Essam Cafe](https://www.youtube.com/@essamcafe) [Miro board](https://miro.com/app/board/uXjVPjEXOcw=/) *though the series is more about making a product as a team not solo,I still found it useful*

#### Opportunity canvas

[Idea to MVP Sessoion 1: exploring ideas, ترشيح الافكار](https://www.youtube.com/watch?v=jokV1oT8jqU)
> An opportunity canvas is a one-pager that helps you think through the ?>problem you're solving, the solution you're proposing, and the impact it >will have on your users and your business. It's a great tool for >validating ideas and ensuring that you're building the right thing.
>It has four key areas:
><ul>
><li>Problem: What problem are you solving for your users?</li>
><li>Solution: What is your proposed solution to the problem?</li>
><li>Impact: What impact will your solution have on your users and your business?</li>
><li>Metrics: How will you measure the success of your solution?</li>
></ul>

<details>
<summary>Opportunity canvas</summary>

![Opportunity canvas](documentation_files/opportunity_canvas.png)


</details>




#### Evaluating idea using Cynefin framework

[Idea to MVP Session 2: evaluating ideas - تقييم الأفكار واختيار فكرة المشروع](https://www.youtube.com/watch?v=rPbYbTbxOjE&ab_channel=%D9%82%D9%87%D9%88%D8%A9%D8%B9%D8%B5%D8%A7%D9%85)

<details>
<summary>Cynefin framework explanation</summary>

![Cynefin framework explanation](https://646434472-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2Fh4sMh779BAhiSQWXmjLr%2Fuploads%2Fgit-blob-d36a6f71c865a0e6785bfd44397666f84d2eb1b4%2F2022-01-27%20(8).png?alt=media)

</details>

<details>
<summary>Cynefin framework</summary>

![Cynefin framework](documentation_files/Cynefin.png)

</details>


#### Event Storming and User Stories

[Idea to MVP (3rd Session) Event storming
](https://www.youtube.com/watch?v=VwOkVMI1WLM)

[Idea to MVP Session 4: User Stories
](https://www.youtube.com/watch?v=H_vh8emSZ0I)

Features,User stories, Tasks and Spikes are inside github as issues, [The time blocking app overview](https://github.com/laila-nabil/thetimeblockingapp/issues/29) includes all of them ordered

#### Design

##### Competitors analysis
<details>
<summary>Sorted</summary>

![Sorted](documentation_files/design/competitors/sorted.png)

</details>

<details>
<summary>Apple reminder</summary>

![Apple reminder](documentation_files/design/competitors/apple_reminders.png)

</details>


<details>
<summary>TickTick</summary>

![TickTick](documentation_files/design/competitors/ticktick.png)

</details>

<details>
<summary>Fantastical</summary>

- Fantastical
![Fantastical](documentation_files/design/competitors/fantastical.png)

</details>

<details>
<summary>Clickup</summary>

- Clickup
![Clickup](documentation_files/design/competitors/clickup.png)

</details>







##### MVP Wireframes
###### Splash screen
<details>
<summary>Splash screen</summary>

![Splash screen](documentation_files/design/wireframes/Splash_screen.png)

</details>


###### Authentication screens
<details>
<summary>Only clickup</summary>

![Only clickup 1](documentation_files/design/wireframes/auth/Auth_page(clickup).png)
![Only clickup 1(redirect to clickup 1)](documentation_files/design/wireframes/auth/redirect_clickup1.png)
![Only clickup 1(redirect to clickup 2)](documentation_files/design/wireframes/auth/redirect_clickup2.png)
![Only clickup 1(redirect to clickup 3)](documentation_files/design/wireframes/auth/redirect_clickup3.png)

</details>

<details>
<summary>Anything but clickup  APIs</summary>

![Not clickup 1](documentation_files/design/wireframes/auth/Auth_page(Not_clickup)sign_in.png)
![Not clickup 2](documentation_files/design/wireframes/auth/Auth_page(Not_clickup)sign_up.png)

</details>

<details>
<summary>Clickup with other backend</summary>

![Clickup with other backend sign up](documentation_files/design/wireframes/auth/Auth_page(clickup_after_other)sign_up.png)
![Clickup with other backend sign in](documentation_files/design/wireframes/auth/Auth_page(clickup_after_other)sign_in.png)
![Clickup with other backend connect with Clickup](documentation_files/design/wireframes/auth/Auth_page(clickup_after_other)connect1.png)
![Clickup with other backend connect with Clickup(redirect to clickup 1)](documentation_files/design/wireframes/auth/redirect_clickup1.png)
![Clickup with other backend connect with Clickup(redirect to clickup 2)](documentation_files/design/wireframes/auth/redirect_clickup2.png)
![Clickup with other backend connect with Clickup(redirect to clickup 3)](documentation_files/design/wireframes/auth/redirect_clickup3.png)

</details>



###### Schedule screens
<details>
<summary>Schedule screens</summary>

![Schedule page](documentation_files/design/wireframes/schedule/Schedule1.png)
![Schedule page](documentation_files/design/wireframes/schedule/Schedule2.png)
![Schedule page](documentation_files/design/wireframes/schedule/Schedule3.png)
![Schedule page](documentation_files/design/wireframes/schedule/Schedule4.png)

</details>
  
###### Add a task

<details>
<summary>Add a task</summary>

![Add a task](documentation_files/design/wireframes/schedule/add_a_task/Add_a_task1.png)
![Add a task](documentation_files/design/wireframes/schedule/add_a_task/Add_a_task2.png)
![Add a task](documentation_files/design/wireframes/schedule/add_a_task/Add_a_task3.png)
![Add a task](documentation_files/design/wireframes/schedule/add_a_task/Add_a_task4.png)
![Add a task](documentation_files/design/wireframes/schedule/add_a_task/Add_a_task5.png)
![Add a task](documentation_files/design/wireframes/schedule/add_a_task/Add_a_task5.png)
![Add a task](documentation_files/design/wireframes/schedule/add_a_task/Add_a_task6.png)

</details>

  
###### Lists screens

<details>
<summary>Lists</summary>

![Lists page](documentation_files/design/wireframes/lists/lists0.png)
![Lists page](documentation_files/design/wireframes/lists/lists1.png)

</details>

  
###### Tags screens

<details>
<summary>Tags</summary>

![Tags page](documentation_files/design/wireframes/tags/tags0.png)
![Tags page](documentation_files/design/wireframes/tags/tags1.png)

</details>

  
###### Settings screen

<details>
<summary>Settings screen</summary>

![Settings screen](documentation_files/design/wireframes/settings.png)


</details>

