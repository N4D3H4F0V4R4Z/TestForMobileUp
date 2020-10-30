//
//  PersonModel.swift
//  TestForMobileUp
//
//  Created by Наджафов Араз on 30.10.2020.
//

import Foundation

// Создаем модель, который отвечал бы требованиям из JSON, лучше всего для этого использовать протоколы Decodable или Codable, которые позволяют переводить данные из JSON в модели; мы используем протокол Decodable, потому что мы конвертируем из(!) JSON. В целом, протокол реализуется, чтобы наша модель понимала, как надо "парсить" данные, которые в неё пришли.

class PersonModel: Decodable {
    
    var user: UserModel? = nil
    var message: MessageModel? = nil
    
    // Создаются "CodingKeys", то есть "ключи", под которые будем "парсить"; в данном случае, поскольку в JSON 4 ответа разбиты на 2 группы, соответственно будем использовать "фолдеры"
    enum CodingKeys: String, CodingKey {
        case user = "user"
        case message = "message"
    }
    
    // В инициализатор передается Декодер, и он будет использоваться, когда мы будем парсить извне; так же у нас есть "контейнер", куда мы передаем "ключи", после этого мы начинаем декодировать каждый контейнер (user и message)
    required init(from decoder: Decoder) throws {
        // decodeIfPresent - функция, которая отдает результат опциональный, иначе был бы "краш"
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decodeIfPresent(UserModel.self, forKey: .user) ?? nil
        message = try container.decodeIfPresent(MessageModel.self, forKey: .message) ?? nil
    }
    
}

class UserModel: Decodable {
    
    var name = ""
    var image = ""
    
    enum CodingKeys: String, CodingKey {
        case name = "nickname"
        case image = "avatar_url"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
    
}

class MessageModel: Decodable {
    
    var message = ""
    var date = ""
    
    enum CodingKeys: String, CodingKey {
        case message = "text"
        case date = "receiving_date"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
    }
    
}
