@testable import MemcachedClient
import NIO
import XCTest

final class MemcachedClientTests: XCTestCase {
    func testSendPipelinedCommands() throws {
        let client = MemcachedClient()
        let channel = try client.connect(host: "localhost", port: 11211).wait()
        
        let commands: [MemcachedCommand] = [
            .get(key: "key1"),
            .get(key: "key2"),
            // Add more commands as needed
        ]
        
        let expectation = XCTestExpectation(description: "Pipelined commands should succeed")
        
        client.sendPipelinedCommands(channel: channel, commands: commands).whenComplete { result in
            switch result {
            case .success(let responses):
                // Add assertions based on the expected responses
                XCTAssertEqual(responses.count, commands.count)
            case .failure(let error):
                XCTFail("Failed to send pipelined commands: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
