import Foundation

public class FugleMetaLoader {

    public init() {}

    public func load() -> Result<Meta, Error> {
        return .success(Meta())
    }
}
