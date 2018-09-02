//
//  BodyTemperatureRecordTableViewCell.h
//  HMClient
//
//  Created by yinquan on 17/4/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BodyTemperatureDetectRecord.h"

@interface BodyTemperatureRecordTableViewCell : UITableViewCell

- (void) setDetectRecord:(BodyTemperatureDetectRecord*) record;
@end
