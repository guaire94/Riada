//
//  EventDetailsVC.swift
//  Riada
//
//  Created by Guaire94 on 18/09/2021.
//

import UIKit
import EventKitUI
import MapKit

class EventDetailsAsOrganizerVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier: String = "EventDetailsAsOrganizerVC"
        static let bottomContentInset: CGFloat = 8.0
        enum url{
            static func googleMap(coordinate: CLLocationCoordinate2D) -> URL? {
                URL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude))&directionsmode=driving&zoom=14&views=traffic")
            }
            static func waze(coordinate: CLLocationCoordinate2D) -> URL? {
                URL(string: "https://waze.com/ul?ll=\(coordinate.latitude),\(coordinate.longitude)&navigate=yes")
            }
            static let plan: URL? = URL(string: "http://maps.apple.com/")
        }
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak private var sportLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var statusBar: UIView!
    @IBOutlet weak private var statusDesc: UILabel!
    @IBOutlet weak private var eventTableView: UITableView!
    @IBOutlet weak private var actionBar: UIView!
    @IBOutlet weak private var addGuestButton: MButton!
    @IBOutlet weak private var editButton: MButton!
    var participantSectionCell: SectionCell?
    
    //MARK: - Properties
    private var sections = MEventSectionAsOrganizer.toDisplay()
    var event: Event?
    var photoUrls: [URL] = [] {
        didSet {
            let section = MEventSectionAsOrganizer.place.rawValue
            eventTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
    var participants: [Participant] = [] {
        didSet {
            let section = MEventSectionAsOrganizer.participants.rawValue
            eventTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
    var guests: [Guest] = [] {
        didSet {
            let section = MEventSectionAsOrganizer.guests.rawValue
            eventTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        syncEvent()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ParticipateVC.Constants.identifier {
            guard let vc = segue.destination as? ParticipateVC else { return }
            vc.event = event
        } else if segue.identifier == AddGuestVC.Constants.identifier {
            guard let vc = segue.destination as? AddGuestVC else { return }
            vc.delegate = self
            vc.event = event
            vc.asOrganizer = true
        } else if segue.identifier == ParticipantVC.Constants.identifier {
            guard let vc = segue.destination as? ParticipantVC,
            let participant = sender as? Participant else {
                return
            }
            vc.delegate = self
            vc.event = event
            vc.participant = participant
        } else if segue.identifier == GuestVC.Constants.identifier {
            guard let vc = segue.destination as? GuestVC,
                  let guest = sender as? Guest else {
                return
            }
            vc.delegate = self
            vc.event = event
            vc.guest = guest
        } else if segue.identifier == EditEventVC.Constants.identifier {
            guard let vc = segue.destination as? EditEventVC else { return }
            vc.delegate = self
            vc.event = event
        } else if segue.identifier == OtherProfileVC.Constants.identifier {
            guard let vc = segue.destination as? OtherProfileVC,
                  let user = sender as? User else {
                      return
                  }
            vc.user = user
        }
    }
    
    //MARK: - Privates
    private func setUpView() {
        guard let event = event else { return }
        HelperTracking.track(item: .eventDetails)
        
        actionBar.isHidden = event.eventStatus == .canceled

        titleLabel.text = event.title
        setUpTableView()
        
        setUpButtons()
        setUpStatusBar()
    }
    
    private func setUpTableView() {
        eventTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.bottomContentInset, right: 0)
        eventTableView.register(SectionCell.Constants.nib,
                                forHeaderFooterViewReuseIdentifier: SectionCell.Constants.identifier)
        
        for section in sections {
            eventTableView.register(section.cellNib, forCellReuseIdentifier: section.cellIdentifier)
        }
        eventTableView.dataSource = self
        eventTableView.delegate = self
    }
    
    private func setUpButtons() {
        addGuestButton.setTitle(L10N.event.details.buttons.addGuest.uppercased(), for: .normal)
        editButton.setTitle(L10N.event.details.buttons.edit.uppercased(), for: .normal)
    }
    
    private func setUpStatusBar() {
        guard let event = event, event.eventStatus == .canceled else {
            statusBar.isHidden = true
            return
        }
        statusBar.isHidden = false
        statusBar.backgroundColor = event.eventStatus.color
        statusDesc.text = event.eventStatus.desc
    }
    
    private func syncEvent() {
        guard let eventId = event?.id, let placeId = event?.placeId else { return }
        
        ServiceGooglePlace.shared.getPlacePhotos(placeId: placeId) { [weak self] (photoUrls) in
            self?.photoUrls = photoUrls
        }
        ServiceEvent.getEventParticipants(eventId: eventId, delegate: self)
        ServiceEvent.getEventGuests(eventId: eventId, delegate: self)
    }
        
    private func addEventToCalendar() {
        guard let event = self.event else { return }
        
        HelperTracking.track(item: .eventDetailsAddToCalendar)
        let eventStore = EKEventStore()
        eventStore.requestAccess( to: EKEntityType.event, completion:{ granted, error in
            HelperDynamicLink.generateEventDetails(event: event, completion: { url in
                guard let url = url else { return }
                DispatchQueue.main.async {
                    guard granted, error == nil else {
                        self.showError(title: L10N.event.details.addToCalendar.error.title,
                                       message: L10N.event.details.addToCalendar.error.message)
                        return
                    }
                    

                    let eventController = EKEventEditViewController()
                    eventController.event = event.toCalendarEvent(deeplink: url, with: eventStore)
                    eventController.eventStore = eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                }
            })
        })
    }
    
    func goTo() {
        guard let event = self.event else { return }
        
        HelperTracking.track(item: .eventDetailsGoTo)
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: event.placeName, message: L10N.event.details.goTo.title, preferredStyle: UIAlertController.Style.alert)
            if let url = Constants.url.waze(coordinate: event.location.coordinate), UIApplication.shared.canOpenURL(url) {
                alertController.addAction(UIAlertAction(title: L10N.event.details.goTo.waze, style: .default, handler: { (action) in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
            }
            if let url = Constants.url.googleMap(coordinate: event.location.coordinate), UIApplication.shared.canOpenURL(url) {
                alertController.addAction(UIAlertAction(title: L10N.event.details.goTo.gmaps, style: .default, handler: { (action) in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
            }
            if let url = Constants.url.plan, UIApplication.shared.canOpenURL(url) {
                alertController.addAction(UIAlertAction(title: L10N.event.details.goTo.plan, style: .default, handler: { (action) in
                    let regionDistance: CLLocationDistance = 10000
                    let regionSpan = MKCoordinateRegion(center: event.location.coordinate,
                                                        latitudinalMeters: regionDistance,
                                                        longitudinalMeters: regionDistance)
                    let options = [
                        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                    ]
                    let placemark = MKPlacemark(coordinate: event.location.coordinate, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = event.placeName
                    mapItem.openInMaps(launchOptions: options)
                }))
            }
            alertController.addAction(UIAlertAction(title: L10N.event.details.goTo.notNecessary, style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - ServiceEventParticipantDelegate
extension EventDetailsAsOrganizerVC: ServiceEventParticipantDelegate  {
    func dataAdded(participant: Participant) {
        participants.append(participant)
    }
    
    func dataModified(participant: Participant) {
        guard let index = participants.firstIndex(where: { $0.id == participant.id }) else { return }
        participants[index] = participant
    }
    
    func dataRemoved(participant: Participant) {
        guard let index = participants.firstIndex(where: { $0.id == participant.id }) else { return }
        participants.remove(at: index)
    }

    func didFinishLoading() {
    }
}

// MARK: - ServiceEventGuestDelegate
extension EventDetailsAsOrganizerVC: ServiceEventGuestDelegate  {
    func dataAdded(guest: Guest) {
        guests.append(guest)
    }
    
    func dataModified(guest: Guest) {
        guard let index = guests.firstIndex(where: { $0.id == guest.id }) else { return }
        guests[index] = guest
    }
    
    func dataRemoved(guest: Guest) {
        guard let index = guests.firstIndex(where: { $0.id == guest.id }) else { return }
        guests.remove(at: index)
    }
}

// MARK: - UITableViewDataSource
extension EventDetailsAsOrganizerVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].desc != nil ? SectionCell.Constants.height : .zero
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionDesc = sections[section].desc,
              let event = self.event,
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionCell.Constants.identifier) as? SectionCell else { return nil
              }
        let eventSection = sections[section]
        
        switch eventSection {
        case .informations, .place:
            header.setUp(desc: sectionDesc)
        case .participants:
            let desc = String(format: sectionDesc, arguments: [event.nbAcceptedPlayer, event.nbPlayer])
            header.setUp(desc: desc)
            participantSectionCell = header
        default:
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sections[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .informations, .place:
            return 1
        case .participants:
            return participants.count
        case .guests:
            return guests.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .informations:
            guard let event = event,
                  let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventInformationsCell else {
                      return UITableViewCell()
                  }
            cell.setUp(date: event.date, desc: event.description)
            return cell
        case .place:
            guard let event = event,
                  let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventPlaceCell else {
                      return UITableViewCell()
                  }
            cell.setUp(name: event.placeName, address: event.placeAddress, photos: photoUrls)
            return cell
        case .participants:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventParticipantCell else {
                return UITableViewCell()
            }
            cell.setUp(participant: participants[indexPath.row])
            return cell
        case .guests:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventParticipantCell else {
                return UITableViewCell()
            }
            cell.setUp(guest: guests[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension EventDetailsAsOrganizerVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .informations:
            addEventToCalendar()
        case .place:
            goTo()
        case .participants:
            let participant = participants[indexPath.row]
            guard let userId = ManagerUser.shared.userId,
                  participant.userId != userId else {
                      return
            }
            
            if participant.participationStatus == .declined {
                showError(title: participant.userNickName, message: L10N.event.details.error.userDeclineAlready)
            } else {
                HelperTracking.track(item: .eventDetailsParticipant)
                performSegue(withIdentifier: ParticipantVC.Constants.identifier, sender: participant)
            }
        case .guests:
            HelperTracking.track(item: .eventDetailsGuest)
            performSegue(withIdentifier: GuestVC.Constants.identifier, sender: guests[indexPath.row])
        }
    }
}

// MARK: - EKEventEditViewDelegate
extension EventDetailsAsOrganizerVC: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - EKEventEditViewDelegate
extension EventDetailsAsOrganizerVC: EditEventVCDelegate {
    func didUpdateEvent(event: Event) {
        if self.event?.placeId != event.placeId {
            ServiceGooglePlace.shared.getPlacePhotos(placeId: event.placeId) { [weak self] (photoUrls) in
                self?.photoUrls = photoUrls
            }
        }
        self.event = event
        titleLabel.text = event.title
        eventTableView.reloadData()
        
        guard let userId = ManagerUser.shared.userId else { return }
        let filteredParticipants = participants.filter({ $0.userId != userId && [.accepted, .pending].contains($0.participationStatus) })
        ServiceNotification.editEvent(event: event, participants: filteredParticipants)
    }
    
    func didCancelEvent(event: Event) {
        guard let userId = ManagerUser.shared.userId else { return }
        let filteredParticipants = participants.filter({ $0.userId != userId && [.accepted, .pending].contains($0.participationStatus) })
        ServiceNotification.cancelEvent(event: event, participants: filteredParticipants)
        
        self.event = event
        statusBar.isHidden = false
        statusBar.backgroundColor = EventStatus.canceled.color
        statusDesc.text = EventStatus.canceled.desc
        actionBar.isHidden = true
    }
}

// MARK: - ParticipantVCDelegate
extension EventDetailsAsOrganizerVC: ParticipantVCDelegate {

    func didTapOnParticipantProfile(userId: String) {
        ServiceUser.getOtherProfile(userId: userId) { user in
            self.performSegue(withIdentifier: OtherProfileVC.Constants.identifier, sender: user)
        }
    }
    
    func didUpdateNbAcceptedPlayerFromParticipant(nbAcceptedPlayer: Int) {
        event?.nbAcceptedPlayer = nbAcceptedPlayer
        
        guard let sectionDesc = sections[MEventSectionAsOrganizer.participants.rawValue].desc,
                let event = self.event else {
                    return
        }
        let desc = String(format: sectionDesc, arguments: [event.nbAcceptedPlayer, event.nbPlayer])
        participantSectionCell?.setUp(desc: desc)
    }
    
    func didAcceptParticipation(participant: Participant) {
        guard let event = self.event else { return }
        let filteredParticipants = participants.filter({ $0.userId != participant.userId && $0.participationStatus == .accepted })
        ServiceNotification.acceptNewParticipation(event: event, participants: filteredParticipants, joiner: participant)
    }
}

// MARK: - AddGuestVCDelegate
extension EventDetailsAsOrganizerVC: AddGuestVCDelegate {
    
    func didAddGuest(guest: Guest) {
        guard let event = self.event else { return }
        let filteredParticipants = participants.filter({ $0.userId != guest.associatedUserId && $0.participationStatus == .accepted })
        ServiceNotification.acceptNewGuest(event: event, participants: filteredParticipants, joiner: guest)
    }
    
    func didUpdateNbAcceptedPlayerFromAddGuest(nbAcceptedPlayer: Int) {
        event?.nbAcceptedPlayer = nbAcceptedPlayer
        
        guard let sectionDesc = sections[MEventSectionAsOrganizer.participants.rawValue].desc,
                let event = self.event else {
                    return
        }
        let desc = String(format: sectionDesc, arguments: [event.nbAcceptedPlayer, event.nbPlayer])
        participantSectionCell?.setUp(desc: desc)
    }
}

// MARK: - GuestVCDelegate
extension EventDetailsAsOrganizerVC: GuestVCDelegate {
    
    func didTapOnGuestProfile(userId: String) {
        ServiceUser.getOtherProfile(userId: userId) { user in
            self.performSegue(withIdentifier: OtherProfileVC.Constants.identifier, sender: user)
        }
    }
    
    func didUpdateNbAcceptedPlayerFromGuest(nbAcceptedPlayer: Int) {
        event?.nbAcceptedPlayer = nbAcceptedPlayer
        
        guard let sectionDesc = sections[MEventSectionAsOrganizer.participants.rawValue].desc,
                let event = self.event else {
                    return
        }
        let desc = String(format: sectionDesc, arguments: [event.nbAcceptedPlayer, event.nbPlayer])
        participantSectionCell?.setUp(desc: desc)
    }
    
    func didAcceptGuest(guest: Guest) {
        guard let event = self.event else { return }
        let filteredParticipants = participants.filter({ $0.userId != guest.associatedUserId && $0.participationStatus == .accepted })
        ServiceNotification.acceptNewGuest(event: event, participants: filteredParticipants, joiner: guest)
    }
}

// MARK: IBAction
extension EventDetailsAsOrganizerVC {
    
    @IBAction func backToggle(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareToggle(_ sender: Any) {
        guard let event = event else { return }
        
        HelperTracking.track(item: .eventDetailsShare)
        HelperDynamicLink.generateEventDetails(event: event, completion: { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems : [url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func addGuestToggle(_ sender: Any) {
        HelperTracking.track(item: .eventDetailsAddGuest)
        performSegue(withIdentifier: AddGuestVC.Constants.identifier, sender: nil)
    }
    
    @IBAction func editToggle(_ sender: Any) {
        HelperTracking.track(item: .eventDetailsEdit)
        performSegue(withIdentifier: EditEventVC.Constants.identifier, sender: nil)
    }
}
