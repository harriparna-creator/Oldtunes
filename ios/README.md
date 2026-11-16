# Old Tunes for iPhone

A small native app that runs Old Tunes full screen. It loads the app from
https://harriparna-creator.github.io/oldtunes/, so design updates arrive
without reinstalling. Spotify sign-in uses the iPhone's own sign-in sheet.

## First install (about 10 minutes)

1. Install **Xcode** from the Mac App Store and open it once.
2. In Xcode: **Settings → Accounts → +** and sign in with your Apple ID.
3. In Terminal: `git clone https://github.com/harriparna-creator/oldtunes`,
   then `cd oldtunes/ios && ./setup.sh`. This opens the project in Xcode.
4. In Xcode, click **OldTunes** (top of the left sidebar) → **Signing & Capabilities**
   → **Team**: pick your name (Personal Team).
   If it complains the bundle identifier is taken, change it to something like
   `com.yourname.oldtunes`.
5. Plug in your iPhone, unlock it, tap **Trust**. Pick the iPhone at the top of Xcode.
6. On the iPhone: **Settings → Privacy & Security → Developer Mode → On** (it restarts).
7. Press **▶ Run** in Xcode.
8. First launch only: **Settings → General → VPN & Device Management** → your Apple ID → **Trust**.
9. Open Old Tunes, paste your Spotify Client ID and sign in. No Spotify dashboard
   changes are needed.

## Every 7 days

With a free Apple ID the app stops opening after 7 days. Plug the iPhone in and
press **▶ Run** in Xcode again. Your sign-in and Record Shelf are kept.
