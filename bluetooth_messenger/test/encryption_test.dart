import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:pointycastle/export.dart';
import "package:asn1lib/asn1lib.dart";

encodePublicKeyToPem(RSAPublicKey publicKey) {
  var algorithmSeq = ASN1Sequence();
  var algorithmAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList(
      [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
  var paramsAsn1Obj = ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
  algorithmSeq.add(algorithmAsn1Obj);
  algorithmSeq.add(paramsAsn1Obj);

  var publicKeySeq = ASN1Sequence();
  publicKeySeq.add(ASN1Integer(publicKey.modulus));
  publicKeySeq.add(ASN1Integer(publicKey.exponent));
  var publicKeySeqBitString =
      ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

  var topLevelSeq = ASN1Sequence();
  topLevelSeq.add(algorithmSeq);
  topLevelSeq.add(publicKeySeqBitString);
  var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

  return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
}

String encrypt(String plaintext, RSAPublicKey publicKey) {
  var cipher = RSAEngine()
    ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
  var cipherText = cipher.process(Uint8List.fromList(plaintext.codeUnits));

  return String.fromCharCodes(cipherText);
}

String decrypt(String ciphertext, RSAPrivateKey privateKey) {
  var cipher = RSAEngine()
    ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
  var decrypted = cipher.process(Uint8List.fromList(ciphertext.codeUnits));

  return String.fromCharCodes(decrypted);
}

void main() {
  var keyParams = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);

  var secureRandom = FortunaRandom();
  var random = Random.secure();

  List<int> seeds = [];
  for (int i = 0; i < 32; i++) {
    seeds.add(random.nextInt(255));
  }

  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

  //var rnd = new FixedSecureRandom()..seed(KeyParameter(new Uint8List.fromList(seeds)));

  var rngParams = ParametersWithRandom(keyParams, secureRandom);
  var k = RSAKeyGenerator();
  k.init(rngParams);

  AsymmetricKeyPair<PublicKey, PrivateKey> keyPair = k.generateKeyPair();
  RSAPrivateKey privateKey = keyPair.privateKey as RSAPrivateKey;
  RSAPublicKey publicKey = keyPair.publicKey as RSAPublicKey;

  var message = 'this message will be encrypted';

  var encryptedText = encrypt(message, publicKey);
  print(encryptedText);

  var decryptedText = decrypt(encryptedText, privateKey);
  print(decryptedText);

  print('end');
}
