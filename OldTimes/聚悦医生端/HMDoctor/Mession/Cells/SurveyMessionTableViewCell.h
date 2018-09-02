//
//  SurveyMessionTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyRecord.h"

@interface SurveyMessionTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, readonly) UIButton* archiveButton;
@property (nonatomic, readonly) UIButton* replyButton;
- (void) setSurveyRecord:(SurveyRecord*) record;
@end
