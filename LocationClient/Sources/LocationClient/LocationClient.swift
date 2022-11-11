
import MapKit

struct LocationClient {
    let requestLocation: () async throws -> CLLocationCoordinate2D?
}
