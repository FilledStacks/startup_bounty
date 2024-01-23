# Startup Bounty

I need to read a value from disk, and I haven't been able to do that. 

The value has to be read from disk in the `main` function, before calling `WidgetsFlutterBinding.ensureInitialized()`.

If you can implement this functionality I will send you $100 USD

## Requirements

- If you write the data to a file, the path has to come from the official documents directory for the platform it's running on

- You can't use a backend solutions

## Submission

Submit a PR with your solution along with an explanation of what you did and how it works.

## How paths are determined?

### Web

- Config are stored in localstorage of website in the browser using dart's window.localstorage https://api.dart.dev/stable/3.2.5/dart-html/Window/localStorage.html API. 
- For the web, it is https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage in javascript.

## Android

- Android official APIs provide `/data/user/<userId>/<appPackageName>` as the application's documents directory.
- This path isn't mentioned in the API's documentation at https://developer.android.com/training/data-storage but mentioned in the Device paths section of Testing Multiple Users for app storage https://source.android.com/docs/devices/admin/multi-user-testing#device-paths  

## iOS

- Right now, we get app's bundle container path by taking the parent path from the result of dart's `Platform.executable`. Storing files here is not right and only seems to be working on iOS simulator.
- The app's document data directory is in data container director which requires knowning app separate UUID for data container. I couldn't find a way to get it this UUID or data container path. 
- Reference: "iOS Standard Directories: Where Files Reside" section in https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

## MacOS

- I observed that in release mode, the environment variable `HOME` returns the app's data container location.
- Reference: "macOS Standard Directories: Where Files Reside" section in https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

## Windows

- Created a directory for storing app's data in the directory path received from environment variable `LOCALAPPDATA`.
- The app directory is created using app's provided package name. for example, when app's package name is `com.example.app`, the directory name will be `com.example/app`. 
- For storing app config for a user, windows had in the reference document to use the env variable APPDATA or LOCALAPPDATA. Reference: Reference: https://web.archive.org/web/20120905053951/http://download.microsoft.com/download/e/6/a/e6aa654f-cccb-421e-9b50-3392e9886084/VistaFileSysNamespaces.pdf

## What's a more reliable solution?

Getting these path from platform's official APIs.
1. One way to do this is to use method channels from flutter to communicate with platform code but doing this will be breaking the requirement for this task.
2. We could build our own way to communicate from dart to platform code without using flutter. I will need to research to say more about how this approach can be taken to solve this problem reliably.
