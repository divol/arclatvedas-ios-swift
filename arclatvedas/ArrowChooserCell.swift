//
//  ArrowChooserCell.swift
//  arclatvedas
//
//  Created by divol on 18/06/2015.
//  Copyright (c) 2015 jack. All rights reserved.
//

import UIKit

import CoreData
import CoreDataProxy

class ArrowChooserCell: UITableViewCell {
    @IBOutlet weak var texte: UITextView!
    
    var arrow:SpinFleche?{
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    func configureView() {
        if let fleche = arrow {
        
            if let detail = self.texte {
                //    NSLog(fleche.grain.description)
                var lataille = "-\n"
                
                // fleche.taille is non-optional NSNumber, compare its numeric value
                if fleche.taille.intValue != 0 {
                    lataille = "\(fleche.taille)\n"
                }
                
                let modelstr = NSLocalizedString("Modele: ", comment:"data")
                let nomstr = NSLocalizedString("nom: ", comment:"data")
                let grainstr = NSLocalizedString("Grain: ", comment:"data")
                let spinstr = NSLocalizedString("Spin: ", comment:"data")
                let taillestr = NSLocalizedString("Taille: ", comment:"data")
                let makerstr = NSLocalizedString("Fabricant: ", comment:"data")
                
                // Build the string with standard interpolation/concatenation
                detail.text =
                    "\(modelstr)\(fleche.modele)\n" +
                    "\(nomstr)\(fleche.name)\n" +
                    "\(grainstr)\(fleche.grain) " +
                    "\(spinstr)\(fleche.spin) " +
                    "\(taillestr)\(lataille)" +
                    "\(makerstr)\(fleche.fabricant)\n"
            }
        }
        
    }

    
//    @NSManaged public var modele: String
//    @NSManaged public var name: String
//    @NSManaged public var surname: String
//    @NSManaged public var grain: NSNumber
//    @NSManaged public var spin: String
//    @NSManaged public var diametreoutside: NSNumber
//    @NSManaged public var taille: NSNumber
//    @NSManaged public var fabricant: String
//    @NSManaged public var groupsofarrow: NSMutableOrderedSet

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
