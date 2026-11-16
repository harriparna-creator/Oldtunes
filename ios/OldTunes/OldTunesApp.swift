import SwiftUI
import AVFoundation

// Old Tunes for iPhone: a native shell around the Old Tunes web app.
// The app itself loads from GitHub Pages, so design changes arrive without reinstalling.
@main
struct OldTunesApp: App {
    init() {
        // The music player keeps playing with the screen locked or the app in the background.
        if Bundle.main.object(forInfoDictionaryKey: "OTBackgroundAudio") as? Bool == true {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
        }
    }

    var body: some Scene {
        WindowGroup {
            WebContainer()
                .ignoresSafeArea()
                .background(Color(red: 0.067, green: 0.067, blue: 0.067))
                .preferredColorScheme(.dark)
        }
    }
}

struct WebContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> WebViewController { WebViewController() }
    func updateUIViewController(_ controller: WebViewController, context: Context) {}
}
