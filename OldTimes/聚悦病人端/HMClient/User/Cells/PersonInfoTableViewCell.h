//
//  PersonInfoTableViewCell.h
//  HMClient
//
//  Created by lkl on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInfoTableViewCell : UITableViewCell

- (void)setlbTitle:(NSString*)aTitle;
- (void) setUserInfo:(NSString*)userInfo;

@end

@interface PersonInfoEidtTableViewCell : PersonInfoTableViewCell


@end

@interface PersonHeaderInfoTableViewCell : UITableViewCell

- (void) updateUserInfo;

@end
