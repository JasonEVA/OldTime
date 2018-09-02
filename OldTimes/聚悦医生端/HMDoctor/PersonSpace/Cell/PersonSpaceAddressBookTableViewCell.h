//
//  PersonSpaceAddressBookTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookInfo.h"

@interface PersonSpaceAddressBookTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton* homeTelBtn;
- (void)setAddressBookInfo:(AddressBookInfo *)info;

@end
