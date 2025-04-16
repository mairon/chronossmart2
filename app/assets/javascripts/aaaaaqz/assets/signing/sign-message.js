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
 *     1. Include jsrsasign 8.0.4 into your web page
 *        <script src="https://cdn.rawgit.com/kjur/jsrsasign/c057d3447b194fa0a3fdcea110579454898e093d/jsrsasign-all-min.js"></script>
 *
 *     2. Update the privateKey below with contents from private-key.pem
 *
 *     3. Include this script into your web page
 *        <script src="path/to/sign-message.js"></script>
 *
 *     4. Remove or comment out any other references to "setSignaturePromise"
 */
var privateKey = "-----BEGIN PRIVATE KEY-----\n" +
"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC10JrbP6d9M99k\n" +
"1CjmNO/xsgcze9+MnTocR22QP3G5ujPStIyJ9NJVwU4tmAMv0xA4zhe8Xf47jhH4\n" +
"MM7D14ZnAf9Hy7jOA36lQ8/MYcbK0tdXQA1s3ez+UM1OqbmaH2dl0JVtyiOlcJrd\n" +
"KPJV/MGfnYxS5hDygTnljuEjmkUNt1sdX8ns1iOgZWPpWCEy9D8Nhk3QnjTfsxJr\n" +
"yCerbCb5UJwFQqJoqinMDojpdnqSbAN2FZk5CQWDDHH4WecQOzp/RxQquwXZ5+6K\n" +
"NDH+qXTw+mucpPiXRjIk+Q2fvlOkT2xoHxr7qJ9JNHzXPBJ5ivTH/ytajOjgCyk1\n" +
"Exi5vXUTAgMBAAECggEAO9pI6E1br1lQvMolDqe1p6zSNw4b6RfnReDzvg1MvHYC\n" +
"UmZyb4XjaiyhNlw5DFjgmbqq0K1moKdj3f7/SjRcv/NF3RZBJ7y5x+D7es5jWWiw\n" +
"UD47TS//sTbbZ35zJbwZ10gjsQle07sumAi/QjRbb1a3l6C6SoLlEt+G2SgTfHBm\n" +
"WyA/R+konDpQNDTZmT6knTwOjfZX+a2jRBMbxbWG8TysWHxV8RCHsXqXao6/TMT9\n" +
"fYpydXN0yYFcl0ZBCA63OABoifYoVsuZ9Mre4YwuEcBHFhFXk2uHedO8OsPUI9ft\n" +
"wiuKmCvHw0xhFd7fnI6O0nofsENFLMFhWGE2Xv6GEQKBgQDdo64ILq8XNfyoPXbD\n" +
"aeJTjgfCpzhG8nsaeWVnBp56BLvBiQWBbCo2j1eb7NHFyy8yRNWemoNdHwvvSCoZ\n" +
"ufg23FkmLvGZxuprIkCq0d1ZDhj8vnKLXyloktR7TSeNoyIa3pYPBLlAHHEGOuyn\n" +
"QAB0pfvv5s3ctOPS6z2rkzi1UQKBgQDSAGNxd+bD094rmhGssTkB+rabOlT60ZHg\n" +
"d7rXLd/RE++E/u7i4CufUlrAwtS6nzv7xEfQ/rg6LM/mnvKNhkw7Dy4eFVZtMjE4\n" +
"w99J6x/+RRcXqWIE1onJ1WhtAqpvsjuOa3g5Rx045QhgLNrNJ4/uOtYueOP/ocmy\n" +
"SYrUI0M7IwKBgGtip6ptPAYp8R1ukkFB5xeGpDnqnTi6uWxtTvUo3tXNv06Y3eME\n" +
"DjvbHZ59knGb7WUUts+em3Ed3sFznHpUgW/LOSJn8kUIfIGl2eEpx24jh3XFrGfc\n" +
"loqFQY/wJO7aEGcmW1wxdLQcU6KqIAk02EOsPDHTCQEbX5rMwVeFAB/RAoGBAM9H\n" +
"IOCLt5PM2LryvMVWu+0vOPRolB5ponIL27iuh/9HjSAZvVLkb0o3sGoZJH370+oC\n" +
"Z9xqvw500tRQSRrV1wJoTl3VM9ReOWVNOGUulgqUyWFKh/w8gg5c/VCz0+Sh6NT/\n" +
"UNBAWCCjOCwtud3LUe6T1npSSsE0QPAgVM5k6+Q/AoGBAMdGkz/sncYRdnT4iB4Y\n" +
"dsN47G+B6i8I+bT8a0QV4Xhqyd6O1yCuzVnFn+bll51MkeGWoZLtoAoF2ivKkMlS\n" +
"ruJxX4gfEbrKasfsPNGBRZusvPTLbUoTrKS8h5/K6SiZ0MMooeozaHXDJy4M2U3s\n" +
"Jtkv0mqRHVGVpdN4Fp96qtd3\n" +
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
            
            resolve(stob64(hextorstr(hex)));
        } catch (err) {
            console.error(err);
            reject(err);
        }
    };
});
