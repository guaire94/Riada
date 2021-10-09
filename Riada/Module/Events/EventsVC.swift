//
//  Events.swift
//  Riada
//
//  Created by Guaire94 on 16/09/2021.
//

import UIKit

class EventsVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "EventsVC"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var sportLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var eventsTableView: UITableView!
    @IBOutlet weak private var loaderView: UIView!

    // MARK: - Properties
    var sport: Sport?
    private var events: [Event] = [] {
        didSet {
            sortEventByDate()
        }
    }

    private var eventsByDate: [(date: Date, events: [Event])] = [] {
        didSet {
            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        syncEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EventDetailsAsParticipantVC.Constants.identifier {
            guard let vc = segue.destination as? EventDetailsAsParticipantVC,
                  let eventCell = sender as? EventCell else {
                return
            }
            vc.event = eventCell.event
            vc.organizer = eventCell.organizer
        }
    }
    
    // MARK: - Privates
    private func setupView() {
        guard let sport = sport else { return }
        sportLabel.text = sport.localizedName
        cityLabel.text = ManagerUser.shared.currentCity.name
        
        setupTableView()
    }

    private func setupTableView() {
        eventsTableView.register(EventCell.Constants.nib,
                           forCellReuseIdentifier: EventCell.Constants.identifier)
        eventsTableView.register(SectionCell.Constants.nib,
                           forHeaderFooterViewReuseIdentifier: SectionCell.Constants.identifier)
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
    }
    
    private func syncEvents() {
        guard let sportId = sport?.id else { return }
        loaderView.isHidden = false
        ServiceEvent.getNextEvents(sportId: sportId, delegate: self)
    }
    
    private func sortEventByDate() {
        var sortedEvent: [(date: Date, events: [Event])] = []
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
extension EventsVC: ServiceNextEventDelegate  {
    func dataAdded(event: Event) {
        events.append(event)
    }
    
    func dataModified(event: Event) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events[index] = event
    }
    
    func dataRemoved(event: Event) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }
        events.remove(at: index)
    }
    
    func didFinishLoading() {
        loaderView.isHidden = true
    }
}

// MARK: - IBAction
private extension EventsVC {

    @IBAction func backToggle(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func organizeEventToggle(_ sender: Any) {
        // TODO: Reidrect to organize event
    }
}


// MARK: - UITableViewDataSource
extension EventsVC: UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        if eventsByDate.isEmpty {
            tableView.setEmptyMessage(L10N.event.emptyPlaceHolder)
        } else {
            tableView.restore()
        }
        return eventsByDate.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        SectionCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionCell.Constants.identifier) as? SectionCell else { return UITableViewHeaderFooterView() }
        header.setUp(desc: eventsByDate[section].date.long)
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventsByDate[section].events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        EventCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: EventCell.Constants.identifier, for: indexPath)
        guard let cell = reusableCell as? EventCell else {
            return UITableViewCell()
        }
        let event = eventsByDate[indexPath.section].events[indexPath.row]
        cell.setUp(event: event)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EventsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = eventsTableView.cellForRow(at: indexPath) as? EventCell else { return }
        performSegue(withIdentifier: EventDetailsAsParticipantVC.Constants.identifier, sender: cell)
    }
}
