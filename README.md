[![Swift](https://github.com/Make-a-good-soup/fugle-realtime-swift/actions/workflows/swift.yml/badge.svg)](https://github.com/Make-a-good-soup/fugle-realtime-swift/actions/workflows/swift.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmake-a-good-soup%2Ffugle-realtime-swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/make-a-good-soup/fugle-realtime-swift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmake-a-good-soup%2Ffugle-realtime-swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/make-a-good-soup/fugle-realtime-swift)

# Fugle Realtime Swift

Fugle Realtime Swift is a Swift library for accessing the Fugle Realtime API. It provides a simple and easy-to-use interface for developers to retrieve real-time stock market information. This library uses the WebSocket communication protocol and follows the API specifications provided by Fugle.

## Installation
To use Fugle Realtime Swift, you can install it using the Swift Package Manager. To add it to your project, open Xcode, select File > Swift Packages > Add Package Dependency and enter the following URL:

```script
https://github.com/Make-a-good-soup/fugle-realtime-swift
```

## Usage

To use Fugle Realtime Swift, you first need to register for a Fugle API account and obtain an API token.

```swift
import fugle_realtime_swift

let token = "your-api-token"

let result = await FugleHttpLoader().loadQuote(token: token, symbolId: symbolId)
```

## API Document

[Fugle Realtime API](https://developer.fugle.tw)

## Example

![Simulator Screen Recording - iPhone 14 Pro - 2023-02-20 at 20 02 30](https://user-images.githubusercontent.com/21169170/220100968-7f615859-5d7e-4253-a2f0-84300db69042.gif)

## Contributing
If you encounter any issues or find any bugs while using Fugle Realtime Swift, feel free to submit an issue or pull request. We welcome contributions from the developer community!

## License

Fugle Realtime Swift is released under the MIT license. See [LICENSE](https://github.com/make-a-good-soup/fugle-realtime-swift/blob/main/LICENSE) for details.
