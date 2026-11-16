# Old Tunes for iPhone

Two apps share this native shell:
- **Old Tunes** (OldTunes.ipa): the Spotify player.
- **Old Tunes Music** (OldTunesMusic.ipa): plays your own music files, keeps
  playing with the screen locked. Add songs with the **+** button (they're
  copied into the app from Files).

A small native app that runs Old Tunes full screen. It loads the app from
https://harriparna-creator.github.io/Oldtunes/, so design updates arrive
without reinstalling. Spotify sign-in uses the iPhone's own sign-in sheet.

## Install without Xcode (works on Intel Macs)

GitHub builds the app automatically: **OldTunes.ipa** is on
https://github.com/harriparna-creator/Oldtunes/releases/tag/app

1. Download **OldTunes.ipa** and/or **OldTunesMusic.ipa** from that page.
2. Install **Sideloadly** from https://sideloadly.io and open it.
3. Connect the iPhone with a cable, unlock it and tap **Trust**.
4. Drag the .ipa into Sideloadly, type your Apple ID email, press **Start**,
   and enter your Apple ID password when asked (it's sent to Apple to sign the app).
5. On the iPhone: **Settings → Privacy & Security → Developer Mode → On** (it restarts).
6. **Settings → General → VPN & Device Management** → your Apple ID → **Trust**.
7. Open Old Tunes, paste your Spotify Client ID and sign in.

Every 7 days, plug in and press **Start** again in Sideloadly (or turn on its
automatic refresh). Your sign-in and Record Shelf are kept.

## Building with Xcode instead (Apple-silicon Mac, or Xcode 26 on Intel)

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
