clean() {
  rm -rf build 2>/dev/null
  rm -rf *.zip 2>/dev/null
  rm -rf *.ipa 2>/dev/null
}
demo1() {
  xcodebuild \
    -scheme Todos \
    -workspace Todos.xcworkspace \
    -sdk iphonesimulator \
    -configuration Debug \
    DSTROOT=/Users/rahul/src/Todos/build/dst \
    OBJROOT=/Users/rahul/src/Todos/build/obj \
    SYMROOT=/Users/rahul/src/Todos/build/sym \
    SHARED_PRECOMPS_DIR=/Users/rahul/src/Todos/build/shared \
    -destination \
    'platform=iOS Simulator,id=7594C407-9282-477D-839C-CFC88EF23F23' \
    test
}

demo2() {
  xctool \
    -workspace Todos.xcworkspace \
    -sdk iphonesimulator \
    -scheme Todos \
    test
}
demo3() { ipa build }

demo4() { ./gradlew xcodetest }

demo5() { ./gradlew FunctionalTests:test }

run() {
  clean
  which $1
  sleep 4
  $1
}

echo "Available commands"
echo "  - demo1      Use xcodebuild to test"
echo "  - demo2      Use xctool to test"
echo "  - demo3      Use nomad-cli to build ipa"
echo "  - demo4      Use gradle to run unit tests"
echo "  - demo5      Use gradle to run functional tests"
