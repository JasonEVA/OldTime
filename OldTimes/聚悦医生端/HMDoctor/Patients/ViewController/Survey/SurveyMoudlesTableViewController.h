//
//  SurveyMoudlesTableViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurveyMoudlesTableViewController : UITableViewController
{
    NSInteger surveyType;
}
@property (nonatomic, readonly) NSMutableArray* selectedMoudles;

- (id) initWithSurveyType:(NSInteger) type;
@end


@interface SurveyMoudlesStartViewController : HMBasePageViewController
{
    SurveyMoudlesTableViewController* tvcSurveyMoudles;
}
@end


@interface InterrogationMoudlesStartViewController : SurveyMoudlesStartViewController

@end
