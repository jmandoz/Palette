//
//  PalletteListViewController.swift
//  Palette
//
//  Created by Jason Mandozzi on 7/16/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

//Programatic Constraints has a 3 part process
// 1- Declare the view
// 2- Add our subviews
// 3- Constrain our views
import UIKit

class PalletteListViewController: UIViewController {
    
    var photos: [UnsplashPhoto] = []
    
    var buttons: [UIButton] {
        return [randomButton, featuredButton, doubleRainbow]
    }
    
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    override func loadView() {
        super.loadView()
        addAllSubViews()
        setUpStackView()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTableView()
        activateButtons()
        searchforCategory(.featured)
        selectButton(featuredButton)
    }
    
    func searchforCategory(_ route: UnsplashRoute) {
        UnsplashService.shared.fetchFromUnsplash(for: route) { (photos) in
            DispatchQueue.main.async {
                guard let photos = photos else {return}
                self.photos = photos
                self.palletteTableView.reloadData()
            }
        }
    }
    
    //part 2 - adding the subviews
    func addAllSubViews() {
        self.view.addSubview(featuredButton)
        self.view.addSubview(randomButton)
        self.view.addSubview(doubleRainbow)
        self.view.addSubview(buttonStackView)
        self.view.addSubview(palletteTableView)
    }
    
    func setUpStackView() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(featuredButton)
        buttonStackView.addArrangedSubview(randomButton)
        buttonStackView.addArrangedSubview(doubleRainbow)
        buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: (self.view.frame.maxX/20)).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -(self.view.frame.maxX/20)).isActive = true
    }
    
    func configureTableView() {
        palletteTableView.delegate = self
        palletteTableView.dataSource = self
        palletteTableView.register(PalletteTableViewCell.self, forCellReuseIdentifier: "palletteCell")
        palletteTableView.allowsSelection = false
    }
    
    func constrainViews() {
        
        buttonStackView.anchor(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: (self.view.frame.maxX/20), trailingPadding: -(self.view.frame.maxX/20))
        palletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, topPadding: (buttonStackView.frame.height / 2), bottomPadding: 0, leadingPadding: 0, trailingPadding: 0)
    }
    
    //action
    func activateButtons() {
        buttons.forEach{ $0.addTarget(self, action: #selector(searchButtonTapped(sender:)), for: .touchUpInside) }
    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        selectButton(sender)
        switch sender {
        case featuredButton:
            searchforCategory(.featured)
        case randomButton:
            searchforCategory(.random)
        case doubleRainbow:
            searchforCategory(.doubleRainbow)
        default:
            print("Error, button not found")
        }
    }
    
    func selectButton(_ button: UIButton) {
        buttons.forEach({$0.setTitleColor(UIColor.lightGray, for: .normal)})
        button.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }
    
    //MARK: - Views
    let featuredButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Featured", for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Random", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let doubleRainbow: UIButton = {
        let button = UIButton()
        button.setTitle("Rainbow", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    let palletteTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
}

//MARK: - TableView DataSource Methods

extension PalletteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let titleLabelSpace: CGFloat = SpacingConstants.oneLineElementHeight
        let outerVerticalSpacing: CGFloat = (2 * SpacingConstants.outerVerticalPadding)
        let verticalPadding: CGFloat = (3 * SpacingConstants.verticalObjectBuffer)
        
        return imageViewSpace + titleLabelSpace + outerVerticalSpacing + verticalPadding
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "palletteCell", for: indexPath) as! PalletteTableViewCell
        
        let photo = photos[indexPath.row]
        cell.photo = photo
        
        return cell
    }
}
