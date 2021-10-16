//
//  SportPickerSource.swift
//  MyF-Zone
//
//  Created by Quentin Gallois on 22/10/2020.
//

struct SportPickerSource: PickerSingleOption {
    
    // MARK: - Properties
    var sports: [Sport] = ManagerSport.shared.sports
    var currentIndexSelected: Int?
    
    var selectedSport: Sport? {
        guard let row = currentIndexSelected, row < sports.count else { return nil }
        return sports[row]
    }
    var numberOfRows:Int {
        sports.count
    }
        
    // MARK: - Delegate
    func title(forRow row: Int) -> String {
        guard row < sports.count else { return "" }
        return sports[row].localizedName
    }
}
