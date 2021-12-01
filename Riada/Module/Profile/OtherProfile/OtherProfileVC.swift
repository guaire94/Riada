//
//  EventDetailsVC.swift
//  Riada
//
//  Created by Guaire94 on 18/09/2021.
//

import UIKit
import Firebase

class OtherProfileVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier: String = "OtherProfileVC"
        fileprivate static let bottomContentInset: CGFloat = 8.0
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak private var nickNameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet weak private var segmentControl: CustomSegmentedControl!
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties
    var user: User?
    private var sections = MOtherProfileSection.toDisplay()
    private var currentSection = MOtherProfileSection.organizer {
        didSet {
            events = []
            syncEventsIfNeeded()
        }
    }
    private var events: [RelatedEvent] = [] {
        didSet {
            sortEventByDate()
        }
    }

    private var eventsByDate: [(date: Date, events: [RelatedEvent])] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        syncEventsIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EventDetailsAsParticipantVC.Constants.identifier {
            guard let vc = segue.destination as? EventDetailsAsParticipantVC,
                  let tuple = sender as? (event: Event, organizer: Organizer) else {
                return
            }
            vc.event = tuple.event
            vc.organizer = tuple.organizer
        } else if segue.identifier == EventDetailsAsOrganizerVC.Constants.identifier {
            guard let vc = segue.destination as? EventDetailsAsOrganizerVC,
                  let event = sender as? Event else {
                return
            }
            vc.event = event
        }
    }
        
    //MARK: - Privates
    private func setUpView() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
        avatarImageView.clipsToBounds = true
        setUpUserInformation()
        setUpSegmentControl()
        setUpTableView()
    }
    
    private func setUpUserInformation() {
        guard let user = self.user else { return }
        
        nickNameLabel.text = user.nickName
        if let userAvatar = user.avatar, let url = URL(string: userAvatar) {
            avatarImageView.sd_setImage(with: url)
        } else {
            avatarImageView.image = #imageLiteral(resourceName: "avatar")
        }
    }
    
    private func setUpSegmentControl() {
        segmentControl.delegate = self
        segmentControl.setButtonTitles(buttonTitles: sections.map({ $0.title }))
     }
    
    private func setUpTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.bottomContentInset, right: 0)
        tableView.register(SectionCell.Constants.nib,
                                forHeaderFooterViewReuseIdentifier: SectionCell.Constants.identifier)
        
        for section in sections {
            tableView.register(section.cellNib, forCellReuseIdentifier: section.cellIdentifier)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func syncEventsIfNeeded() {
        guard let userId = user?.id else { return }
        switch currentSection {
        case .organizer:
            ServiceUser.getOtherProfileOrganizeEvents(userId: userId, delegate: self)
        case .participate:
            ServiceUser.getOtherProfileParticipateEvents(userId: userId, delegate: self)
        }
    }
    
    private func shareEvent(event: Event) {
        HelperDynamicLink.generateEventDetails(event: event, completion: { url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                let activityViewController = UIActivityViewController(activityItems : [url], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                self.present(activityViewController, animated: true, completion: nil)
            }
        })
    }
    
    private func sortEventByDate() {
        var sortedEvent: [(date: Date, events: [RelatedEvent])] = []
        let dict = Dictionary(grouping: events, by: { $0.date })
        let sortedKeys = Array(dict.keys).sorted(by: { $0.compare($1) == .orderedAscending })
        
        for key in sortedKeys {
            if let events = dict[key] {
                sortedEvent.append((date: key.dateValue(), events: events))
            }
        }
        self.eventsByDate = sortedEvent
    }
}

// MARK: - IBAction
extension OtherProfileVC: ServiceUserEventsDelegate  {
    func dataAdded(event: RelatedEvent) {
        events.append(event)
    }
    
    func dataModified(event: RelatedEvent) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events[index] = event
    }
    
    func dataRemoved(event: RelatedEvent) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events.remove(at: index)
    }
    
    func didFinishLoading() {}
}

// MARK: - CustomSegmentedControlDelegate
extension OtherProfileVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        guard let section = MOtherProfileSection(rawValue: index) else { return }
        currentSection = section
    }
}

// MARK: - UITableViewDataSource
extension OtherProfileVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentSection {
        case .organizer:
            if eventsByDate.isEmpty {
                tableView.setEmptyMessage(L10N.otherProfile.organizerEmptyPlaceHolder)
            } else {
                tableView.restore()
            }
            return eventsByDate.count
        case .participate:
            if eventsByDate.isEmpty {
                tableView.setEmptyMessage(L10N.otherProfile.participateEmptyPlaceHolder)
            } else {
                tableView.restore()
            }
            return eventsByDate.count
        }
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        currentSection.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionCell.Constants.identifier) as? SectionCell else { return nil }
        header.setUp(desc: eventsByDate[section].date.long)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventsByDate[section].events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        currentSection.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: currentSection.cellIdentifier, for: indexPath) as? RelatedEventCell else {
            return UITableViewCell()
        }
        let event = eventsByDate[indexPath.section].events[indexPath.row]
        cell.setUp(event: event, isOrganizer: currentSection == .organizer)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OtherProfileVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentSection {
        case .organizer:
            let relatedEvent = eventsByDate[indexPath.section].events[indexPath.row]
            guard let eventId = relatedEvent.id, let organizer = user?.toOrganizer else { return }
            HelperTracking.track(item: .otherProfileOrganizerEventDetails)
            ServiceEvent.getEventDetails(eventId: eventId) { event in
                guard let event = event else { return }
                DispatchQueue.main.async {
                    let tuple = (event: event, organizer: organizer)
                    self.performSegue(withIdentifier: EventDetailsAsParticipantVC.Constants.identifier, sender: tuple)
                }
            }
        case .participate:
            let relatedEvent = eventsByDate[indexPath.section].events[indexPath.row]
            guard let cell = tableView.cellForRow(at: indexPath) as? RelatedEventCell,
                  let eventId = relatedEvent.id,
                  let organizer = cell.organizer else {
                      return
            }
            HelperTracking.track(item: .otherProfileParticipateEventDetails)
            ServiceEvent.getEventDetails(eventId: eventId) { event in
                guard let event = event else { return }
                DispatchQueue.main.async {
                    if organizer.userId == ManagerUser.shared.user?.id {
                        self.performSegue(withIdentifier: EventDetailsAsOrganizerVC.Constants.identifier, sender: event)
                    } else {
                        let tuple = (event: event, organizer: organizer)
                        self.performSegue(withIdentifier: EventDetailsAsParticipantVC.Constants.identifier, sender: tuple)
                    }
                }
            }
        }
    }
}

// MARK: IBAction
private extension OtherProfileVC {
    
    @IBAction func backToggle(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}




