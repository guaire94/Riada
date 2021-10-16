//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit
import MapKit

protocol SearchLocationVCDelegate: class {
    func didSelectCity(city: City)
    func didSelectPlace(place: GooglePlace, address: String, location: CLLocation)
}

extension SearchLocationVCDelegate {
    func didSelectCity(city: City) {}
    func didSelectPlace(place: GooglePlace, address: String, location: CLLocation) {}
}


class SearchLocationVC: MKeyboardVC {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "SearchLocationVC"
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var locationTextField: MTextField!
    @IBOutlet weak private var citiesTableView: UITableView!
    
    var searchType: SearchType?
    
    // MARK: - Properties
    var places: [GooglePlace] = []
    weak var delegate: SearchLocationVCDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Privates
    private func setupView() {
        content.layer.cornerRadius = Constants.contentCornerRadius
        content.clipsToBounds = true
        
        setupTableView()
        setupTextField()
    }

    private func setupTableView() {
        citiesTableView.register(CityCell.Constants.nib, forCellReuseIdentifier: CityCell.Constants.identifier)
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
        citiesTableView.reloadData()
    }
    
    private func setupTextField() {
        locationTextField.labelText = L10N.searchLocation.text
        locationTextField.placeHolder = L10N.searchLocation.placeHolder
        locationTextField.delegate = self
        locationTextField.returnKeyType = .search
    }
}


// MARK: - UITableViewDataSource
extension SearchLocationVC: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CityCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: CityCell.Constants.identifier, for: indexPath)
        guard let cell = reusableCell as? CityCell else {
            return UITableViewCell()
        }
        let place = places[indexPath.row]
        cell.configure(name: place.name)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchLocationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CityCell else { return }
        cell.isLoading = true
        
        let place = places[indexPath.row]
        
        ServiceGooglePlace.shared.getPlaceCoordinate(placeId: place.id) { [weak self] (placeCoordinate) in
            cell.isLoading = false
            guard let placeCoordinate = placeCoordinate, let searchType = self?.searchType else { return }
            switch searchType {
            case .city:
                let city = City(name: place.name, lat: placeCoordinate.location.coordinate.latitude, lng: placeCoordinate.location.coordinate.longitude)
                self?.delegate?.didSelectCity(city: city)
                self?.dismiss(animated: true, completion: nil)
            case .place:
                self?.delegate?.didSelectPlace(place: place, address: placeCoordinate.address, location: placeCoordinate.location)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SearchLocationVC: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var query = textField.text ?? ""
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        if string.count > 0 {
            query = query + string
        } else if string.count == 0 && query.count > 0 {
            query.removeLast()
        }
        if query.count > 0 {
            search(query)
        } else {
            citiesTableView.reloadData()
        }
        return true
    }

    func search(_ query: String) {
        guard let searchType = self.searchType else { return }
        ServiceGooglePlace.shared.getPlaces(searchString: query, searchType: searchType) { (places, error) in
            self.places = places
            DispatchQueue.main.async {
                self.citiesTableView.reloadData()
            }
        }
    }
}
