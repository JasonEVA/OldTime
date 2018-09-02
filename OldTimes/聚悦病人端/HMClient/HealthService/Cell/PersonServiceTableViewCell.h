//
//  PersonServiceTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/7/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserServiceInfo.h"

@interface UserServiceInfo (PersonServiceCellHeight)

- (CGFloat) tableCellHeight;
@end

@interface PersonServiceTableViewCell : UITableViewCell
{
    
}

- (void) setUserService:(UserServiceInfo*) userService;
@end
