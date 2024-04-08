//
//  TemplateLoader.swift
//
//
//  Created by Dr. Brandon Wiley on 4/8/24.
//

import Foundation

import Stencil

class TemplateLoader: Loader
{
    func loadTemplate(name: String, environment: Environment) throws -> Template
    {
        guard let fileURL = Bundle.module.url(forResource: name, withExtension: "txt") else
        {
            throw TemplateDoesNotExist(templateNames: [name], loader: self)
        }

        let fileContents = try String(contentsOf: fileURL)
        return Template(templateString: fileContents, environment: environment)
    }
}
