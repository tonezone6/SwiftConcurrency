
import Foundation

public struct DownloadClient {
    public let download: (URL) -> AsyncThrowingStream<Status, Error>
    
    public init(download: @escaping (URL) -> AsyncThrowingStream<Status, Error>) {
        self.download = download
    }
}

extension DownloadClient {
    public enum Status {
        case idle
        case progress(Double)
        case finished(Data)
    }
}

