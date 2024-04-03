//
//  CryoConfig.swift
//
//
//  Created by Dr. Brandon Wiley on 4/3/24.
//

import Foundation

public class CryoConfig: Codable
{
    public var projectRoot: URL
    public var tempWorkingRoot: URL
    public var projects: [Project]

    public init(projectRoot: URL, tempWorkingRoot: URL, projects: [Project] = [])
    {
        self.projectRoot = projectRoot
        self.tempWorkingRoot = tempWorkingRoot
        self.projects = projects
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

public struct Project: Codable
{
    public let gitRepo: URL
    public let branchMode: BranchMode
}
