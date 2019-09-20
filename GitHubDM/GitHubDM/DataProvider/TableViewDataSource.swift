//
//  TableViewDataSource.swift
//  GitHubDM
//
//  Created by Mufakkharul Islam Nayem on 9/20/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

protocol ObservableDataSource {
    associatedtype T
    var data: Observable<T> { get }
}

class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, ObservableDataSource, UITableViewDataSource {

    typealias CellConfigurator = (Model, Cell) -> Void

    var data: Observable<[Model]> = Observable([Model]())

    let reuseIdentifier: String
    let cellConfigurator: CellConfigurator

    init(model type: Model.Type, cell cellType: Cell.Type, reuseIdentifier: String = String(describing: Cell.self), cellConfiguration: @escaping CellConfigurator) {
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfiguration
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        let model = data.value[indexPath.row]
        cellConfigurator(model, cell)
        return cell
    }

}

