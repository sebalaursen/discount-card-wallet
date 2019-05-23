//
//  Cards.swift
//  DiscountCards
//
//  Created by Sebastian on /17/4/19.
//  Copyright © 2019 Sebastian Laursen. All rights reserved.
//

import UIKit

class Wallet {
    static let shared = Wallet()
    
    var cards: [card] = []
    let coreData = CoreDataStack()
    
    private init() {}
    
    func add(_ card: card) {
        if cards.contains(card) {
            
        } else {
            cards.append(card)
            coreData.add(logo: card.logo, title: card.title, barcode: card.barcode)
            NotificationCenter.default.post(name: .addedCard, object: nil)
        }
    }
    
    func remove(at index: Int) {
        cards.remove(at: index)
        coreData.delete(at: index)
        NotificationCenter.default.post(name: .removedCard, object: nil, userInfo: [0:index])
    }
    
    func edit(at index: Int, to card: card) {
        cards[index].logo = card.logo
        cards[index].title = card.title
        coreData.edit(logo: card.logo, title: card.title, barcode: card.barcode, at: index)
        NotificationCenter.default.post(name: .editedCard, object: nil)
    }
    
    func getFavs() -> [card] {
        var res: [card] = []
        for c in cards {
            if c.isFav {
                res.append(c)
            }
        }
        return res
    }
}
