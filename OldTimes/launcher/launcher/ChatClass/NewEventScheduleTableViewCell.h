//
//  NewEventScheduleTableViewCell.h
//  launcher
//
//  Created by 马晓波 on 16/3/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>

@protocol NewEventScheduleTableViewCellDelegate <NSObject>

- (void)ChatEventScheduleTableViewCellDelegateCallBack_btnAttendClicked:(BOOL)isAttend ShowId:(NSString *)showId;

@end

@interface NewEventScheduleTableViewCell : UITableViewCell

+ (CGFloat)heightForModel:(MessageBaseModel *)model;

@property (nonatomic, weak) id<NewEventScheduleTableViewCellDelegate> delegate;
@property (nonatomic) CGFloat rowHight;

- (void)setCellData:(MessageBaseModel *)model;
- (void)setCellDataWithSystem:(MessageBaseModel *)model;
@end
