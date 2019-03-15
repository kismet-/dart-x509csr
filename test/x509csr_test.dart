/*
 *  example/crypto.dart
 *
 *  David Janes
 *  2019-03-15
 */

import 'package:x509csr/x509csr.dart';
import 'package:test/test.dart';

import "package:pointycastle/export.dart";
import 'package:asn1lib/asn1lib.dart';

void main() {
  group('Primary Functions', () {
    // from https://github.com/PointyCastle/pointycastle/blob/master/test/signers/rsa_signer_test.dart
    var modulus = BigInt.parse(
        "20620915813302906913761247666337410938401372343750709187749515126790853245302593205328533062154315527282056175455193812046134139935830222032257750866653461677566720508752544506266533943725970345491747964654489405936145559121373664620352701801574863309087932865304205561439525871868738640172656811470047745445089832193075388387376667722031640892525639171016297098395245887609359882693921643396724693523583076582208970794545581164952427577506035951122669158313095779596666008591745562008787129160302313244329988240795948461701615228062848622019620094307696506764461083870202605984497833670577046553861732258592935325691");
    var publicExponent = BigInt.parse("65537");
    var privateExponent = BigInt.parse(
        "11998058528661160053642124235359844880039079149364512302169225182946866898849176558365314596732660324493329967536772364327680348872134489319530228055102152992797567579226269544119435926913937183793755182388650533700918602627770886358900914370472445911502526145837923104029967812779021649252540542517598618021899291933220000807916271555680217608559770825469218984818060775562259820009637370696396889812317991880425127772801187664191059506258517954313903362361211485802288635947903604738301101038823790599295749578655834195416886345569976295245464597506584866355976650830539380175531900288933412328525689718517239330305");
    var p = BigInt.parse(
        "144173682842817587002196172066264549138375068078359231382946906898412792452632726597279520229873489736777248181678202636100459215718497240474064366927544074501134727745837254834206456400508719134610847814227274992298238973375146473350157304285346424982280927848339601514720098577525635486320547905945936448443");
    var q = BigInt.parse(
        "143028293421514654659358549214971921584534096938352096320458818956414890934365483375293202045679474764569937266017713262196941957149321696805368542065644090886347646782188634885321277533175667840285448510687854061424867903968633218073060468434469761149335255007464091258725753837522484082998329871306803923137");

    var publicKey = new RSAPublicKey(modulus, publicExponent);
    var privateKey = new RSAPrivateKey(modulus, privateExponent, p, q);

    test("Make CSR PEM", () {
      ASN1ObjectIdentifier.registerFrequentNames();
      Map<String, String> dn = {
        "CN": "www.davidjanes.com",
        "O": "Consensas",
        "L": "Toronto",
        "ST": "Ontario",
        "C": "CA",
      };

      ASN1Object encodedCSR = makeRSACSR(dn, privateKey, publicKey);

      String expected = """\
-----BEGIN CERTIFICATE REQUEST-----\r
MIICpzCCAY8CAQAwYjEbMBkGA1UEAwwSd3d3LmRhdmlkamFuZXMuY29tMRIwEAYD\r
VQQKDAlDb25zZW5zYXMxEDAOBgNVBAcMB1Rvcm9udG8xEDAOBgNVBAgMB09udGFy\r
aW8xCzAJBgNVBAYTAkNBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA\r
o1lf0VDufSHwUfaiDYua2r+o/Eo7msA3/MMnJhtRnAGQKKPxVxcv0T+L+gAb48fw\r
b24oriiELaA3zVTK69FMiCK1AdSkR/KbRQUGtEShyAtaq0FAFY/1to2VJ+CG19mp\r
a31m+g6BHC1NGyV5bti1bgSvNFGC7+0YBJFtu/0VFDWN+QzPKEX7IEMkgzerr9u+\r
WzB7FvtIXdbPFrvZ+rHR+Z363uHgG4nTpQnChFtADDeibHtKqIAjLB7/oIT8XL6t\r
MTpIaKAYg9mMvRmorQTuEw6S57LqTWA2QX+9V2SaTD7n0TTb2EiBY1QE+ogZ7T+s\r
Rzkeqj5SMqlb1nyevJcv+wIDAQABoAAwDQYJKoZIhvcNAQEEBQADggEBAPsvl7ye\r
fNZbqTJSPqoeOUesP+0ZiPoEVGOBSNjbNNHnPkyaZFe9f0E2YE3qsueSDhPuBK2o\r
Gb2M2YMYoGhIOjGtvlz8hKD/HiwjgKhKe2yiNwxAW4TCCaXTiRvg4d76nfnRsfrZ\r
uxbP1l1I+xZ7MFu+26+rN4MkQyD7RSjPDPmNNRQV/bttkQQY7e+CUTSvBG612G55\r
JRtNLRyBDvpmfWup2deG4CeVjbb1jxVAQataC8ihRLQGBUWb8kek1AG1IohM0evK\r
VM03oC2EKK4obm/wx+MbAPqLP9EvF1fxoyiQAZxRGyYnw/w3wJo7Svyov9qaiw2i\r
9lHwIX3uUNFfWaM=\r
-----END CERTIFICATE REQUEST-----\r\n""";

      String got = encodeCSRToPem(encodedCSR);

      expect(got, equals(expected));
    });

    test("Make Public PEM", () {
      String expected = """\
-----BEGIN PUBLIC KEY-----\r
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAo1lf0VDufSHwUfaiDYua\r
2r+o/Eo7msA3/MMnJhtRnAGQKKPxVxcv0T+L+gAb48fwb24oriiELaA3zVTK69FM\r
iCK1AdSkR/KbRQUGtEShyAtaq0FAFY/1to2VJ+CG19mpa31m+g6BHC1NGyV5bti1\r
bgSvNFGC7+0YBJFtu/0VFDWN+QzPKEX7IEMkgzerr9u+WzB7FvtIXdbPFrvZ+rHR\r
+Z363uHgG4nTpQnChFtADDeibHtKqIAjLB7/oIT8XL6tMTpIaKAYg9mMvRmorQTu\r
Ew6S57LqTWA2QX+9V2SaTD7n0TTb2EiBY1QE+ogZ7T+sRzkeqj5SMqlb1nyevJcv\r
+wIDAQAB\r
-----END PUBLIC KEY-----\r\n""";
      String got = encodeRSAPublicKeyToPem(publicKey);
      expect(got, equals(expected));
    });
    test("Make Private PEM", () {
      String expected = """\
-----BEGIN PRIVATE KEY-----\r
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCjWV/RUO59IfBR\r
9qINi5rav6j8SjuawDf8wycmG1GcAZAoo/FXFy/RP4v6ABvjx/BvbiiuKIQtoDfN\r
VMrr0UyIIrUB1KRH8ptFBQa0RKHIC1qrQUAVj/W2jZUn4IbX2alrfWb6DoEcLU0b\r
JXlu2LVuBK80UYLv7RgEkW27/RUUNY35DM8oRfsgQySDN6uv275bMHsW+0hd1s8W\r
u9n6sdH5nfre4eAbidOlCcKEW0AMN6Jse0qogCMsHv+ghPxcvq0xOkhooBiD2Yy9\r
GaitBO4TDpLnsupNYDZBf71XZJpMPufRNNvYSIFjVAT6iBntP6xHOR6qPlIyqVvW\r
fJ68ly/7AgMBAAECggEAXwr9iVjBquU4YzhRifgUnfquZDz8+UmmSddyy+VRUqhG\r
LJ9XKQlAtUt4MnolwB7xcqRx3wOMBNAYJ8ySVStukDdBglMrUwGB/mKyR+k3CKIy\r
mzpYAzPED/fJNW6ahrUKspRAenY+ARsKpiTjxu8ogV8QYiybNuaI9v93Dc5vmVWx\r
0WMqyo3uaXLQQpuMGJABlwuxR0cyEHwMbEfUDaxvHdmqCORQl1OXeWqmffhuMjBq\r
suPagdvWACZzREhsdrjYKt2PDhJvIwfYidGn/BU72dJEbzUlPkNIIblxpjnlsb8W\r
CM9l9PEpKfQLIZUoHTzA5rN0WPWeZS+0GPYSeCM2AQKBgQDNT2VLVhZb6gDeLJ7T\r
6JzKhwujMA9++Pb/AJjLfWL/K+S1+6j5kRZfH31iZvbD0wCTmhe7JACbNBmynS0K\r
f+AMCIry1k7TRavC0okubSG+BxNTbg9EHtLROzwofNEQoFdAyJkdHwHxl44DJ3l+\r
tZDjCrz5MVy8hbkhbmboUZ3LuwKBgQDLrdZERdCbDcEz2mXvrX39zEReLeuJNwUp\r
KMWhBatwGXlNrbaRVdDVugioIiBGVixPb/p4oFti7+hiBX5y0mNE8aY3xBhOCouX\r
y50dG6BSSsdniBN+TrhRd8rgZYW8PXnEW+ZvO70bvROAMFihszuKdIAL7mGn+KA/\r
gSAHQrxIwQKBgGH7iz8qBZ+2DNX7e41sjS+GxcIK1MpnLRHECifLXmyjWRKU2S7J\r
1GBvWdqVgx0v3S2UM9EnPHbVpZH9uxowrw9vIEkGiDYCIRfofHnAsYLMQ6fkdbqv\r
7zLVzz8PWoNR0nJjiddBDh9rkeXld/FF27DPViKjMTvzocfXtZsYIHOzAoGASFHT\r
MK6xYTzDCwxTAYVSpRkwdVhMt43nsTOe6IvA0a7Z2XEC0BvuaNUDWd+0IgVa+mHC\r
R654hGq20ocs3MxDHynGYSqpjpxD8IQFp1410MJohyRT95cv7w1f5clmcO5LHCOd\r
cIV/oifCktOXxOKFE6ZGCPZ9ikzHaYUJwEo73IECgYBOpq7yHxbUg0ITBQGqwrCJ\r
CHFUFefpmq85M8B31OVZaZEqBgyMWB2iWb8kavY8KH4RiyUouEyTD3a0bty0/pvO\r
78+wUie57BQtiCmSRF8okl9NeouGpewy6djU36aQnyoPNfbgi8DBioGPW0NHAuR2\r
VIpR9QlvA3fRVEdb+RBM3A==\r
-----END PRIVATE KEY-----\r\n""";
      String got = encodeRSAPrivateKeyToPem(privateKey);
      // print(got);
      expect(got, equals(expected));
    });
  });
}
