//
//  SportPickerSource.swift
//  MyF-Zone
//
//  Created by Quentin Gallois on 22/10/2020.
//

struct NbPlayersPickerSource: PickerSingleOption {
    
    // MARK: - Constants
    private enum Constants {
        static var numberOfRows = 19
    }

    // MARK: - Properties
    var currentIndexSelected: Int?
    
    var selectedNbTeams: Int? {
        guard let row = currentIndexSelected, row < Constants.numberOfRows else { return nil }
        return row+2
    }
    var numberOfRows:Int {
        Constants.numberOfRows
    }
        
    // MARK: - Delegate
    func title(forRow row: Int) -> String {
        guard row < Constants.numberOfRows else { return "" }
        return "\(row+2)"
    }
}
