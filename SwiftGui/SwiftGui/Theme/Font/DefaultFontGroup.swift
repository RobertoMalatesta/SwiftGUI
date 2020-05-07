//
// Copyright (c) 2020, Erick Jung.
// All rights reserved.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

import Foundation

public class DefaultFontGroup: FontGroup {
    
    public enum Types {
        
        public static let FiraCode_12 = 0 // default
        public static let FiraCode_14 = 1
        public static let FiraCode_16 = 2
        public static let FiraCode_18 = 3
        public static let FiraCode_20 = 4
        public static let FiraCode_22 = 5
        public static let FiraCode_24 = 6
    }
    
    public var fonts: [[String: [Float]]]? {
        
        let bundle = Bundle(for: DefaultFontGroup.self)
        var fontList = [[String: [Float]]]()
        
        if let path = bundle.path(forResource: "FiraCodeRegular", ofType: "ttf") {
            
            fontList.append([path: [12, 14, 16, 18, 20, 22, 24]])
        }

        return fontList.count > 0 ? fontList : nil
    }
    
    public init() {}
}
