#  Space Launch Now (Suncorp)

## To run

1. Open project with Xcode 12.5.1 or Xcode 13.x
2. Select simular or device. Configure code signing if using device.
3. Press Run button

PS. I could not run with simulator for Xcode 12, probably because I have both Xcode 12 and 13 installed 

## To run unit tests

1. Select Unit tests tab
2. Press Run button next to "SpaceLaunchNowTests"

## Notes

- MVVM (with Combine) is used. Code is longer than MVC but better decoupling between UI and UI states.
- Dependency injection for unit tests is implemented using protocols.
