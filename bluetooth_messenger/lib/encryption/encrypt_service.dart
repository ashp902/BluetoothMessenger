import 'dart:html';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/export.dart';

class EncryptionService {
  late AsymmetricKeyPair<PublicKey, PrivateKey> _keyPair;

  AsymmetricKeyPair<PublicKey, PrivateKey> createKeys() {
    var keyGenerator = new RSAKeyGenerator();
    return keyGenerator.generateKeyPair();
  }
}

void main() {
  EncryptionService a = new EncryptionService();
  print(a.createKeys());
}
