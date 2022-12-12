//
//  IPersonService.swift
//  Futurama SpringAndJson
//
//  Created by Nikita Shirobokov on 06.12.22.
//

import Foundation

private extension String {
    static let futuramaUrl = "https://api.sampleapis.com/futurama/characters"
}
    

enum PersonsServiceError: String, Error {
    case nonValidUrl = "Неправильный URL адрес"
    case nonValidData = "Ошибка в загруженных данных"
    case decodeError = "Не удалось декодировать данные"
}

protocol IPersonService: AnyObject {
    func loadCountries(_ completion: @escaping (Result<[Person], Error>) -> Void)
}

class PersonService {}

extension PersonService: IPersonService {
    func loadCountries(_ completion: @escaping (Result<[Person], Error>) -> Void) {
        // СОЗДАНИЕ url запроса
        guard let url = URL(string: .futuramaUrl) else {
            completion(.failure(PersonsServiceError.nonValidUrl))
            return
        }
        // Создаем задачу в URLSession на выполнеие GET-запроса
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            // Проверяем ошибку от запроса
            if let error = error {
                completion(.failure(error))
                return
            }
            // Проверяем, пришли ли данные из запроса
            guard let data = data else {
                completion(.failure(PersonsServiceError.nonValidData))
                return
            }
            // ДЕКОДИРОВАНИЕ (парсим JSON)
            let persons = try? JSONDecoder().decode([Person].self, from: data)
            if let persons = persons {
                completion(.success(persons))
            } else {
                completion(.failure(PersonsServiceError.decodeError))
            }
            
        }.resume()
    }
}
