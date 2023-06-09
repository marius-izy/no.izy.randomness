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

// swiftlint:disable trailing_closure

/// Implementation of AccessTokenProvider which provides AccessToken using cache+renew callback
@objc(VSSCachingJwtProvider) open class CachingJwtProvider: NSObject, AccessTokenProvider {
    /// Cached Jwt
    public private(set) var jwt: Jwt?
    /// Callback, which takes a TokenContext and completion handler
    /// Completion handler should be called with either JWT, or Error
    @objc public let renewJwtCallback: (TokenContext, @escaping (Jwt?, Error?) -> Void) -> Void

    private let semaphore = DispatchSemaphore(value: 1)

    /// Initializer
    ///
    /// - Parameters:
    ///   - initialJwt: Initial jwt value
    ///   - renewJwtCallback: Callback, which takes a TokenContext and completion handler
    ///                       Completion handler should be called with either JWT, or Error
    @objc public init(initialJwt: Jwt? = nil,
                      renewJwtCallback: @escaping (TokenContext, @escaping (Jwt?, Error?) -> Void) -> Void) {
        self.jwt = initialJwt
        self.renewJwtCallback = renewJwtCallback

        super.init()
    }

    /// Typealias for callback used below
    public typealias JwtStringCallback = (String?, Error?) -> Void
    /// Typealias for callback used below
    public typealias RenewJwtCallback = (TokenContext, @escaping JwtStringCallback) -> Void

    /// Initializer
    ///
    /// - Parameters:
    ///   - initialJwt: Initial jwt value
    ///   - renewTokenCallback: Callback, which takes a TokenContext and completion handler
    ///                         Completion handler should be called with either JWT String, or Error
    @objc public convenience init(initialJwt: Jwt? = nil, renewTokenCallback: @escaping RenewJwtCallback) {
        self.init(initialJwt: initialJwt, renewJwtCallback: { ctx, completion in
            renewTokenCallback(ctx) { string, error in
                do {
                    guard let string = string, error == nil else {
                        completion(nil, error)
                        return
                    }

                    completion(try Jwt(stringRepresentation: string), nil)
                }
                catch {
                    completion(nil, error)
                }
            }
        })
    }

    /// Typealias for callback used below
    public typealias AccessTokenCallback = (AccessToken?, Error?) -> Void

    /// Provides access token using callback
    ///
    /// - Parameters:
    ///   - tokenContext: `TokenContext` provides context explaining why token is needed
    ///   - completion: completion closure
    @objc public func getToken(with tokenContext: TokenContext, completion: @escaping AccessTokenCallback) {
        let expirationTime = Date().addingTimeInterval(5)

        if let jwt = self.jwt, !jwt.isExpired(date: expirationTime), !tokenContext.forceReload {
            completion(jwt, nil)
            return
        }

        self.semaphore.wait()

        if let jwt = self.jwt, !jwt.isExpired(date: expirationTime), !tokenContext.forceReload {
            self.semaphore.signal()
            completion(jwt, nil)
            return
        }

        self.renewJwtCallback(tokenContext) { token, err in
            guard let token = token, err == nil else {
                self.semaphore.signal()
                completion(nil, err)
                return
            }

            self.jwt = token
            self.semaphore.signal()
            completion(token, nil)
        }
    }
}

// swiftlint:enable trailing_closure
