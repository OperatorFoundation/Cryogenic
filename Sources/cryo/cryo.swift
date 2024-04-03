//
//  cryo.swift
//
//
//  Created by Dr. Brandon Wiley on 4/3/24.
//

import ArgumentParser
import Foundation

import Gardener

@main
struct cryo: ParsableCommand
{
    static let configuration = CommandConfiguration(
        commandName: "cryo",
        abstract: "cryo is a tool for keeping your packages fresh",
        subcommands: [setRoot.self, setTemp.self, addProject.self]
    )
}

extension cryo
{
    struct setRoot: ParsableCommand
    {
        @Argument(help: "path to projects root directory")
        var root: String

        @Option(help: "path to config file")
        var configFile: String?

        mutating public func run() throws
        {
            let config = try loadConfig(configFile: configFile)

            guard File.exists(root) else
            {
                throw cryoError.pathNotFound(root)
            }

            let url = URL(fileURLWithPath: root)

            config.projectRoot = url

            try saveConfig(config: config, configFile: configFile)
        }
    }
}

extension cryo
{
    struct setTemp: ParsableCommand
    {
        @Argument(help: "path to checkouts temporary directory")
        var temp: String

        @Option(help: "path to config file")
        var configFile: String?

        mutating public func run() throws
        {
            let config = try loadConfig(configFile: configFile)

            if !File.exists(temp)
            {
                guard File.makeDirectory(atPath: temp) else
                {
                    throw cryoError.couldNotCreateTempDirectory(temp)
                }
            }

            let url = URL(fileURLWithPath: temp)

            config.tempWorkingRoot = url

            try saveConfig(config: config, configFile: configFile)
        }
    }
}

extension cryo
{
    struct addProject: ParsableCommand
    {
        @Argument(help: "URL to project repository")
        var gitURL: String

        @Argument(help: "branch mode parameter")
        var branchMode: BranchMode

        @Option(help: "path to config file")
        var configFile: String?

        mutating public func run() throws
        {
            let config = try loadConfig(configFile: configFile)

            guard let url = URL(string: gitURL) else
            {
                throw cryoError.badURL(gitURL)
            }

            for project in config.projects
            {
                if project.gitRepo == url
                {
                    throw cryoError.badURL(gitURL)
                }
            }

            let project = Project(gitRepo: url, branchMode: branchMode)
            config.projects.append(project)

            try saveConfig(config: config, configFile: configFile)
        }
    }
}


func getConfigURL(configFile: String?) throws -> URL
{
    let configUrl: URL
    if let configFile
    {
        return URL(fileURLWithPath: configFile)
    }
    else
    {
        configUrl = File.homeDirectory().appendingPathComponent(".config").appendingPathComponent("cryo").appendingPathComponent("config.json")
        if !File.exists(configUrl.path)
        {
            guard File.makeDirectory(url: configUrl) else
            {
                throw cryoError.couldNotCreateConfigFile
            }
        }

        return configUrl
    }
}

func loadConfig(configFile: String?) throws -> CryoConfig
{
    let configUrl = try getConfigURL(configFile: configFile)
    return try CryoConfig.load(configUrl)
}

func saveConfig(config: CryoConfig, configFile: String?) throws
{
    let configUrl = try getConfigURL(configFile: configFile)
    try config.save(configUrl)
}

public enum cryoError: Error
{
    case couldNotCreateTempDirectory(String)
    case couldNotCreateConfigFile
    case pathNotFound(String)
    case badURL(String)
    case projectAlreadyAdded(String)
}
