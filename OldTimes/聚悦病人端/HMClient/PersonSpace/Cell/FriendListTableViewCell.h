//
//  FriendListTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfo.h"

@protocol FriendListTableViewCellDelegate <NSObject>

- (void) friendDeleteRelativeButtonClicked:(UITableViewCell*) cell;

@end

@interface FriendListTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, weak) id<FriendListTableViewCellDelegate> delegate;

- (void) setFriendInfo:(FriendInfo*) friend;
@end
