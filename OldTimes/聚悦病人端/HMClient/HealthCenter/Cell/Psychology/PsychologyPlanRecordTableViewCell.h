//
//  PsychologyPlanRecordTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/6/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPsychologyDetail.h"


@protocol PsychologyPlanRecordDelegate <NSObject>

- (void) selectedPsychology:(NSInteger) moodType;

@end

@interface PsychologyPlanRecordTableViewCell : UITableViewCell

@property (nonatomic, weak) id<PsychologyPlanRecordDelegate> delegate;

- (void) setPsychologInfo:(UserPsychologyInfo*) info;
@end

@interface PsychologyPlanReaderTableViewCell : UITableViewCell
{
    
}
- (void) setTitle:(NSString *)title
          Content:(NSString*) content;
@end
