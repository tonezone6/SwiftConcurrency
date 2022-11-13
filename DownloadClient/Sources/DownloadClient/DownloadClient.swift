
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
        
        public var progressPercent: String {
            if case let .progress(value) = self {
                return String(format: "%.0f", value * 100) + "%"
            }
            return ""
        }
    }
}
