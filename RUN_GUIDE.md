// ============================================================================
// HOW TO RUN THIS APP (cheat sheet)
// ============================================================================
//
// 1) EVERYDAY DEVELOPMENT (hot reload, breakpoints)
//    - Web:    press F5 in VS Code with the Chrome configuration.
//    - Phone:  connect it with USB debugging, select it as the device
//              (bottom-right of VS Code), press F5.
//    Use this for screens, email-code login, Supabase data, etc.
//    DON'T test the web "Continue with Google" button here: Google's sign-in
//    page freezes in the temporary Chrome window that F5 opens.
//
// 2) TESTING GOOGLE SIGN-IN ON WEB  (run in the terminal, project root)
//
//      flutter run -d web-server --release --web-port=3000 --web-hostname=localhost --dart-define-from-file=env.json
//
//    Then:
//      a. Wait for the line "lib\main.dart is being served at http://localhost:3000".
//         No browser opens by itself, and the first build is slow.
//      b. Open  http://localhost:3000  in your NORMAL Chrome (the one signed in
//         to Google), never in the window Flutter opens.
//      c. To see the login screen again: F12 -> Application -> "Clear site data",
//         then reload. (Otherwise the saved session opens Home directly.)
//      d. Tap "Continue with Google" and choose an account.
//
//    Notes:
//      - Keep the terminal open. Closing it stops the server
//        (ERR_CONNECTION_REFUSED means it isn't running).
//      - Release mode has NO hot reload and skips assert(). After any code
//        change: press `q` in the terminal, run the command again, and
//        refresh the tab.
//      - Always start from a fresh http://localhost:3000. Never reload an
//        address that contains ?code=... (it is single-use).
//      - Port 3000 must stay 3000: it is registered in the Google OAuth client
//        (Authorized JavaScript origins) and in Supabase (Redirect URLs).
//      - If that command fails, use the two-step version, one command at a time:
//          flutter build web --dart-define-from-file=env.json
//          dart pub global run dhttpd --path build/web --port 3000
//      - "Port already in use": an old server is still running.
//        Press Ctrl+C (or `q`) in that terminal, then start again.
//
// 3) TESTING ON THE PHONE (Google sign-in is native there)
//    F5 with the phone selected. A manifest change needs a full rebuild
//    (stop the app and run it again, not hot reload).
//    To see the login screen again: use the logout button (profile tab), or
//    Settings -> Apps -> this app -> Storage -> Clear data.
//
// 4) PLACES THAT MUST AGREE (or Google/Supabase login breaks)
//    - Supabase -> Authentication -> URL Configuration:
//        Site URL            http://localhost:3000
//        Redirect URLs       http://localhost:3000/**
//                            io.supabase.shopping://login-callback/
//    - Google Auth Platform -> Clients -> Web client:
//        JavaScript origin   http://localhost:3000
//        Redirect URI        https://<project-ref>.supabase.co/auth/v1/callback
//    - Google Android client: package com.example.shopping + SHA-1 of the
//      keystore used to build (debug now; add release / Play keys later).
//    - env.json: SUPABASE keys and GOOGLE_WEB_CLIENT_ID.
//    When the app moves to a real domain, update ALL of the above.
// ============================================================================