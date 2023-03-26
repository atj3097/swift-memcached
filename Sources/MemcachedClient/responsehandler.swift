import NIO

final class ResponseHandler: ChannelInboundHandler, RemovableChannelHandler {
    func removeHandler(context: NIOCore.ChannelHandlerContext, removalToken: NIOCore.ChannelHandlerContext.RemovalToken) {
        
    }
    
    typealias InboundIn = MemcachedResponse
    
    private let promise: EventLoopPromise<MemcachedResponse>
    
    init(promise: EventLoopPromise<MemcachedResponse>) {
        self.promise = promise
    }
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let response = unwrapInboundIn(data)
        promise.succeed(response)
        _ = context.pipeline.removeHandler(self)
    }
    
    func errorCaught(context: ChannelHandlerContext, error: Error) {
        promise.fail(error)
        _ = context.pipeline.removeHandler(self)
    }
}
