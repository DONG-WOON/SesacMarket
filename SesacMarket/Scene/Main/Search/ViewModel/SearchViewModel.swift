//
//  SearchViewModel.swift
//  SesacMarket
//
//  Created by 서동운 on 9/7/23.
//

import Foundation

class SearchViewModel {
    var items: [Item] = []
    var page = 1
    var sort: Sort = .sim
    
    func getItem(search: String, completion: @escaping () -> Void) {
        APIManager.shared.request(search: search, page: page, sort: sort)
        { items in
            self.items.append(contentsOf: items)
            completion()
        } onFailure: { error in
            print(error)
        }
    }
}
