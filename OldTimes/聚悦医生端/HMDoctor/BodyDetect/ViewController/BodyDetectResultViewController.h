//
//  BodyDetectResultViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "DetectRecord.h"
#import "SurveyRecord.h"

@interface BodyDetectResultViewController : HMBasePageViewController
{
    DetectRecord* detectRecord;
    DetectResult* detectResult;
    
    NSString* recordId;
    NSInteger userId;
}


@end
