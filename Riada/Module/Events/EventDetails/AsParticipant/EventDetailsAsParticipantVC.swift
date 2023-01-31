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
    @IBOutlet weak private var coverImage: UIImageView!
    @IBOutlet weak private var sportLabel: UILabel!
    @IBOutlet weak private var radiusBar: UIView!
    @IBOutlet weak private var eventTableView: UITableView!
    @IBOutlet weak private var actionBar: UIView!
    @IBOutlet weak private var statusLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var joinButton: MButton!
    @IBOutlet weak private var unjoinButton: MButton!
    
    //MARK: - Properties
    private var sections: [MEventSectionAsParticipant] = [
        .title,
        .desc,
        .dateAndHour,
        .place,
        .organizer,
        .team
    ]

    var event: Event?
    var photoUrls: [URL] = [] {
        didSet {
            if photoUrls.isEmpty {
                self.sections = [
                    .title,
                    .desc,
                    .dateAndHour,
                    .place,
                    .organizer,
                    .team
                ]
            } else {
                self.sections = [
                    .title,
                    .desc,
                    .dateAndHour,
                    .placeWithPictures,
                    .organizer,
                    .team
                ]
            }
            if currentUserCanAddGuest {
                self.sections.append(.myGuests)
            }
            guard let section = sections.firstIndex(where: { $0 == .place || $0 == .placeWithPictures }) else { return }
            DispatchQueue.main.async {
                self.eventTableView.reloadSections(IndexSet(integer: section), with: .automatic)
            }
        }
    }
    var organizer: Organizer?
    var participants: [Participant] = [] {
        didSet {
            DispatchQueue.main.async {
                self.eventTableView.reloadData()
            }
        }
    }
    var guests: [Guest] = [] {
        didSet {
            DispatchQueue.main.async {
                self.eventTableView.reloadData()
            }
        }
    }
    var myGuests: [Guest] {
        guard let userId = ManagerUser.shared.userId else { return [] }
        return guests.filter({$0.associatedUserId == userId && $0.teamId == nil})
    }
    var teams: [Team] = [] {
        didSet {
            DispatchQueue.main.async {
                self.eventTableView.reloadData()
            }
        }
    }
    var currentUserParticipationStatus: ParticipationStatus? = nil {
        didSet {
            updateStatusBarState()
            updateActionBar()
            if currentUserCanAddGuest, !sections.contains(.myGuests) {
                sections.append(.myGuests)
            }
        }
    }
    var currentUserParticipate: Bool {
        guard let currentUserParticipationStatus = self.currentUserParticipationStatus else { return false }
        return currentUserParticipationStatus == .accepted || currentUserParticipationStatus == .pending
    }

    var currentUserCanAddGuest: Bool {
        guard let currentUserParticipationStatus = self.currentUserParticipationStatus else { return false }
        return currentUserParticipationStatus == .accepted
    }
    
    //MARK: - LifeCycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

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
        } else if segue.identifier == PhotoVC.Constants.identifier {
            guard let vc = segue.destination as? PhotoVC,
                  let photoUrl = sender as? URL else {
                      return
                  }
            vc.photoUrl = photoUrl
        }
    }
}

//MARK: - Privates
private extension EventDetailsAsParticipantVC {

    func setUpView() {
        HelperTracking.track(item: .eventDetails)

        setUpTableView()
        setUpActionBar()
        setUpRadiusBar()

        updateSport()
        updateCover()
        updatePriceIfNeeded()
    }

    func setUpTableView() {
        eventTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.bottomContentInset, right: 0)

