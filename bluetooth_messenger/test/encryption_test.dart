import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/registry/registry.dart';
import 'package:pointycastle/asymmetric/api.dart';
import "package:asn1lib/asn1lib.dart";

class EncryptionService {}

encodePublicKeyToPem(RSAPublicKey publicKey) {
  var algorithmSeq = new ASN1Sequence();
  var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList(
      [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
  var paramsAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
  algorithmSeq.add(algorithmAsn1Obj);
  algorithmSeq.add(paramsAsn1Obj);

  var publicKeySeq = new ASN1Sequence();
  publicKeySeq.add(ASN1Integer(publicKey.modulus));
  publicKeySeq.add(ASN1Integer(publicKey.exponent));
  var publicKeySeqBitString =
      new ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

  var topLevelSeq = new ASN1Sequence();
  topLevelSeq.add(algorithmSeq);
  topLevelSeq.add(publicKeySeqBitString);
  var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

  return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
}

String encrypt(String plaintext, RSAPublicKey publicKey) {
  var cipher = new RSAEngine()
    ..init(true, new PublicKeyParameter<RSAPublicKey>(publicKey));
  var cipherText = cipher.process(new Uint8List.fromList(plaintext.codeUnits));

  return new String.fromCharCodes(cipherText);
}

String decrypt(String ciphertext, RSAPrivateKey privateKey) {
  var cipher = new RSAEngine()
    ..init(false, new PrivateKeyParameter<RSAPrivateKey>(privateKey));
  var decrypted = cipher.process(new Uint8List.fromList(ciphertext.codeUnits));

  return new String.fromCharCodes(decrypted);
}

void main() {
  var keyParams = new RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);

  var secureRandom = new FortunaRandom();
  var random = new Random.secure();

  List<int> seeds = [];
  for (int i = 0; i < 32; i++) {
    seeds.add(random.nextInt(255));
  }

  secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));

  //var rnd = new FixedSecureRandom()..seed(KeyParameter(new Uint8List.fromList(seeds)));

  var rngParams = new ParametersWithRandom(keyParams, secureRandom);
  var k = new RSAKeyGenerator();
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
