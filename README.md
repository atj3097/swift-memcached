# Swift Memcached Client

A native Swift implementation of a Memcached Client using [SwiftNIO](https://github.com/apple/swift-nio) for the networking stack.
This is apart of a proposal for Google Code of Summer with the Swift Open Source Community
- [GCoS 2023 Proposal](https://docs.google.com/document/d/e/2PACX-1vSDIHtPdVJOnABKMJt7tgmoPSigE5H24kEmfrr9NiJBF29UeBT8Efrwy4UpeAIHT4UwhtDYQRZ5s_HN/pub)
- [Forum Post in the Swift Community](https://forums.swift.org/t/swift-memcached-client-gsoc-2023/63988)
<img src="swift_logo.png" alt="My Image Description" width="400" height="400">

## Features

- Asynchronous-first API
- Support for fundamental Memcached commands
- Request encoding and response decoding
- Request pipelining for improved performance

## Getting Started

### Requirements

- Swift 5.5 or later
- macOS 10.15 or later

### Installation

Add the following dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/yourusername/MemcachedClient.git", from: "1.0.0")

## Usage

```swift
import MemcachedClient

// Create a MemcachedClient instance and connect to the server
let client = MemcachedClient()
client.connect(host: "127.0.0.1", port: 11211).whenComplete { result in
    // TODO: Handle connection result...
}

// Send pipelined commands
let commands: [MemcachedCommand] = [.get(key: "example"), .set(key: "example", value: "42", flags: 0, expiration: 0)]
client.sendPipelinedCommands(channel: channel, commands: commands).whenSuccess { responses in
    // TODO: Handle Memcached responses...
}

### Contributing

Please feel free to open issues for any bugs, feature requests, or improvements you'd like to see. We appreciate any help and contributions to the project. Don't hesitate to submit pull requests with proposed changes, enhancements, or fixes. Make sure to follow the existing code style and add tests for any new functionality.
