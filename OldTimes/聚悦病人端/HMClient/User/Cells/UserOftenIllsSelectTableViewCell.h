//
//  UserOftenIllsSelectTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/7/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserOftenIllInfo.h"

@interface UserOftenIllsSelectTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, assign) BOOL isSelected;

- (void) setOftenIll:(UserOftenIllInfo*) ill;
@end
