//
//  NewFiveStarSelectView.m
//  HMClient
//
//  Created by jasonwang on 2017/3/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewFiveStarSelectView.h"

@implementation NewFiveStarSelectView
- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _commentStarLabel = [[UILabel alloc] init];
        [_commentStarLabel setTextColor:[UIColor colorWithHexString:@"1a2940"]];
        [_commentStarLabel setFont:[UIFont systemFontOfSize:15]];
        _commentStarLabel.text = name;
        [self createFrame];

    }
    return self;
}

- (void)createFrame
{
    [self addSubview:self.commentStarLabel];
    [self.commentStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.width.lessThanOrEqualTo(@95);
    }];
    
    for (int i = 0; i< 5; i ++)
    {
        UIButton *btn = self.starBtnArray[i];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentStarLabel.mas_left).offset(102.5 + i * 35);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@20);
            if (i == 4) {
                make.right.equalTo(self);
            }
        }];
    }
}
#pragma mark - interFaceMethod
- (void)getStarCountWithBlock:(NewFiveStarSelectViewCallBackBlock)block
{
    self.myBlock = block;
}

- (void)changeStarStatus:(NSInteger)tag {
    for (UIButton *btn in self.starBtnArray)
    {
        if (btn.tag <= tag)
        {
            btn.selected = YES;
        }else
        {
            btn.selected = NO;
        }
    }

}

- (void)starDisenable {
    [self.starBtnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setUserInteractionEnabled:NO];
    }];
}
#pragma mark - eventRespond
- (void)touchAction:(UIButton *)sender
{
    sender.selected ^= 1;
    [self changeStarStatus:sender.tag];
    
    if (self.myBlock)
    {
        self.myBlock(sender.tag + 1);
    }
}

#pragma mark - setterAndGetter

- (NSMutableArray *)starBtnArray
{
    if (!_starBtnArray)
    {
        _starBtnArray  = [NSMutableArray array];
        for (int i = 0; i< 5 ; i++)
        {
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundImage:[UIImage imageNamed:@"person_start_icon"] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"person_evalue_unselected"] forState:UIControlStateNormal];
            [_starBtnArray  addObject:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _starBtnArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
