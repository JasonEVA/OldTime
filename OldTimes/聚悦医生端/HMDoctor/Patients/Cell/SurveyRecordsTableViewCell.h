//
//  SurveyRecordsTableViewCell.h
//  HMClient
//
//  Created by lkl on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyRecord.h"

@interface SurveyRecordsTableViewCell : UITableViewCell

- (void)setSurveyRecord:(SurveyRecord *)record;

@end

@interface SurveryMoudleTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UIButton* previewButton;
- (void) setMoudleName:(NSString*) name;
- (void) setIsSelected:(BOOL) selected;
@end
