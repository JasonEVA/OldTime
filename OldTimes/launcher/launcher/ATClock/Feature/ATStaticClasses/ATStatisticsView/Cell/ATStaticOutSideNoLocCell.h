//
//  ATStaticOutSideNoLocCell.h
//  Clock
//
//  Created by Dariel on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATTableViewCell.h"
#import "ATStaticOutsideModel.h"

@interface ATStaticOutSideNoLocCell : ATTableViewCell

@property (nonatomic, strong) ATStaticOutsideModel *staticOutsideModel;
@property (nonatomic, strong) UIView *topLineView;

@end
