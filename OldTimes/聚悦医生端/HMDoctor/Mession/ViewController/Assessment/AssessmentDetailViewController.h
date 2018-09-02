//
//  AssessmentDetailViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "AssessmentMessionModel.h"
@interface AssessmentDetailViewController : HMBasePageViewController
{
    
}

@property (nonatomic, readonly) UIWebView* webview;
@property (nonatomic, readonly) AssessmentRecordModel* assessmentRecord;
@end

//阶段评估详情
@interface AssessmentSummaryViewController : AssessmentDetailViewController

@end

