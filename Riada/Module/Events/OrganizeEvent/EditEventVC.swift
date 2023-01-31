//
//  EditEventVC.swift
//  Riada
//
//  Created by Guaire94 on 14/10/2021.
//

import UIKit
import CoreLocation
import Firebase

protocol EditEventVCDelegate: AnyObject {
    func didUpdateEvent(event: Event)
    func didCancelEvent(event: Event)
}

class EditEventVC: UIViewController {
    
    // MARK: - Constants
    enum Constants {
        static var identifier = "EditEventVC"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var sportPickerField: MPickerField!
    @IBOutlet weak private var titleTextField: MTextField!
    @IBOutlet weak private var descTextField: MTextView!
    @IBOutlet weak private var dateAndHourPickerField: MDatePickerField!
    @IBOutlet weak private var addressPickerField: MPickerField!
    @IBOutlet weak private var saveEventButton: UIButton!
    @IBOutlet weak private var cancelEventButton: UIButton!
    @IBOutlet weak private var isParticipateSwitchField: MSwitchField!
    @IBOutlet weak private var isPrivateSwitchField: MSwitchField!

    // MARK: - Variables
    private var sportPickerSource = SportPickerSource()
    private var currentTextField: UITextField?
    private var selectedPlace: GooglePlace?
    private var selectedPlaceAddress: String?
    private var selectedPlaceLocation: CLLocation?

    var event: Event?
    var isOrganiserParticipate: Bool?
    weak var delegate: EditEventVCDelegate?
    
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
        descTextField.delegate = self
        descTextField.addDoneButton(target: self, selector: #selector(tapDone(sender:)))
        addressPickerField.delegate = self
        setUpTranslation()
        setUpField()
        setUpEvent()
    }
    
    private func setUpTranslation() {
        titleLabel.text = L10N.event.edit.title
        sportPickerField.labelText = L10N.event.organize.form.sport
        titleTextField.labelText = L10N.event.organize.form.title
        titleTextField.placeHolder = L10N.event.organize.form.titlePlaceHolder
        descTextField.labelText = L10N.event.organize.form.desc
        dateAndHourPickerField.labelText = L10N.event.organize.form.dateAndHour
        addressPickerField.labelText = L10N.event.organize.form.address
        addressPickerField.labelText = L10N.event.organize.form.address
        isParticipateSwitchField.labelText = L10N.event.organize.form.isParticipate
        isPrivateSwitchField.labelText = L10N.event.organize.form.isPrivate
        saveEventButton.setTitle(L10N.event.edit.form.saveEvent.uppercased(), for: .normal)
        cancelEventButton.setTitle(L10N.event.edit.form.cancelEvent.uppercased(), for: .normal)
    }
    
    private func setUpField() {
        sportPickerField.isEnabled = false
        titleTextField.textContentType = .name
        titleTextField.returnKeyType = .next
        descTextField.textContentType = .name
        descTextField.returnKeyType = .next
        dateAndHourPickerField.mode = .dateAndTime
    }
    
    private func setUpEvent() {
        guard let event = self.event,
              let isOrganiserParticipate = self.isOrganiserParticipate,
              let sportIndex = ManagerSport.shared.sports.firstIndex(where: {$0.id == event.sportId}) else {
            return
        }
        
        selectedPlace = GooglePlace(name: event.placeName, id: event.placeId)
        selectedPlaceAddress = event.placeAddress
        selectedPlaceLocation = CLLocation(latitude: event.placeCoordinate.latitude, longitude: event.placeCoordinate.longitude)
        
        titleTextField.text = event.title
        didSelectSport(index: sportIndex)
        descTextField.text = event.description
        dateAndHourPickerField.date = event.date.dateValue()
        addressPickerField.text = event.placeName
        isParticipateSwitchField.isOn = isOrganiserParticipate
        isPrivateSwitchField.isOn = event.isPrivate
    }
    
    private func didSelectSport(index: Int) {
        sportPickerSource.currentIndexSelected = index
        guard let selectedSport = sportPickerSource.selectedSport else { return }
        sportPickerField.text = selectedSport.localizedName
    }
}

// MARK: - IBAction
extension EditEventVC {
    
    @objc func tapDone(sender: Any) {
        view.endEditing(true)
    }

    @IBAction func dimissToggle() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveToggle() {
        guard let eventId = event?.id,
              let sport = sportPickerSource.selectedSport,
              let sportId = sport.id,
              let title = titleTextField.text,
              let desc = descTextField.text,
              let place = selectedPlace,
              let placeAddress = selectedPlaceAddress,
              let placeLocation = selectedPlaceLocation,
              let createdDate = event?.createdDate,
              let isOrganiserParticipate = isOrganiserParticipate else {
                  showError(title: L10N.event.edit.title, message: L10N.event.edit.form.error.unfill)
            return
        }
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
                          createdDate: createdDate)

        HelperTracking.track(item: .editEventSave)
        ServiceEvent.edit(event: event)

        if !isOrganiserParticipate && isParticipateSwitchField.isOn {
            ServiceEvent.participateAsOrganizer(event: event)
        } else if isOrganiserParticipate && !isParticipateSwitchField.isOn {
            ServiceEvent.unParticipateAsOrganizer(event: event)
        }
                
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)
        navigationController?.popViewController(animated: true)
        delegate?.didUpdateEvent(event: event)
    }
    
    @IBAction func cancelToggle() {
        guard var event = event else { return }
        
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.warning)

        DispatchQueue.main.async {
            let alert = UIAlertController(title: L10N.event.edit.form.cancelEvent,
                                          message: L10N.event.edit.form.cancelMessageEvent, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L10N.global.action.confirm, style: .destructive, handler: { _ in
                HelperTracking.track(item: .editEventCancel)
                event.status = EventStatus.canceled.rawValue
                ServiceEvent.cancel(event: event)
                self.navigationController?.popViewController(animated: true)
                self.delegate?.didCancelEvent(event: event)
            }))
            alert.addAction(UIAlertAction(title: L10N.global.action.cancel, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - MPickerFieldDelegate
extension EditEventVC: MPickerFieldDelegate {
    
    func didTogglePicker(sender: MPickerField) {
        descTextField.textView.resignFirstResponder()
        switch sender {
        case addressPickerField:
            performSegue(withIdentifier: SearchLocationVC.Constants.identifier, sender: self)
        default:
            break
        }
    }
}

// MARK:- SearchLocationVCDelegate
extension EditEventVC: SearchLocationVCDelegate {
    
    func didSelectPlace(place: GooglePlace, address: String, location: CLLocation) {
        addressPickerField.text = place.name
        selectedPlace = place
        selectedPlaceAddress = address
        selectedPlaceLocation = location
    }
}

// MARK: - UITextFieldDelegate
extension EditEventVC: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if textField == titleTextField.textField {
            descTextField.textView.becomeFirstResponder()
        }
        return true
    }
}

// MARK: - UITextViewDelegate
extension EditEventVC: UITextViewDelegate {}


