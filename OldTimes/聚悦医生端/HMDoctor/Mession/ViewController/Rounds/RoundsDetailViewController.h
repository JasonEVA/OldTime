//
//  RoundsDetailViewController.h
//  HMDoctor
//
//  Created by yinquan on 16/9/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "RoundsMessionModel.h"

typedef void(^filledSuccessBlock)();

@interface RoundsDetailViewController : HMBasePageViewController

@property (nonatomic, readonly) RoundsMessionModel* messionModel;

- (instancetype)initWithModel:(RoundsMessionModel *)model isFilled:(BOOL)isFilled;

- (void)fillFinish:(filledSuccessBlock)block;
@end
