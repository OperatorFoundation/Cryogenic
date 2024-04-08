//
//  CryoConfig.swift
//
//
//  Created by Dr. Brandon Wiley on 4/3/24.
//

import Foundation

import Datable

public class CryoConfig: Codable
{
    public var remoteName: String
    public var branch: String
    public var target: String?
    public var arguments: [String]

    public init(remoteName: String, branch: String, target: String? = nil, arguments: [String] = [])
    {
        self.remoteName = remoteName
        self.branch = branch
        self.target = target
        self.arguments = arguments
    }
}

extension CryoConfig: CustomStringConvertible
{
    public var description: String
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]

        do
        {
            let data = try encoder.encode(self)
            return data.string
        }
        catch
        {
            return "[CryoConfig: Unknown]"
        }
    }
}

extension CryoConfig
{
    static public func load(_ url: URL) throws -> CryoConfig
    {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let config = try decoder.decode(CryoConfig.self, from: data)
        return config
    }

    public func save(_ url: URL) throws
    {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        try data.write(to: url, options: .atomic)
    }
}

