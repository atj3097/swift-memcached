import NIO
import MemcachedClient

let client = MemcachedClient()
let channel = try client.connect(host: "localhost", port: 11211).wait()

let commands: [MemcachedCommand] = [
    .get(key: "key1"),
    .get(key: "key2"),
    // Add more commands as needed
]

let responses = try client.sendPipelinedCommands(channel: channel, commands: commands).wait()

for response in responses {
    // Process the responses
}
