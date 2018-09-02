//
//  HMSuperviseFirstDateView.h
//  HMClient
//
//  Created by jasonwang on 2017/7/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSuperviseEnum.h"

@interface HMSuperviseFirstDateView : UIView
- (void)fillDataWithDate:(NSDate *)date superviseScreening:(SESuperviseScreening)type;

@end
