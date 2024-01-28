//
//  MUser.swift
//  hundred-days-with-swiftui
//
//  Created by Anthony Benitez-Rodriguez on 1/28/24.
//

struct MUser: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}
