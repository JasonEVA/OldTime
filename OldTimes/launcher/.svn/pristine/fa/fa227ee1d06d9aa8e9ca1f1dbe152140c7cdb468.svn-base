//
//  NewMissionDetailTitelTableViewCell.h
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMissionDetailModel.h"

@protocol NewMissionDetailTitelTableViewCellDelegate <NSObject>

- (void)NewMissionDetailTitelTableViewCellDelegateCallBack_statusChange;

@end

@interface NewMissionDetailTitelTableViewCell : UITableViewCell
+ (NSString *)identifier;
@property (nonatomic, weak) id <NewMissionDetailTitelTableViewCellDelegate> delegate;
- (void)setDataWithModel:(NewMissionDetailModel *)model;

@end
