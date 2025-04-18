/*
 * JavaScript client-side example using jsrsasign
 */

// #########################################################
// #             WARNING   WARNING   WARNING               #
// #########################################################
// #                                                       #
// # This file is intended for demonstration purposes      #
// # only.                                                 #
// #                                                       #
// # It is the SOLE responsibility of YOU, the programmer  #
// # to prevent against unauthorized access to any signing #
// # functions.                                            #
// #                                                       #
// # Organizations that do not protect against un-         #
// # authorized signing will be black-listed to prevent    #
// # software piracy.                                      #
// #                                                       #
// # -QZ Industries, LLC                                   #
// #                                                       #
// #########################################################

/**
 * Depends:
 *     - jsrsasign-latest-all-min.js
 *     - qz-tray.js
 *
 * Steps:
 *
 *     1. Include jsrsasign 10.9.0 into your web page
 *        <script src="https://cdnjs.cloudflare.com/ajax/libs/jsrsasign/11.1.0/jsrsasign-all-min.js"></script>
 *
 *     2. Update the privateKey below with contents from private-key.pem
 *
 *     3. Include this script into your web page
 *        <script src="path/to/sign-message.js"></script>
 *
 *     4. Remove or comment out any other references to "setSignaturePromise"
 *
 *     5. IMPORTANT: Before deploying to production, copy "jsrsasign-all-min.js"
 *        to the web server.  Don't trust the CDN above to be available.
 */
var privateKey = "-----BEGIN PRIVATE KEY-----\n" +
"MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDjaFc7k4OJ68S1\n" +
"3uEBfGrYcTOIJHHbj6kj0FtrozIdrxV8ehVOXY2/X6sJw5BwnBoEgAApG3gk+ksd\n" +
"Tu6EH67e5C2feyumQVT12aF0IlBWN8+WBcqnHHK45mRIKGEtBLln4Ci9oO1HeVV7\n" +
"tSLtrnc919MPVCrMDSfUymSeWGq8yyAv2LZjQlYSFB8kNJE10tio294741ZX6J2j\n" +
"p7OrYwDy9x2nxJG3Yb97FX8K3BmyCvTv4B1OjYsZ9LPryz7e9bQYl+K2LbVYAXpJ\n" +
"y+pHZYUWkhVtbu+DeuNtV/MbYgxSfi4kbu42LGexpXcSfKratQLwpsRfInTGSf5Z\n" +
"Ecm2ARUvAgMBAAECggEAEl1QQh7pDf/MvHU5zYFrLXyC0VlEGpuQ6LQAVgJxXyVP\n" +
"AmTniJMUieJjcR/qb7Wjgj6GBMvTmYTfAQhpSaE3YYeiyZDMVxpKjqobGEJXI4dR\n" +
"S8e+9FzfROBSM+OS6WxKvsFC+QFgeBer2BgqMHCY75UY1dGRvTXIxC3uDz2LrSBB\n" +
"SW6e3UuLWpA6kKu6nvinjBDN2zZbPKF+Y4/njzbgdDD3VID6lka2W0n5+xdGZAL0\n" +
"AldWYGupV1XpQn1MCJPY0RpjRIyiVGDc1rWc5jr309wyzu0XNpNPdOA73JvxOPWG\n" +
"6JOvk8wuD+btrppajtM37KNEG488HFesSPN42N/VqQKBgQD0c9x3H2nGNdIxclMz\n" +
"AAccHl4B3BS1eeqsfXOeQ9Cxcur+rO3UGI5fOAGzZnl0fcWBZc4waL9jfHZjGB6R\n" +
"8NLD4DRLCRS2b/mLeeg7XZG2+1bpZMyMG83yg0FLQrfKJZDBcj3j9WSFchk8im1H\n" +
"8iOklmQit/ZOMTfViDuV07PY5wKBgQDuJlsvCnV+B9wBiBL7Ww1HA700oAhcYBjV\n" +
"vqcN1DCw6iz81PMtldzZpbZnS2t/fFOTEAPQnNxpTWFDxYwxl4kBP8Fv6zW7yrvD\n" +
"ZW26GDJdxkqkchYn7PV4iStYvofHUdJqid7NksGN1olGI4t5AUvAZ/z9kKnnxQpj\n" +
"zCHjSEHweQKBgQDOV96JTyLiBRxgULiaHDPkMF36A+QXK8pDv8GQnn3Sy8ZBI4e9\n" +
"uNy003ncDWwIQQIur9jUVBb5y13DV+C2ICpI3UBG9mtddDeY3FaDhgAyDQbYDBX9\n" +
"TpsRUmoTNUYehIckQ2KqwcEQQ7e5ur90M5iSnb/47oAikLkorc5eMk1lkQKBgQDs\n" +
"/3bXBY2PcrrbO1PImQBJn8r3SBuJ8ohEjospE/Ww2hsTMckfoHg8kNFJUqEUKeHy\n" +
"BIoHXVNr5/nXvAycfbV2bMBQZL8At+zLs3DTNalJ8T/vDypFaWeQINHmaxYsoZzJ\n" +
"MZNs+ZNtWAccqdru/P8p51K59PFhGZIRZuCCkzIr4QKBgQCejNsFecpmXdTB4Ek6\n" +
"h0NyCG0v/do8mO3brkZyGvnrN7H6PIg2TRx/ItTl8T1Kd3Cav/f5hTwJRZYwR8iT\n" +
"Sv6Zixj12uDeYhJ/Snl9BUgi+UkzqO1YLmjP0tExw8bcI0BZkiE7SjIRYPgchdfP\n" +
"2NeUtrVb9coHm+E0vWzRnB36KA==\n" +
"-----END PRIVATE KEY-----";

qz.security.setSignatureAlgorithm("SHA512"); // Since 2.1
qz.security.setSignaturePromise(function(toSign) {
    return function(resolve, reject) {
        try {
            var pk = KEYUTIL.getKey(privateKey);
            var sig = new KJUR.crypto.Signature({"alg": "SHA512withRSA"});  // Use "SHA1withRSA" for QZ Tray 2.0 and older
            sig.init(pk); 
            sig.updateString(toSign);
            var hex = sig.sign();
            console.log("DEBUG: \n\n" + stob64(hextorstr(hex)));
            resolve(stob64(hextorstr(hex)));
        } catch (err) {
            console.error(err);
            reject(err);
        }
    };
});




