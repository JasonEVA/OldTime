//
//  HMCheckItemView.h
//  HMDoctor
//
//  Created by lkl on 2017/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGetCheckImgListModel.h"

@interface HMCheckItemView : UIView

- (instancetype)initWithadmissionId:(NSString *)admissionId;

@property (nonatomic, copy) void(^itemSelectBlock)(CheckItemTypeModel *model);

@end
