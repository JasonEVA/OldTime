//
//  HMWeightHistoryCollectionViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeightHistoryCollectionViewCell.h"
#import "HMSuperviseDetailModel.h"
#import "HMSuperviseEachPointModel.h"

@interface HMWeightHistoryCollectionViewCell ()
@property (nonatomic, strong) HMSuperviseDetailModel *model;
@property (nonatomic) CGFloat maxTarget;

@property (nonatomic) CGFloat minTarget;
@property (nonatomic, strong) UILabel *weightLb;
@property (nonatomic, strong) UIImageView *arrowImage;
@end

@implementation HMWeightHistoryCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];

        [self.contentView addSubview:self.weightLb];
        [self.contentView addSubview:self.arrowImage];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.model.startday) {
        UIBezierPath *line1 = [UIBezierPath bezierPath];
        
        [line1 moveToPoint:CGPointMake(self.frame.size.width / 2,0)];
        
        [line1 addLineToPoint:CGPointMake(self.frame.size.width / 2,self.frame.size.height)];
        
        [line1 setLineWidth:1];
        
        CGFloat dashPattern[] = {3,1};// 3实线，1空白
        
        [line1 setLineDash:dashPattern count:1 phase:1];
        
        
        [[UIColor colorWithHexString:@"ffffff"alpha:0.3] setStroke];
        
        [line1 stroke];
    }
    
    if (!self.model.datalist.count) {
        return;
    }
    [self.model.datalist enumerateObjectsUsingBlock:^(HMSuperviseEachPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [self acquirePointWithTargetMax:self.maxTarget targetMin:self.minTarget target:obj.testValue.floatValue];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:point radius:3 startAngle:0.0 endAngle:180.0 clockwise:YES];
        
        [[UIColor whiteColor] setFill];
        
        [path fill];
    }];

}

- (void)fillDataWithModel:(HMSuperviseDetailModel *)model maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget isSelected:(BOOL)isSelected {
    self.model = model;
    self.maxTarget = maxTarget;
    self.minTarget = minTarget;
    
    [self setNeedsDisplay];
    [self.arrowImage setHidden:!isSelected];
    [self.weightLb setHidden:!isSelected];

    if (isSelected) {
        // 选中才显示
        [self.weightLb setText:[NSString stringWithFormat:@"%.1fkg",model.datalist.firstObject.testValue.floatValue]];
        
        CGFloat ponitY = [self acquirePointWithTargetMax:maxTarget targetMin:minTarget target:model.datalist.firstObject.testValue.floatValue].y;
        
        if (ponitY > self.frame.size.height / 2) {
            // 框放上面
            [self.weightLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@22);
                make.left.right.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView.mas_top).offset(ponitY - 10);
            }];
            
            [self.arrowImage setTransform:CGAffineTransformMakeRotation(M_PI)];
            
            [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.weightLb.mas_bottom);
                make.centerX.equalTo(self.weightLb);
            }];
            
        }
        else {
            // 框放下面
            [self.weightLb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@22);
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(self.contentView).offset(ponitY + 10);
            }];
            [self.arrowImage setTransform:CGAffineTransformMakeRotation(2 * M_PI)];
            
            [self.arrowImage mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.weightLb.mas_top);
                make.centerX.equalTo(self.weightLb);
            }];
            
        }
        
    }
    
    
}

- (CGPoint)acquirePointWithTargetMax:(CGFloat)maxTarget targetMin:(CGFloat)minTarget target:(CGFloat)target {
    
    return CGPointMake(self.frame.size.width / 2, MIN(MAX(((target - minTarget) / (maxTarget - minTarget)) * (0 - self.frame.size.height) + self.frame.size.height, 3), self.frame.size.height-10));
}

- (UILabel *)weightLb {
    if (!_weightLb) {
        _weightLb = [UILabel new];
        [_weightLb setFont:[UIFont systemFontOfSize:12]];
        [_weightLb setTextColor:[UIColor mainThemeColor]];
        [_weightLb setTextAlignment:NSTextAlignmentCenter];
        [_weightLb setText:@"75.0kg"];
        [_weightLb setBackgroundColor:[UIColor whiteColor]];
        [_weightLb.layer setCornerRadius:3];
        [_weightLb setClipsToBounds:YES];
        [_weightLb setHidden:YES];
    }
    return _weightLb;
}

- (UIImageView *)arrowImage {
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_kg_sj"]];
        [_arrowImage setHidden: YES];
    }
    return _arrowImage;
}
@end
