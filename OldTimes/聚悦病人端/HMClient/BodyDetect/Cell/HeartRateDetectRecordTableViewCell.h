//
//  HeartRateDetectRecordTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeartRateDetectRecord.h"
#import "BraceletHeartRateModel.h"

@interface HeartRateDetectRecordTableViewCell : UITableViewCell
{
    
}

- (void) setDetectRecord:(HeartRateDetectRecord*) record;
- (void) setBraceletHeartRateModel:(BraceletHeartRateModel *)model;
@end
