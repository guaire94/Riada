//
//  EventDetailsVC.swift
//  Riada
//
//  Created by Guaire94 on 18/09/2021.
//

import UIKit
import EventKitUI
import MapKit

class EventDetailsAsParticipantVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier: String = "EventDetailsAsParticipantVC"
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
    @IBOutlet weak private var participateButton: MButton!
    @IBOutlet weak private var addGuestButton: MButton!
    @IBOutlet weak private var declineButton: MButton!
    
    //MARK: - Properties
    private var sections: [MEventSectionAsParticipant] = [.organizer, .informations, .place, .participants, .guests]

    var event: Event?
    var photoUrls: [URL] = [] {
        didSet {
            guard let section = sections.firstIndex(where: { $0 == .place || $0 == .placeWithPictures }) else { return }
            DispatchQueue.main.async {
                self.eventTableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
        }
    }
    var organizer: Organizer?
    var participants: [Participant] = [] {
        didSet {
            guard let section = sections.firstIndex(where: { $0 == .participants }) else { return }
            DispatchQueue.main.async {
                self.eventTableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
        }
    }
    var guests: [Guest] = [] {
        didSet {
            guard let section = sections.firstIndex(where: { $0 == .guests }) else { return }
            DispatchQueue.main.async {
                self.eventTableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
        }
    }
    var currentUserParticipationStatus: ParticipationStatus? = nil {
        didSet {
            updateStatusBarState()
            updateButtonsState()
        }
    }
    var currentUserParticipate: Bool {
        guard let currentUserParticipationStatus = self.currentUserParticipationStatus else { return false }
        return currentUserParticipationStatus == .pending || currentUserParticipationStatus == .accepted
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
            vc.asOrganizer = false
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
        HelperTracking.track(item: .eventDetails)

        sportLabel.text = event?.sportLocalizedName
        titleLabel.text = event?.title
        statusBar.isHidden = true
        actionBar.isHidden = true
        setUpTableView()
        setUpButtons()
    }
    
    private func setUpTableView() {
        eventTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.bottomContentInset, right: 0)
        eventTableView.register(SectionCell.Constants.nib,
                                forHeaderFooterViewReuseIdentifier: SectionCell.Constants.identifier)
        
        for section in MEventSectionAsParticipant.all {
            eventTableView.register(section.cellNib, forCellReuseIdentifier: section.cellIdentifier)
        }
        eventTableView.dataSource = self
        eventTableView.delegate = self
    }
    
    private func setUpButtons() {
        participateButton.setTitle(L10N.event.details.buttons.participate.uppercased(), for: .normal)
        addGuestButton.setTitle(L10N.event.details.buttons.addGuest.uppercased(), for: .normal)
        declineButton.setTitle(L10N.event.details.buttons.decline.uppercased(), for: .normal)
    }
    
    private func syncEvent() {
        guard let eventId = event?.id, let placeId = event?.placeId else { return }
        
        ServiceGooglePlace.shared.getPlacePhotos(placeId: placeId) { [weak self] (photoUrls) in
            self?.photoUrls = photoUrls
        }
        ServiceEvent.getEventParticipants(eventId: eventId, delegate: self)
        ServiceEvent.getEventGuests(eventId: eventId, delegate: self)
    }
    
    private func updateStatusBarState() {
        guard let event = event,
              let currentUserParticipationStatus = currentUserParticipationStatus else {
            statusBar.isHidden = true
            return
        }
        switch event.eventStatus {
        case .open:
            statusBar.backgroundColor = currentUserParticipationStatus.color
            statusDesc.text = currentUserParticipationStatus.desc
            statusBar.isHidden = false
        case .canceled:
            statusBar.backgroundColor = event.eventStatus.color
            statusDesc.text = event.eventStatus.desc
            statusBar.isHidden = false
        }
    }
    
    private func updateButtonsState() {
        guard let event = event,
              event.eventStatus == .open else {
                  actionBar.isHidden = true
            return
        }
        
        guard currentUserParticipationStatus != .refused else {
            actionBar.isHidden = true
            return
        }
        participateButton.isHidden = currentUserParticipate
        addGuestButton.isHidden = !currentUserParticipate
        declineButton.isHidden = !currentUserParticipate
        actionBar.isHidden = false
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
            let alertController = UIAlertController(title: event.placeName, message: "Go To", preferredStyle: UIAlertController.Style.alert)
            if let url = Constants.url.waze(coordinate: event.location.coordinate), UIApplication.shared.canOpenURL(url) {
                alertController.addAction(UIAlertAction(title: "Waze", style: .default, handler: { (action) in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
            }
            if let url = Constants.url.googleMap(coordinate: event.location.coordinate), UIApplication.shared.canOpenURL(url) {
                alertController.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (action) in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
            }
            if let url = Constants.url.plan, UIApplication.shared.canOpenURL(url) {
                alertController.addAction(UIAlertAction(title: "Plan", style: .default, handler: { (action) in
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
            alertController.addAction(UIAlertAction(title: "Je connais le chemin", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - ServiceEventParticipantDelegate
extension EventDetailsAsParticipantVC: ServiceEventParticipantDelegate  {
    
    func dataAdded(participant: Participant) {
        participants.append(participant)
        guard let userId = ManagerUser.shared.userId,
              participant.userId == userId else {
                  return
        }
        currentUserParticipationStatus = participant.participationStatus
    }
    
    func dataModified(participant: Participant) {
        guard let index = participants.firstIndex(where: { $0.id == participant.id }) else { return }
        participants[index] = participant
        guard let userId = ManagerUser.shared.userId,
              participant.userId == userId else {
                  return
        }
        currentUserParticipationStatus = participant.participationStatus
    }
    
    func dataRemoved(participant: Participant) {
        guard let index = participants.firstIndex(where: { $0.id == participant.id }) else { return }
        participants.remove(at: index)
        
        guard let userId = ManagerUser.shared.userId,
              participant.userId == userId else {
                  return
        }
        currentUserParticipationStatus = nil
    }
    
    func didFinishLoading() {
        guard let userId = ManagerUser.shared.userId else { return }
        let participant = participants.filter({ $0.userId == userId}).first
        currentUserParticipationStatus = participant?.participationStatus
    }
}

// MARK: - ServiceEventGuestDelegate
extension EventDetailsAsParticipantVC: ServiceEventGuestDelegate  {
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
extension EventDetailsAsParticipantVC: UITableViewDataSource {
    
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
        case .organizer, .informations, .place, .placeWithPictures:
            header.setUp(desc: sectionDesc)
        case .participants:
            let desc = String(format: sectionDesc, arguments: [event.nbAcceptedPlayer, event.nbPlayer])
            header.setUp(desc: desc)
        default:
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        sections[indexPath.section].estimatedCellHeight
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .organizer, .informations, .place, .placeWithPictures:
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
        case .organizer:
            guard let organizer = organizer,
                  let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventOrganizerCell else {
                      return UITableViewCell()
                  }
            cell.setUp(organizer: organizer)
            return cell
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
            cell.setUp(name: event.placeName, address: event.placeAddress)
            return cell
        case .placeWithPictures:
            guard let event = event,
                  let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventPlaceWithPicturesCell else {
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
extension EventDetailsAsParticipantVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .organizer:
            guard let userId = organizer?.userId else { return }
            HelperTracking.track(item: .eventDetailsOrganizer)
            ServiceUser.getOtherProfile(userId: userId) { user in
                self.performSegue(withIdentifier: OtherProfileVC.Constants.identifier, sender: user)
            }
        case .informations:
            addEventToCalendar()
        case .place, .placeWithPictures:
            goTo()
        case .participants:
            let userId = participants[indexPath.row].userId
            guard userId != ManagerUser.shared.userId else { return }
            HelperTracking.track(item: .eventDetailsParticipant)
            ServiceUser.getOtherProfile(userId: userId) { user in
                self.performSegue(withIdentifier: OtherProfileVC.Constants.identifier, sender: user)
            }
        case .guests:
            let userId = guests[indexPath.row].associatedUserId
            guard userId != ManagerUser.shared.userId else { return }
            HelperTracking.track(item: .eventDetailsGuest)
            ServiceUser.getOtherProfile(userId: userId) { user in
                self.performSegue(withIdentifier: OtherProfileVC.Constants.identifier, sender: user)
            }
        }
    }
}

// MARK: - EKEventEditViewDelegate
extension EventDetailsAsParticipantVC: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AddGuestVCDelegate
extension EventDetailsAsParticipantVC: AddGuestVCDelegate {
    
    func didAddGuest(guest: Guest) {
        guard let event = self.event,
            let organizer = organizer else {
            return
        }
        ServiceNotification.addGuest(event: event, organizer: organizer)
    }
    
    func didUpdateNbAcceptedPlayerFromAddGuest(nbAcceptedPlayer: Int) {}
}

// MARK: IBAction
extension EventDetailsAsParticipantVC {
    
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
    
    @IBAction func participateToggle(_ sender: Any) {
        guard let event = self.event,
              ManagerUser.shared.user?.nickName != nil,
              let organizer = organizer else {
                  performSegue(withIdentifier: ParticipateVC.Constants.identifier, sender: nil)
                  return
              }
        
        HelperTracking.track(item: .eventDetailsParticipate)
        ServiceEvent.participate(event: event)
        ServiceNotification.participate(event: event, organizer: organizer)
    }
    
    @IBAction func addGuestToggle(_ sender: Any) {
        HelperTracking.track(item: .eventDetailsAddGuest)
        performSegue(withIdentifier: AddGuestVC.Constants.identifier, sender: nil)
    }
    
    @IBAction func declineToggle(_ sender: Any) {
        guard let event = event,
              let eventId = event.id,
              let organizer = organizer else {
            return
        }
        
        HelperTracking.track(item: .eventDetailsDecline)
        ServiceEvent.decline(eventId: eventId)
        let nbAcceptedPlayer = event.nbAcceptedPlayer-1
        self.event?.nbAcceptedPlayer = nbAcceptedPlayer
        ServiceEvent.decreaseNbAcceptedPlayer(eventId: eventId)
        ServiceNotification.decline(event: event, organizer: organizer)
    }
}
