//
//  PalletteTableViewCell.swift
//  Palette
//
//  Created by Jason Mandozzi on 7/16/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PalletteTableViewCell: UITableViewCell {
    
    var photo: UnsplashPhoto? {
        didSet {
            updateViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViews()
        palletteImageView.backgroundColor = .red
        palletteTitleLabel.text = "is this working?"
    }
    
    
    
    func updateViews() {
        guard let photo = photo else {return}
        fetchAndSetImage(for: photo)
        fetchAndSetColors(for: photo)
        palletteTitleLabel.text = photo.description
        
    }
    
    func fetchAndSetImage(for photo: UnsplashPhoto) {
        UnsplashService.shared.fetchImage(for: photo) { (image) in
            DispatchQueue.main.async {
                self.palletteImageView.image = image
            }
        }
    }
    
    func fetchAndSetColors(for photo: UnsplashPhoto) {
        ImaggaService.shared.fetchColorsFor(imagePath: photo.urls.regular) { (colors) in
            DispatchQueue.main.async {
                guard let colors = colors else {return}
                self.colorPalletteView.colors = colors
            }
        }
    }
    
    //Step three
    func setUpViews() {
        addAllSubViews()
        let imageWidth = (contentView.frame.width - (SpacingConstants.outerHorizontalPadding * 2))
        palletteImageView.anchor(top: contentView.topAnchor,
                                 bottom: nil,
                                 leading: contentView.leadingAnchor,
                                 trailing: contentView.trailingAnchor,
                                 topPadding: SpacingConstants.outerVerticalPadding,
                                 bottomPadding: 0,
                                 leadingPadding: SpacingConstants.outerHorizontalPadding,
                                 trailingPadding: -SpacingConstants.outerHorizontalPadding,
                                 width: imageWidth,
                                 height: imageWidth)
        
        palletteTitleLabel.anchor(top: palletteImageView.bottomAnchor,
                                  bottom: nil, leading: contentView.leadingAnchor,
                                  trailing: contentView.trailingAnchor,
                                  topPadding: SpacingConstants.verticalObjectBuffer,
                                  bottomPadding: 0,
                                  leadingPadding: SpacingConstants.outerHorizontalPadding,
                                  trailingPadding: -SpacingConstants.outerHorizontalPadding,
                                  width: nil,
                                  height: SpacingConstants.oneLineElementHeight)
        
        colorPalletteView.anchor(top: palletteTitleLabel.bottomAnchor,
                                 bottom: contentView.bottomAnchor,
                                 leading: contentView.leadingAnchor,
                                 trailing: contentView.trailingAnchor,
                                 topPadding: SpacingConstants.verticalObjectBuffer,
                                 bottomPadding: SpacingConstants.outerVerticalPadding,
                                 leadingPadding: SpacingConstants.outerHorizontalPadding,
                                 trailingPadding: -SpacingConstants.outerHorizontalPadding,
                                 width: nil,
                                 height: SpacingConstants.twoLineElementHeight)
        colorPalletteView.clipsToBounds = true
        colorPalletteView.layer.cornerRadius = (SpacingConstants.twoLineElementHeight / 2)
    }
    
    
    func addAllSubViews() {
        self.addSubview(palletteImageView)
        self.addSubview(palletteTitleLabel)
        self.addSubview(colorPalletteView)
    }
    
    //MARK: - subviews
    lazy var palletteImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = (contentView.frame.height / 20)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    
    lazy var palletteTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var colorPalletteView: ColorPalletteView = {
        let palletteView = ColorPalletteView()
        
        return palletteView
    }()
}
