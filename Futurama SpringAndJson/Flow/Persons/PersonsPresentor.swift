//
//  PersonsPresentor.swift
//  Futurama SpringAndJson
//
//  Created by Nikita Shirobokov on 06.12.22.
//

import Foundation

private extension String {
    static let defaultError = "Произошла ошибка"
}

protocol IPersonPresentor: AnyObject {
    func getItem(for index: Int) -> Person
    var numberOfRows: Int { get }
    func viewDidLoad()
}

class PersonsPresentor {
    private let service: IPersonService
    private let dataSource: IPersonsViewDataSource
    weak var view: IPersonsView?
    
    var numberOfRows: Int {
        dataSource.itemsCount
    }
    
    init(service: IPersonService,
         dataSource: IPersonsViewDataSource
    ) {
        self.service = service
        self.dataSource = dataSource
    }
}

// MARK: ICountriesPresentor

extension PersonsPresentor: IPersonPresentor {
    func viewDidLoad() {
        view?.startLoader()
        service.loadCountries { [weak self] result in
            switch result {
            case let .success(countries):
                self?.dataSource.save(countries)
            // Ошибка на стороне presentor`a
            case let .failure(error):
                print(error)
            }
            DispatchQueue.main.async {
                self?.view?.showAnotherPerson()
                self?.view?.stopLoader()
            }
        }
    }
    
    func getItem(for index: Int) -> Person {
        dataSource.getPerson(at: index)
    }
}
