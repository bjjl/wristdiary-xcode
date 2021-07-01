//
//  ListViewModel.swift
//  wristdiary iPhone App
//
//  Created by Benjamin Lorenz on 26.06.21.
//

import Foundation

class ListViewModel: ObservableObject {

    static var shared = ListViewModel()
    
    @Published var items: Array<entry> = []

}
