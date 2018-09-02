//
//  ATPunchCardModel.m
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATPunchCardModel.h"
#import "ATSharedMacro.h"

@implementation ATPunchCardModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (void)determineWhetherAbnormalWithOnWorkTime:(NSNumber *)onWorkTime offWorkTime:(NSNumber *)offWorkTime
{
    if (1 == self.SignType.integerValue) {
        if ((self.Time.longLongValue <= onWorkTime.longLongValue || 0 == onWorkTime.longLongValue) && self.IsLocation.integerValue == 1) {
            _isAbnormal = NO;
        } else {
            _isAbnormal = YES;
        }
    } else if (2 == self.SignType.integerValue) {
        if ((self.Time.longLongValue >= offWorkTime.longLongValue || 0 == offWorkTime.longLongValue) && self.IsLocation.integerValue == 1) {
            _isAbnormal = NO;
        } else {
            _isAbnormal = YES;
        }
    } else if (3 == self.SignType.integerValue) {
        _isAbnormal = YES;
//        _isAbnormal = random() % 2 == 1 ? YES : NO;
    }
}

- (BOOL)isAbnormal {
    return _isAbnormal;
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGSize locationSize = [self calculateString:self.Location size:CGSizeMake(SCREEN_WIDTH - (102.5 + 15 + 5) - 10, MAXFLOAT) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        
        CGFloat height, remake_h;
        if (self.isAbnormal) {
            height = 95 - 15 * 2;
            remake_h = [self.Remark boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - (102.5 + 15 + 5) - 10 - 25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
        } else {
            height = 70 - 15;
            remake_h = 0;
        }
        
        _cellHeight = locationSize.height + height + remake_h;
    }
    
    return _cellHeight;
}

- (CGSize)calculateString:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attDic {
    CGSize boundSize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attDic context:nil].size;
    
    return boundSize;
}

@end
