//
//  MainStartServiceTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainStartServiceTableViewCellDelegate <NSObject>

- (void)MainStartServiceTableViewCellDelegateCallBack_askDoctorClick;

@end

@interface MainStartServiceTableViewCell : UITableViewCell
@property (nonatomic, weak) id<MainStartServiceTableViewCellDelegate> delegate;
@end
