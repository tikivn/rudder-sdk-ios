//
//  RSTraits.swift
//  Rudder
//
//  Created by Desu Sai Venkat on 12/08/21.
//

import Foundation

struct RSTraits: Codable {
    var anonymousId: String?
    var age: String?
    var birthday: String?
    var createdAt: String?
    var description: String?
    var email: String?
    var firstName: String?
    var gender: String?
    var userId: String?
    var lastName: String?
    var name: String?
    var phone: String?
    var title: String?
    var userName: String?
//    var extras: [String : Any]?
//    var address: [String : Any]?
//    var company: [String : Any]?

    enum CodingKeys: String, CodingKey {
        case anonymousId, age, birthday
        case createdAt, description, email
        case firstName = "firstname", gender, userId, lastName = "lastname"
        case name, phone, title, userName
//        case company, address, extras
    }
}
