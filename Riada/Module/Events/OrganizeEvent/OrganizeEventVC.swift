//
//  OrganizeEventVC.swift
//  Riada
//
//  Created by Guaire94 on 14/10/2021.
//

import UIKit
import CoreLocation
import Firebase

protocol OrganizeEventVCDelegate: AnyObject {
    func didCreateEvent(event: Event)
}

class OrganizeEventVC: UIViewController {
    
    // MARK: - Constants
    enum Constants {
        static var identifier = "OrganizeEventVC"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var sportPickerField: MPickerField!
    @IBOutlet weak private var titleTextField: MTextField!
    @IBOutlet weak private var descTextView: MTextView!
    @IBOutlet weak private var dateAndHourPickerField: MDatePickerField!
    @IBOutlet weak private var addressPickerField: MPickerField!
    @IBOutlet weak private var createEventButton: UIButton!
    @IBOutlet weak private var isParticipateSwitchField: MSwitchField!
    @IBOutlet weak private var isPrivateSwitchField: MSwitchField!

    // MARK: - Variables
    private var sportPickerSource = SportPickerSource()
    private var currentTextField: UITextField?
    private var selectedPlace: GooglePlace?
    private var selectedPlaceAddress: String?
    private var selectedPlaceLocation: CLLocation?

    weak var delegate: OrganizeEventVCDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SearchLocationVC.Constants.identifier {
            guard let vc = segue.destination as? SearchLocationVC else { return }
            vc.delegate = self
            vc.searchType = .place
        }
    }
    
    // MARK: - Privates
    private func setUpView() {
        if #available(iOS 13.0, *) {
            dateAndHourPickerField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
            isModalInPresentation = true
        } else {
            dateAndHourPickerField.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        }
        sportPickerField.delegate = self
        titleTextField.delegate = self
        descTextView.addDoneButton(target: self, selector: #selector(tapDone(sender:)))
        descTextView.delegate = self
        addressPickerField.delegate = self
        setUpTranslation()
        setUpField()
        setUpSportIfNeeded()
    }
    
    private func setUpTranslation() {
        titleLabel.text = L10N.event.organize.title
        sportPickerField.labelText = L10N.event.organize.form.sport
        titleTextField.labelText = L10N.event.organize.form.title
        titleTextField.placeHolder = L10N.event.organize.form.titlePlaceHolder
        descTextView.labelText = L10N.event.organize.form.desc
        dateAndHourPickerField.labelText = L10N.event.organize.form.dateAndHour
        addressPickerField.labelText = L10N.event.organize.form.address
        addressPickerField.labelText = L10N.event.organize.form.address
        isParticipateSwitchField.labelText = L10N.event.organize.form.isParticipate
        isPrivateSwitchField.labelText = L10N.event.organize.form.isPrivate
        createEventButton.setTitle(L10N.event.organize.form.createEvent.uppercased(), for: .normal)
    }
    
    private func setUpField() {
        titleTextField.textContentType = .name
        titleTextField.returnKeyType = .next
        descTextView.textContentType = .name
        descTextView.returnKeyType = .next
        dateAndHourPickerField.mode = .dateAndTime
    }
    
    private func setUpSportIfNeeded() {
        guard let sport = ManagerSport.shared.selectedSport,
              let index = ManagerSport.shared.sports.firstIndex(where: {$0.id == sport.id}) else {
                  return
        }
        sportPickerField.text = ManagerSport.shared.selectedSport?.localizedName
        sportPickerSource.currentIndexSelected = index
    }
    
    private func didSelectSport(index: Int) {
        sportPickerSource.currentIndexSelected = index
        guard let selectedSport = sportPickerSource.selectedSport else { return }
        sportPickerField.text = selectedSport.localizedName
    }
}

// MARK: - IBAction
extension OrganizeEventVC {
    
    @objc func tapDone(sender: Any) {
        view.endEditing(true)
    }

    @IBAction func dimissToggle() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func validToggle() {
        guard let sport = sportPickerSource.selectedSport,
              let sportId = sport.id,
              let title = titleTextField.text,
              let desc = descTextView.text,
              let place = selectedPlace,
              let placeAddress = selectedPlaceAddress,
              let placeLocation = selectedPlaceLocation else {
                  showError(title: L10N.event.organize.title, message: L10N.event.organize.form.error.unfill)
            return
        }
        let eventId = UUID().uuidString
        let event = Event(id: eventId,
                          title: title,
                          description: desc,
                          date: dateAndHourPickerField.date.timestamp,
                          placeId: place.id,
                          placeName: place.name,
                          placeAddress: placeAddress,
                          placeCoordinate: GeoPoint(latitude: placeLocation.coordinate.latitude, longitude: placeLocation.coordinate.longitude),
                          sportId: sportId,
                          sportEmoticon: sport.emoticon,
                          sportName: sport.name,
                          isPrivate: isPrivateSwitchField.isOn,
                          status: EventStatus.open.rawValue,
                          createdDate: Date().timestamp)
        
        HelperTracking.track(item: .organizeCreateEvent)
        ServiceEvent.create(event: event)
        
        if isParticipateSwitchField.isOn {
            ServiceEvent.participateAsOrganizer(event: event)
        }
        if !isPrivateSwitchField.isOn {
            ServiceNotification.organize(event: event)
        }

        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)
        dismiss(animated: true)
        delegate?.didCreateEvent(event: event)
    }
}

// MARK: - MPickerFieldDelegate
extension OrganizeEventVC: MPickerFieldDelegate {
    
    func didTogglePicker(sender: MPickerField) {
        guard sender.isEnabled else { return }
        
        descTextView.textView.resignFirstResponder()
        switch sender {
        case sportPickerField:
            sportPickerSource.currentIndexSelected = ManagerSport.shared.sports.firstIndex(where: {$0.id == ManagerSport.shared.selectedSport?.id})
            let controller = PGCPickerViewController.with(pickerOption: sportPickerSource, selectionHandler: didSelectSport)
            present(controller, animated: false)
        case addressPickerField:
            performSegue(withIdentifier: SearchLocationVC.Constants.identifier, sender: self)
        default:
            break
        }
    }
}

// MARK:- SearchLocationVCDelegate
extension OrganizeEventVC: SearchLocationVCDelegate {
    
    func didSelectPlace(place: GooglePlace, address: String, location: CLLocation) {
        addressPickerField.text = place.name
        selectedPlace = place
        selectedPlaceAddress = address
        selectedPlaceLocation = location
    }
}

// MARK: - UITextFieldDelegate
extension OrganizeEventVC: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if textField == titleTextField.textField {
            descTextView.textView.becomeFirstResponder()
        }
        return true
    }
}

// MARK: - UITextViewDelegate
extension OrganizeEventVC: UITextViewDelegate {}


