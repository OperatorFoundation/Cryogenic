//
//  BranchMode.swift
//
//
//  Created by Dr. Brandon Wiley on 4/3/24.
//

import ArgumentParser
import Foundation

import Text

public enum BranchModeType: String, Codable, ExpressibleByArgument
{
    case release
    case branch
}

public enum BranchMode: Codable
{
    case release(VersionNumber)
    case branch(String)
}

extension BranchMode: ExpressibleByArgument
{
    public init?(argument: String)
    {
        if argument.text.containsSubstring(".")
        {
            guard let version = VersionNumber(string: argument) else
            {
                return nil
            }
            
            self = .release(version)
        }
        else
        {
            self = .branch(argument)
        }
    }
}