        for section in MEventSectionAsParticipant.all {
            eventTableView.register(section.cellNib, forCellReuseIdentifier: section.cellIdentifier)
        }
        eventTableView.dataSource = self
        eventTableView.delegate = self
    }

    func setUpActionBar() {
        actionBar.isHidden = true
        actionBar.layer.shadowColor = UIColor.mDark.cgColor
        actionBar.layer.shadowOpacity = 0.2
        actionBar.layer.shadowOffset = .zero
        statusLabel.isHidden = true
        joinButton.setTitle(L10N.event.details.buttons.join.uppercased(), for: .normal)
        unjoinButton.setTitle(L10N.event.details.buttons.unJoin.uppercased(), for: .normal)
        unjoinButton.setTitle(L10N.event.details.buttons.unJoin.uppercased(), for: .normal)
        unjoinButton.layer.borderWidth = 1
        unjoinButton.layer.borderColor = UIColor.mDark.cgColor
    }

    func setUpRadiusBar() {
        radiusBar.clipsToBounds = true
        radiusBar.layer.cornerRadius = 24
        radiusBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    func syncEvent() {
        guard let eventId = event?.id, let placeId = event?.placeId else { return }

        ServiceGooglePlace.shared.getPlacePhotos(placeId: placeId) { [weak self] (photoUrls) in
            self?.photoUrls = photoUrls
        }
        ServiceEvent.getEventParticipants(eventId: eventId, delegate: self)
        ServiceEvent.getEventGuests(eventId: eventId, delegate: self)
        ServiceEvent.getEventTeam(eventId: eventId, delegate: self)
    }

    func updateSport() {
        guard let event = event else { return }
        sportLabel.text = "\(event.sportEmoticon) \(event.sportLocalizedName)"
    }

    func updateCover() {
        guard let event = event else { return }

        if let cover = event.cover, let url = URL(string: cover) {
            coverImage.sd_setImage(with: url)
        } else {
            let sport = ManagerSport.shared.sports.first(where: {$0.id == event.sportId})
            if let cover = sport?.covers.first, let url = URL(string: cover) {
                coverImage.sd_setImage(with: url)
            }
        }
    }

    func updatePriceIfNeeded() {
        guard let event = event,
              let price = event.price,
              let priceCurrency = event.priceCurrency else {
                  priceLabel.isHidden = true
            return
        }
        priceLabel.isHidden = false

        let fullDescription = priceCurrency + " " + price

        let currencyFont = UIFont(name: "Lato-Bold", size: 10.0)!
        let priceFont = UIFont(name: "Lato-Bold", size: 16.0)!

        let attributedText = NSMutableAttributedString(string: fullDescription,
                                                        attributes: [NSAttributedString.Key.font: priceFont])
        attributedText.addAttribute(NSAttributedString.Key.font,
                                      value: currencyFont,
                                      range: NSRange(location: 0, length: priceCurrency.count))
        priceLabel.attributedText = attributedText
    }

    func updateStatusBarState() {
        guard let event = event,
              let currentUserParticipationStatus = currentUserParticipationStatus else {
            statusLabel.isHidden = true
            return
        }
        switch event.eventStatus {
        case .open:
            statusLabel.textColor = currentUserParticipationStatus.color
            statusLabel.text = currentUserParticipationStatus.desc
            statusLabel.isHidden = false
        case .canceled:
            statusLabel.textColor = event.eventStatus.color
            statusLabel.text = event.eventStatus.desc
            statusLabel.isHidden = false
        }
    }

    func updateActionBar() {
        guard let event = event,
              event.eventStatus == .open else {
                  actionBar.isHidden = true
            return
        }

        guard currentUserParticipationStatus != .refused else {
            actionBar.isHidden = true
            return
        }


        joinButton.isHidden = currentUserParticipate
        unjoinButton.isHidden = !currentUserParticipate
        actionBar.isHidden = false
    }

    func addEventToCalendar() {
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

// MARK: - ServiceEventTeamDelegate
extension EventDetailsAsParticipantVC: ServiceEventTeamDelegate  {
    func dataAdded(team: Team) {
        teams.append(team)
    }

    func dataModified(team: Team) {
        guard let index = teams.firstIndex(where: { $0.id == team.id }) else { return }
        teams[index] = team
    }

    func dataRemoved(team: Team) {
        guard let index = teams.firstIndex(where: { $0.id == team.id }) else { return }
        teams.remove(at: index)
    }
}


// MARK: - UITableViewDataSource
extension EventDetailsAsParticipantVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        sections[indexPath.section].estimatedCellHeight
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .title, .desc, .dateAndHour, .place, .placeWithPictures, .organizer, .team, .myGuests:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .title:
            guard let event = event,
                  let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventTitleCell else {
                      return UITableViewCell()
                  }
            cell.setUp(title: event.title)
            return cell
        case .desc:
            guard let event = event,
                  let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventDescriptionCell else {
                      return UITableViewCell()
                  }
            cell.setUp(desc: event.description)
            return cell
        case .dateAndHour:
            guard let event = event,
                  let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventDateAndHourCell else {
                      return UITableViewCell()
                  }
            cell.setUp(date: event.date)
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
            cell.delegate = self
            cell.setUp(name: event.placeName, address: event.placeAddress, photos: photoUrls)
            return cell
        case .organizer:
            guard let organizer = organizer,
                  let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventOrganizerCell else {
                      return UITableViewCell()
                  }
            cell.setUp(organizer: organizer)
            return cell
        case .team:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventTeamsCell else {
                      return UITableViewCell()
                  }
            cell.setUp(teams: teams, participants: participants, guests: guests)
            return cell
        case .myGuests:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? EventMyGuestsCell else {
                      return UITableViewCell()
                  }
            cell.delegate = self
            cell.setUp(guests: myGuests)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension EventDetailsAsParticipantVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .title, .desc:
            break
        case .dateAndHour:
            addEventToCalendar()
        case .place, .placeWithPictures:
            goTo()
        case .organizer:
            guard let userId = organizer?.userId else { return }
            HelperTracking.track(item: .eventDetailsOrganizer)
            ServiceUser.getOtherProfile(userId: userId) { user in
                self.performSegue(withIdentifier: OtherProfileVC.Constants.identifier, sender: user)
            }
        case .team, .myGuests:
            break
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
}

// MARK: - EventPlaceWithPicturesCellDelegate
extension EventDetailsAsParticipantVC: EventPlaceWithPicturesCellDelegate {
    
    func didTogglePicture(photoUrl: URL) {
        performSegue(withIdentifier: PhotoVC.Constants.identifier, sender: photoUrl)
    }
}

// MARK: - EventMyGuestsCellDelegate
extension EventDetailsAsParticipantVC: EventMyGuestsCellDelegate {

    func didToggleAddGuest() {
        HelperTracking.track(item: .eventDetailsAddGuest)
        performSegue(withIdentifier: AddGuestVC.Constants.identifier, sender: nil)
    }

    func didToggleGuest(guest: Guest) {
        // TODO: ask if user want to decline guest
    }
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
    
    @IBAction func joinToggle(_ sender: Any) {
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

    @IBAction func unjoinToggle(_ sender: Any) {
        guard let event = event,
              let eventId = event.id,
              let organizer = organizer else {
            return
        }
        
        HelperTracking.track(item: .eventDetailsDecline)
        ServiceEvent.decline(eventId: eventId)
        ServiceNotification.decline(event: event, organizer: organizer)        
    }
}
