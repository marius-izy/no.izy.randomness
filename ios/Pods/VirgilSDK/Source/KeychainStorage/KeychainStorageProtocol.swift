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

/// Protocol with Keychain operations
public protocol KeychainStorageProtocol: AnyObject {
    /// Stores key in Keychain
    ///
    /// - Parameters:
    ///   - data: Data
    ///   - name: Name
    ///   - meta: Meta
    /// - Returns: Stored Keychain entry
    /// - Throws: Depends on implementation
    func store(data: Data, withName name: String, meta: [String: String]?) throws -> KeychainEntry

    /// Updates entry
    ///
    /// - Parameters:
    ///   - name: Name
    ///   - data: New data
    ///   - meta: New meta
    /// - Throws: Depends on implementation
    func updateEntry(withName name: String, data: Data, meta: [String: String]?) throws

    /// Retrieves entry from Keychain
    ///
    /// - Parameter name: Name
    /// - Returns: Retrieved Keychain entry
    /// - Throws: Depends on implementation
    func retrieveEntry(withName name: String) throws -> KeychainEntry

    /// Retrieves all entries from Keychain
    ///
    /// - Returns: All Keychain entries
    /// - Throws: Depends on implementation
    func retrieveAllEntries() throws -> [KeychainEntry]

    /// Deletes keychain entry
    ///
    /// - Parameter name: Name
    /// - Throws: Depends on implementation
    func deleteEntry(withName name: String) throws

    /// Checks if entry exists in Keychain
    ///
    /// - Parameter name: Name
    /// - Returns: true if entry exists, false - otherwise
    /// - Throws: Depends on implementation
    func existsEntry(withName name: String) throws -> Bool
}

extension KeychainStorage: KeychainStorageProtocol {
    public func retrieveAllEntries() throws -> [KeychainEntry] {
        return try self.retrieveAllEntries(queryOptions: nil)
    }

    public func deleteEntry(withName name: String) throws {
        try self.deleteEntry(withName: name, queryOptions: nil)
    }

    public func existsEntry(withName name: String) throws -> Bool {
        return try self.existsEntry(withName: name, queryOptions: nil)
    }

    public func retrieveEntry(withName name: String) throws -> KeychainEntry {
        return try self.retrieveEntry(withName: name, queryOptions: nil)
    }

    public func updateEntry(withName name: String, data: Data, meta: [String: String]?) throws {
        try self.updateEntry(withName: name, data: data, meta: meta, queryOptions: nil)
    }

    public func store(data: Data, withName name: String, meta: [String: String]?) throws -> KeychainEntry {
        return try self.store(data: data, withName: name, meta: meta, queryOptions: nil)
    }
}
