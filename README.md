Todos
====
A sample Todos app written in Objective C that demonstrates how to use
gradle and spock to deal with iOS development.

Prerequisites
---
1. You will (of course) need a Mac running `OSX >= 10.9`.
2. You might want to install ruby in the user space using either RVM or RBENV.
3. Ensure you have java installed on your machine and JAVA_HOME setup (for gradle).
4. Ensure that you have nodejs and npm installed.

Setting up your machine
---
1. Install bundler
```bash
gem install bundler
```
2. Using bundler install cocoapods
```bash
bundle install
```
3. If you have never run cocoapods on your machine, setup cocoapods
```bash
bundle exec pod setup
```
4. Using cocoapods, install all dependencies. This will become obsolete with `org.openbakery:xcode-plugin:0.11.3`.
```bash
bundle exec pod install
```
4. Using npm, install appium.
```bash
npm install -g appium
```

Performing routine tasks
---
* To run all tests
```bash
./gradlew test
```

* To run only XCode Tests
```bash
./gradlew xcodetest
```

* To run only Functional Tests
```bash
./gradlew FunctionalTests:test
```

* To create a build
```bash
./gradlew build
```

For running functional tests, you do have to launch appium manually.
```bash
appium
```
Todo
---
* Analyze
* OCLint
* Lazybones
