//
//  IconFileGeneratorService.swift
//  XcodeAssetsIconGenerator
//
//  Created by Thinh Tran on 28/5/2022.
//

import Foundation
import UIKit

protocol IconFileGeneratorServiceProtocol {
    
    func generateIconsURL(for appIconTypes: [AppIconType], with image: UIImage) async throws -> URL
    
}

struct IconFileGeneratorService: IconFileGeneratorServiceProtocol {
    
    let fileService: FileIconServiceProtocol
    let resizeService: IconResizerServiceProtocol
    
    func generateIconsURL(for appIconTypes: [AppIconType], with image: UIImage) async throws -> URL {
        self.fileService.deleteExistingTemporaryDirectoryURL()
        
        for appIconType in appIconTypes {
            let icons = try await self.resizeService.resizeIcons(from: image, for: appIconType)
            try await self.fileService.saveIconsToTemporaryDir(icons: icons, appIconType: appIconType)
        }
        
        let url = try await self.fileService.archiveTemporaryDirectoryToURL()
        return url
    }
    
}
