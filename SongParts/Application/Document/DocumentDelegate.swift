//
//  DocumentDelegate.swift
//  SongParts
//
//  Created by Lucas Ference on 6/11/20.
//  Copyright © 2020 Lucas Ference. All rights reserved.
//

import Foundation

public enum SourceType: Int {
    case files
    case folder
}

protocol DocumentDelegate: class {
    func didPickDocuments(documents: [Document]?)
}
