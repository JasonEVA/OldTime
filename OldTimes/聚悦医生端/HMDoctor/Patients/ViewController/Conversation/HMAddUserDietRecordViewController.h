//
//  HMAddUserDietRecordViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//  收藏到饮食界面

#import "HMBaseViewController.h"

typedef void(^AddUserDietRecordVCDisMiss)(BOOL isSuccessed);

@class MessageBaseModel;

@interface HMAddUserDietRecordViewController : HMBaseViewController
- (instancetype)initWithModel:(MessageBaseModel *)model strUid:(NSString *)strUid disMisssBlock:(AddUserDietRecordVCDisMiss)disMisssBlock;

@end
