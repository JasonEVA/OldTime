//
//  HMSuperviseDetailBaseCollectionViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/7/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSuperviseDetailBaseCollectionViewCell.h"
#import "UIImage+EX.h"
#import "HMChartCellBaseBackView.h"

@interface HMSuperviseDetailBaseCollectionViewCell ()
@property (nonatomic) NSInteger YCount;    // Y轴坐标点数量
@property (nonatomic, copy) cellTouch block;
@property (nonatomic, strong) HMChartCellBaseBackView *backView;
@end


@implementation HMSuperviseDetailBaseCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.YCount = 10;
        
        [self.contentView addSubview:self.heightBtn];
        [self.heightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        

    }
    return self;
}

- (void)fillDataWithModel:(HMSuperviseDetailModel *)model maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget isShowSolidLine:(BOOL)isShowSolidLine isShowRightLinr:(BOOL)isShowRightLine type:(SESuperviseType)type{
    
    [self.backView fillDataWithModel:model maxTarget:maxTarget minTarget:minTarget isShowSolidLine:isShowSolidLine isShowRightLinr:isShowRightLine type:type];
}

- (void)touchDownClick {
   
    if (self.block) {
        self.block(YES, NO);

    }
}

- (void)touchUpClick {
    [self.heightBtn setBackgroundColor:[UIColor whiteColor]];

    if (self.block) {
        self.block(NO, YES);

    }
}

- (void)getCellTouchStatus:(cellTouch)block {
    self.block = block;
}
- (UIButton *)heightBtn {
    if (!_heightBtn) {
        _heightBtn = [[UIButton alloc] init];
        
        [_heightBtn setBackgroundColor:[UIColor whiteColor]];
        [_heightBtn addTarget:self action:@selector(touchDownClick) forControlEvents:UIControlEventTouchDown];
        [_heightBtn addTarget:self action:@selector(touchUpClick) forControlEvents:UIControlEventTouchUpInside];
        [_heightBtn addTarget:self action:@selector(touchUpClick) forControlEvents:UIControlEventTouchDragExit];
        [_heightBtn addTarget:self action:@selector(touchUpClick) forControlEvents:UIControlEventTouchCancel];

    }
    return _heightBtn;
}

- (HMChartCellBaseBackView *)backView {
    if (!_backView) {
        _backView = [[HMChartCellBaseBackView alloc] initWithFrame:self.frame];
    }
    return _backView;
}

@end
