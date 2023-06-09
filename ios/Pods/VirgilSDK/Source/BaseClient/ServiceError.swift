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

/// Represent card service error
@objc(VSSServiceError) open class ServiceError: NSObject, CustomNSError {
    /// Http status code
    @objc public let httpStatusCode: Int
    /// Recieved and decoded `RawServiceError`
    @objc public let rawServiceError: RawServiceError
    /// Error domain
    @objc public let errorDomain: String

    /// Initializer
    /// - Parameter httpStatusCode: http status code
    /// - Parameter rawServiceError: raw service error
    /// - Parameter errorDomain: error domain
    @objc public init(httpStatusCode: Int, rawServiceError: RawServiceError, errorDomain: String? = nil) {
        self.httpStatusCode = httpStatusCode
        self.rawServiceError = rawServiceError
        self.errorDomain = errorDomain ?? ServiceError.errorDomain
    }

    /// Error domain or Error instances thrown from Service
    @objc public static var errorDomain: String { return "VirgilSDK.ServiceErrorDomain" }
    /// Code of error
    @objc public var errorCode: Int { return self.rawServiceError.code }
    /// Provides info about the error. Error message can be recieve by NSLocalizedDescriptionKey
    @objc public var errorUserInfo: [String: Any] { return [NSLocalizedDescriptionKey: self.rawServiceError.message] }
}
