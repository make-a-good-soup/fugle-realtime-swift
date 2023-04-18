import Foundation

enum FetchPhase<V> {

    case initial
    case fetching
    case success(V)
    case failure(Error)
    case empty

    var value: V? {
        if case .success(let v) = self {
            return v
        }
        return nil
    }

    var error: Error? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }

}
