//
//  UserData.swift
//  SinglePhoto
//
//  Created by Abael He on 7/19/20.
//  Copyright © 2020 Abael He. All rights reserved.
//

import Combine

final class UserData: ObservableObject {
    @Published var showFavoriatesOnly:Bool = false
    @Published var landmarks:[Landmark] = landmarkData

}
