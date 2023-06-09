//
// Copyright (C) 2015-2021 Virgil Security Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     (1) Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//
//     (2) Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in
//     the documentation and/or other materials provided with the
//     distribution.
//
//     (3) Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
// IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Lead Maintainer: Virgil Security Inc. <support@virgilsecurity.com>
//

import Foundation
import VirgilCryptoFoundation

// MARK: - Extension for assymetric authenticated encryption/decryption
extension VirgilCrypto {
    /// Key used to embed Data Signature into ASN.1 structure
    /// Used in signAndEncrypt & decryptAndVerify
    @objc public static let CustomParamKeySignature = "VIRGIL-DATA-SIGNATURE".data(using: .utf8)!
    /// Key used to embed signer identity into ASN.1 structure
    /// Used in signAndEncrypt & decryptAndVerify
    @objc public static let CustomParamKeySignerId = "VIRGIL-DATA-SIGNER-ID".data(using: .utf8)!

    /// Signs (with private key) And Encrypts data for passed PublicKeys
    ///
    /// 1. Generates signature depending on KeyType
    /// 2. Generates random AES-256 KEY1
    /// 3. Encrypts data with KEY1 using AES-256-GCM
    /// 4. Generates ephemeral key pair for each recipient
    /// 5. Uses Diffie-Hellman to obtain shared secret with each recipient's public key & each ephemeral private key
    /// 6. Computes KDF to obtain AES-256 key from shared secret for each recipient
    /// 7. Encrypts KEY1 with this key using AES-256-CBC for each recipient
    ///
    /// - Parameters:
    ///   - data: Data to be signedAndEncrypted
    ///   - privateKey: Sender private key
    ///   - recipients: Recipients' public keys
    /// - Returns: SignedAndEncrypted data
    /// - Throws: Rethrows from `Signer` and `RecipientCipher`
    @available(*, deprecated, message: "use authEncrypt instead")
    @objc open func signAndEncrypt(_ data: Data, with privateKey: VirgilPrivateKey,
                                   for recipients: [VirgilPublicKey]) throws -> Data {
        return try self.encrypt(inputOutput: .data(input: data),
                                signingOptions: SigningOptions(privateKey: privateKey, mode: .signAndEncrypt),
                                recipients: recipients,
                                enablePadding: false)!
    }

    /// Decrypts (with private key) And Verifies data using any of signers' PublicKeys
    ///
    /// 1. Uses Diffie-Hellman to obtain shared secret with sender ephemeral public key & recipient's private key
    /// 2. Computes KDF to obtain AES-256 KEY2 from shared secret
    /// 3. Decrypts KEY1 using AES-256-CBC
    /// 4. Decrypts data using KEY1 and AES-256-GCM
    /// 5. Finds corresponding PublicKey according to signer id inside data
    /// 6. Verifies signature
    ///
    /// - Parameters:
    ///   - data: Signed And Encrypted data
    ///   - privateKey: Receiver's private key
    ///   - signersPublicKeys: Array of possible signers public keys.
    ///                        WARNING: Data should have signature of ANY public key from array.
    /// - Returns: DecryptedAndVerified data
    /// - Throws: Rethrows from `RecipientCipher` and `Verifier`.
    ///           Throws VirgilCryptoError.signerNotFound if signer with such id is not found
    ///           Throws VirgilCryptoError.signatureNotFound if signer was not found
    ///           Throws VirgilCryptoError.signatureNotVerified if signature did not pass verification
    @available(*, deprecated, message: "use authDecrypt instead")
    @objc open func decryptAndVerify(_ data: Data, with privateKey: VirgilPrivateKey,
                                     usingOneOf signersPublicKeys: [VirgilPublicKey]) throws -> Data {
        return try self.decrypt(inputOutput: .data(input: data),
                                verifyingOptions: VerifyingOptions(publicKeys: signersPublicKeys,
                                                                   mode: .decryptAndVerify),
                                privateKey: privateKey)!
    }

    /// Decrypts (with private key) And Verifies data using any of signers' PublicKeys
    ///
    /// 1. Uses Diffie-Hellman to obtain shared secret with sender ephemeral public key & recipient's private key
    /// 2. Computes KDF to obtain AES-256 KEY2 from shared secret
    /// 3. Decrypts KEY1 using AES-256-CBC
    /// 4. Decrypts data using KEY1 and AES-256-GCM
    /// 5. Finds corresponding PublicKey according to signer id inside data
    /// 6. Verifies signature
    ///
    /// - Parameters:
    ///   - data: Signed And Ecnrypted data
    ///   - privateKey: Receiver's private key
    ///   - signerPublicKey: Signer public key
    /// - Returns: DecryptedAndVerified data
    /// - Throws:
    ///   - Rethrows from `RecipientCipher`
    ///   - Rethrows from `Verifier`
    ///   - Throws `VirgilCryptoError.signerNotFound` if signer with such id is not found
    ///   - Throws `VirgilCryptoError.signatureNotFound` if signer was not found
    ///   - Throws `VirgilCryptoError.signatureNotVerified` if signature did not pass verification
    @available(*, deprecated, message: "use authDecrypt instead")
    @objc open func decryptAndVerify(_ data: Data, with privateKey: VirgilPrivateKey,
                                     using signerPublicKey: VirgilPublicKey) throws -> Data {
        return try self.decryptAndVerify(data, with: privateKey, usingOneOf: [signerPublicKey])
    }
}
