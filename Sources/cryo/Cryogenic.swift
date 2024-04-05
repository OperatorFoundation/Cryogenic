//
//  Cryogenic.swift
//
//
//  Created by Dr. Brandon Wiley on 4/4/24.
//

import Foundation

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
        guard let _ = self.git.checkout(self.config.branch) else
        {
            throw CryogenicError.checkoutFailed
        }

        guard let _ = self.git.pull(self.config.remoteName, self.config.branch) else
        {
            throw CryogenicError.pullFailed
        }
    }

    public func build() throws
    {
        guard let _ = self.git.checkout(self.config.branch) else
        {
            throw CryogenicError.checkoutFailed
        }

        guard let _ = self.git.pull(self.config.remoteName, self.config.branch) else
        {
            throw CryogenicError.pullFailed
        }

        guard let _ = self.swift.update() else
        {
            throw CryogenicError.updateFailed
        }

        guard let _ = self.swift.build() else
        {
            throw CryogenicError.buildFailed
        }
    }

    public func run() throws
    {
        guard let _ = self.git.checkout(self.config.branch) else
        {
            throw CryogenicError.checkoutFailed
        }

        guard let _ = self.git.pull(self.config.remoteName, self.config.branch) else
        {
            throw CryogenicError.pullFailed
        }

        guard let _ = self.swift.build() else
        {
            throw CryogenicError.buildFailed
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
