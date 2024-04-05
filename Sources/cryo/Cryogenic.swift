//
//  Cryogenic.swift
//
//
//  Created by Dr. Brandon Wiley on 4/4/24.
//

import Foundation

import CLISpinner
import Gardener

public class Cryogenic
{
    let config: CryoConfig
    let git: Git
    let swift: SwiftTool

    public init?(_ config: CryoConfig)
    {
        self.config = config

        self.git = Git()

        guard let swift = SwiftTool() else
        {
            return nil
        }

        self.swift = swift
    }

    public func initialize() throws
    {
        let _ = SpinnerBlock(start: "Checking out \(self.config.branch) branch...", success: "Checked out \(self.config.branch).", fail: "Checkout failed!")
        {
            try self.git.checkout(self.config.branch)
        }

        let _ = SpinnerBlock(start: "Pulling from upstream \(self.config.remoteName)/\(self.config.branch)...", success: "Pulled from upstream \(self.config.remoteName)/\(self.config.branch).", fail: "Git pull failed!")
        {
            try self.git.pull(self.config.remoteName, self.config.branch)
        }
    }

    public func build() throws
    {
        try self.initialize()

        let _ = SpinnerBlock(start: "Updating depedencies...", success: "Updated dependencies.", fail: "Swift package update failed!")
        {
            try self.swift.update()
        }

        let _ = SpinnerBlock(start: "Building...", success: "Build succeeded.", fail: "Swift build failed!")
        {
            try self.swift.build()
        }
    }

    public func run() throws
    {
        try self.build()

        let _ = SpinnerBlock(start: "Running \(self.config.target ?? "")...", success: "Run succeeded.", fail: "Run failed!")
        {
            try self.swift.run()
        }
    }
}

public enum CryogenicError: Error
{
    case checkoutFailed
    case pullFailed
    case buildFailed
    case updateFailed
}
