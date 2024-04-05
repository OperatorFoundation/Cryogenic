//
//  SpinnerBlock.swift
//
//
//  Created by Dr. Brandon Wiley on 4/5/24.
//

import Foundation

import CLISpinner

public class SpinnerBlock
{
    public init(start: String, success: String, fail: String, function: () throws -> Void)
    {
        let spinner = Spinner(pattern: .arc, text: start)
        spinner.start()

        do
        {
            try function()
            spinner.succeed(text: success)
        }
        catch
        {
            spinner.fail(text: fail)
        }
    }
}
