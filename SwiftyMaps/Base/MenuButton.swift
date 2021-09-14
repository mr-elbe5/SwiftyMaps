//
// Created by Michael Rönnau on 14.09.21.
//

import Foundation
import UIKit

class MenuButton : UIButton{

    public init(icon: String){
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon), for: .normal)
        tintColor = .white
        setTitleColor(.white, for: .normal)
        self.scaleBy(1.25)
    }

    public init(icon: String, menu: UIMenu){
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon), for: .normal)
        tintColor = .white
        setTitleColor(.white, for: .normal)
        self.menu = menu
        showsMenuAsPrimaryAction = true
        self.scaleBy(1.25)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuItemButton : UIButton{

    public init(text: String, icon: String? = nil){
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        if let icon = icon{
            setImage(UIImage(systemName: icon), for: .normal)
        }
        tintColor = .white
        setTitleColor(.white, for: .normal)
        self.scaleBy(1.25)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}