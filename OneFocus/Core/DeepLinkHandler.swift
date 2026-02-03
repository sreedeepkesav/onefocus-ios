import SwiftUI

enum DeepLink: String {
    case home
    case focus
    case insights
    case settings
    
    var url: URL? {
        URL(string: "onefocus://\(rawValue)")
    }
}

@Observable
final class DeepLinkHandler {
    var activeLink: DeepLink?
    
    func handle(_ url: URL) {
        guard url.scheme == "onefocus" else { return }
        
        let path = url.host ?? ""
        activeLink = DeepLink(rawValue: path)
    }
}
