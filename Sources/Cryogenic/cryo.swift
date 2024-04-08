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
        subcommands: [initialize.self, build.self, run.self, show.self, install.self]
    )
}

extension cryo
{
    struct initialize: ParsableCommand
    {
        @Argument(help: "git remote name to use for pulls")
        var remote: String

        @Argument(help: "git branch to check out")
        var branch: String

        @Argument(help: "executable to run")
        var target: String?

        @Argument(help: "arguments to pass to the executable")
        var arguments: [String]

        @Option(help: "path to config file")
        var configFile: String?

        mutating public func run() throws
        {
            let config: CryoConfig
            if let maybeConfig = try? loadConfig(configFile: configFile)
            {
                config = maybeConfig

                config.remoteName = remote
                config.branch = branch
                config.target = target
                config.arguments = arguments
            }
            else
            {
                config = CryoConfig(remoteName: remote, branch: branch, target: target, arguments: arguments)
            }

            try saveConfig(config: config, configFile: configFile)

            guard let cryo = Cryogenic(config) else
            {
                throw cryoError.couldNotInstantiateCryogenic
            }

            try cryo.initialize()
        }
    }
}

extension cryo
{
    struct build: ParsableCommand
    {
        @Option(help: "path to config file")
        var configFile: String?

        mutating public func run() throws
        {
            let config = try loadConfig(configFile: configFile)

            guard let cryo = Cryogenic(config) else
            {
                throw cryoError.couldNotInstantiateCryogenic
            }

            try cryo.build()
        }
    }
}

extension cryo
{
    struct run: ParsableCommand
    {
        @Option(help: "path to config file")
        var configFile: String?

        mutating public func run() throws
        {
            let config = try loadConfig(configFile: configFile)

            guard let cryo = Cryogenic(config) else
            {
                throw cryoError.couldNotInstantiateCryogenic
            }

            try cryo.run()
        }
    }
}

extension cryo
{
    struct show: ParsableCommand
    {
        @Option(help: "path to config file")
        var configFile: String?

        mutating public func run() throws
        {
            let config = try loadConfig(configFile: configFile)

            print(config)
        }
    }
}

extension cryo
{
    struct install: ParsableCommand
    {
        @Option(help: "path to config file")
        var configFile: String?

        mutating public func run() throws
        {
            let config = try loadConfig(configFile: configFile)

            guard let cryo = Cryogenic(config) else
            {
                throw cryoError.couldNotInstantiateCryogenic
            }

            try cryo.install()
        }
    }
}

func getConfigURL(configFile: String?) throws -> URL
{
    if let configFile
    {
        return URL(fileURLWithPath: configFile)
    }
    else
    {
        return URL(fileURLWithPath: File.currentDirectory()).appendingPathComponent("cryogenic.config")
    }
}

func loadConfig(configFile: String?) throws -> CryoConfig
{
    do
    {
        let configUrl = try getConfigURL(configFile: configFile)
        return try CryoConfig.load(configUrl)
    }
    catch
    {
        return CryoConfig(remoteName: "origin", branch: "main", target: nil, arguments: [])
    }
}

func saveConfig(config: CryoConfig, configFile: String?) throws
{
    let configUrl = try getConfigURL(configFile: configFile)
    try config.save(configUrl)
}

public enum cryoError: Error
{
    case couldNotInstantiateCryogenic
    case couldNotCreateTempDirectory(String)
    case couldNotCreateProjectDirectory(String)
    case couldNotCreateConfigFile
    case pathNotFound(String)
    case badURL(String)
    case projectAlreadyAdded(String)
}
