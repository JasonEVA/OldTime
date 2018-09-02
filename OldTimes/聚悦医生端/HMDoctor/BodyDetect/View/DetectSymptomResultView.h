//
//  DetectSymptomResultView.h
//  HMDoctor
//
//  Created by lkl on 2017/4/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectRecord.h"

@interface DetectSymptomResultView : UIView

- (void)setDetectResult:(DetectResult *) detectResult;
@property (nonatomic,strong) UILabel *contentLabel;

@end
