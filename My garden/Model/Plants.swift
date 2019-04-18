//
//  Plants.swift
//  My garden
//
//  Created by Ivan Nikitin on 17/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import Foundation

typealias Plants = [Plant]

extension Plants {
    var title: String {
        return "Список растений"
    }
    
    static func loadSample() -> [Plant] {
        return [
            Plant(name: "Морковь", sort: "Витаминная", photo: "carrots", description: "Двулетнее растение, подвид вида морковь дикая. Обычно в быту под словом «морковь» подразумевается широко распространенный корнеплод именно этого растения", plantClass: .vegetable, maturationTime: 60, landingDate: Date(), squareOfPlant: 0.3, harvest: 200),
            Plant(name: "Огурец", sort: "Блорусский", photo: "cucumber", description: "Однолетнее травянистое растение, вид рода Огурец (Cucumis) семейства Тыквенные (Cucurbitaceae), овощная культура.", plantClass: .vegetable, maturationTime: 85, landingDate: Date(), squareOfPlant: 0.5, harvest: 270),
            Plant(name: "Укроп", sort: "Кудрявый", photo: "ukrop", description: "В диком виде произрастает в Малой Азии, Северной Африке, Иране, Гималаях. Как культивируемое и сорное растение — повсеместно на всех континентах.", plantClass: .grass, maturationTime: 45, landingDate: Date(), squareOfPlant: 0.1, harvest: 65),
            Plant(name: "Картофель", sort: "Андрета", photo: "potatoes", description: "Вид многолетних клубненосных травянистых растений из рода Паслён (Solanum) семейства Паслёновые (Solanaceae). Клубни картофеля являются важным пищевым продуктом. Плоды ядовиты, в связи с содержанием в них соланина.", plantClass: .vegetable, maturationTime: 75, landingDate: Date(), squareOfPlant: 10, harvest: 320),
            Plant(name: "Редис", sort: "Круглый", photo: "redis", description: "Редис — съедобное растение и выращивается как овощ во многих странах мира. Его название происходит от лат. radix — корень.", plantClass: .vegetable, maturationTime: 50, landingDate: Date(), squareOfPlant: 0.1, harvest: 120),
            Plant(name: "Баклажан", sort: "Ракета", photo: "baklajan", description: "Вид многолетних травянистых растений рода Паслён (Solanum). Возделывается как однолетнее растение. Съедобен только плод. В ботаническом смысле это ягода, в кулинарном рассматривается как овощ.", plantClass: .vegetable, maturationTime: 67, landingDate: Date(), squareOfPlant: 0.3, harvest: 220),
            Plant(name: "Клубника", sort: "Украинская", photo: "strawberry", description: "Сладкая ягода крассного цвета, растет на кустах.", plantClass: .berry, maturationTime: 79, landingDate: Date(), squareOfPlant: 0.6, harvest: 8)
        ]
    }
}
