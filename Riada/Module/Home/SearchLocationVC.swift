//
//  HomeVC.swift
//  Riada
//
//  Created by Guaire94 on 11/09/2021.
//

import UIKit

protocol SearchLocationVCDelegate: class {
    func didSelectLocation(city: City)
}

class SearchLocationVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "SearchLocationVC"
        fileprivate static let contentCornerRadius: CGFloat = 10
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var content: UIView!
    @IBOutlet weak private var locationTextField: MTextField!
    @IBOutlet weak private var citiesTableView: UITableView!
    
    // MARK: - Properties
    private var places: [GooglePlace] = PlaceHolderCity.allCases.map({ GooglePlace(name: $0.name, id: $0.placeId) })
    weak var delegate: SearchLocationVCDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpNotification()
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
        locationTextField.label.text = L10N.searchLocation.text
        locationTextField.placeHolder = L10N.searchLocation.placeHolder
        locationTextField.delegate = self
        locationTextField.returnKeyType = .search
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
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
        
        GooglePlaceHelper.shared.getPlaceDetails(placeId: place.id) { [weak self] (location) in
            cell.isLoading = false
            guard let location = location else { return }
            let city = City(name: place.name, lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            self?.delegate?.didSelectLocation(city: city)
            self?.dismiss(animated: true, completion: nil)
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
            searchCity(query)
        } else {
            citiesTableView.reloadData()
        }
        return true
    }

    func searchCity(_ query: String) {
        GooglePlaceHelper.shared.getPlaces(searchString: query) { (places, error) in
            self.places = places
            DispatchQueue.main.async {
                self.citiesTableView.reloadData()
            }
        }
    }
}
