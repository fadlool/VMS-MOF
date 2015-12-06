//
//  SideMenuItem.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit


class SideMenuItem {
    
    let order:Int
    let title: String
    let image: UIImage?
    
    init(order:Int, title: String, image: UIImage?) {
        self.order = order
        self.title = title
        self.image = image
    }
    
    class func sideMenuList() -> Array<SideMenuItem> {
        return [ SideMenuItem(order:Common.MenuProfileOrder, title: "my_profile".localized,image: UIImage(named: "MenuProfile")),
        SideMenuItem(order:Common.MenuIdentityReqOrder,title: "request".localized,image: UIImage(named: "MenuReq")),
            SideMenuItem(order:Common.MenuSelfVacationOrder,title: "self_vacation".localized,image: UIImage(named: "MenuSelfVacation")),
            SideMenuItem(order:Common.MenuMedicalReqOrder,title: "medic_req".localized,image: UIImage(named: "MenuMedicalReq")),
            SideMenuItem(order:Common.MenuDelegateOrder,title: "delegate_req".localized,image: UIImage(named: "MenuDelegateReq")),
            SideMenuItem(order:Common.MenuLogoutOrder,title: "logout".localized,image: UIImage(named: "MenuLogout"))
            
        ]
    }
    
 
}