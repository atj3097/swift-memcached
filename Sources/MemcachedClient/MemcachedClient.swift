import NIO
import Logging

public class MemcachedClient {
    private let eventLoopGroup: EventLoopGroup
    private let bootstrap: ClientBootstrap
    private let logger: Logger
    
    public init(eventLoopGroup: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)) {
        self.eventLoopGroup = eventLoopGroup
        self.logger = Logger(label: "MemcachedClient")
        
        bootstrap = ClientBootstrap(group: eventLoopGroup)
            .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .channelInitializer { channel in
                channel.pipeline.addHandler(ByteToMessageHandler(MemcachedResponseDecoder()))
            }
    }
    
    deinit {
        try? eventLoopGroup.syncShutdownGracefully()
    }
    
    public func connect(host: String, port: Int) -> EventLoopFuture<Channel> {
        let remoteAddress = try! SocketAddress.makeAddressResolvingHost(host, port: port)
        return bootstrap.connect(to: remoteAddress)
    }
    
    public func sendPipelinedCommands(channel: Channel, commands: [MemcachedCommand]) -> EventLoopFuture<[MemcachedResponse]> {
        let promise = channel.eventLoop.makePromise(of: [MemcachedResponse].self)
        var responses = [EventLoopFuture<MemcachedResponse>]()
        
        for command in commands {
            let responsePromise = channel.eventLoop.makePromise(of: MemcachedResponse.self)
            responses.append(responsePromise.futureResult)
            let writeFuture = channel.writeAndFlush(command)
            writeFuture.whenComplete { _ in
                _ = channel.pipeline.addHandler(ResponseHandler(promise: responsePromise), name: nil, position: .last)
            }
        }
        
        EventLoopFuture.whenAllComplete(responses, on: channel.eventLoop).map { results in
            return results.compactMap { result -> MemcachedResponse? in
                switch result {
                case .success(let response):
                    return response
                case .failure:
                    return nil
                }
            }
        }.cascade(to: promise)
        
        return promise.futureResult
    }





}

