import NIO

public enum MemcachedCommand {
    case get(key: String)
    //TODO: add more commands
}

public final class MemcachedRequestEncoder: MessageToByteEncoder {
    public typealias OutboundIn = MemcachedCommand
    
    public func encode(data: MemcachedCommand, out: inout ByteBuffer) throws {
        switch data {
        case .get(let key):
            out.writeString("get \(key)\r\n")
        // TODO: encode more commands
        }
    }
}

public struct MemcachedResponse {
    let data: ByteBuffer?
    // TODO: add more response fields
}

public final class MemcachedResponseDecoder: ByteToMessageDecoder {
    public typealias InboundOut = MemcachedResponse
    
    public var cumulationBuffer: ByteBuffer?
    
    public func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        if let responseEnd = buffer.readableBytesView.firstIndex(of: UInt8(ascii: "\r")) {
            let responseData = buffer.readSlice(length: responseEnd)
            buffer.moveReaderIndex(forwardBy: 2) // Skip the "\r\n"
            return .needMoreData
        } else {
            return .needMoreData
        }
    }

}
