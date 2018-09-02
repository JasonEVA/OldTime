//
//  NewApplycommentbtnsView.m
//  launcher
//
//  Created by 马晓波 on 16/1/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewApplycommentbtnsView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "UIFont+Util.h"
#import "MyDefine.h"

@interface NewApplycommentbtnsView()
@property (nonatomic, strong) NSMutableArray *arrbtns;
@property (nonatomic, strong) UILabel *lblLine;
@property (nonatomic) CGFloat longestlength;
@end

@implementation NewApplycommentbtnsView
- (instancetype)initWithFrame:(CGRect)frame WithBtnTitleArray:(NSArray *)array
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        //todo 以后用得到再做吧 by conanma
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        NSArray *array = @[LOCAL(NEWAPPLY_ALL),LOCAL(NEWAPPLY_COMMENT),LOCAL(NEWAPPLY_ATTACHMENT),LOCAL(NEWAPPLY_SYSTEM)];
        self.backgroundColor = [UIColor whiteColor];
        [self CreateBtnsWithArray:array];
        [self setframes];
    }
    return self;
}

- (void)setframes
{
    [self addSubview:self.lblLine];
    UIButton *btn = self.arrbtns[0];
	self.lblLine.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame), btn.bounds.size.width, 1);
}

- (void)setblock:(passvalueblock)block
{
    if (block)
    {
        self.myblock = block;
    }
}

- (void)btnClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = sender.frame;
        self.lblLine.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 1);

    } completion:^(BOOL finished) {
		if (self.myblock && finished)
		{
			self.myblock(sender.tag);
		}
    }];
}

- (void)CreateBtnsWithArray:(NSArray *)array
{
    for (NSInteger i = 0; i<array.count; i++)
    {
        NSString *str = array[i];
        CGFloat width = [self getlength:str];
        UIButton *btn;
        if (i == 0)
        {
            btn = [[UIButton alloc] initWithFrame:CGRectMake(10 , 0, width, self.frame.size.height - 1)];
        }
        else
        {
            btn = [[UIButton alloc] initWithFrame:CGRectMake(((UIButton *)(self.arrbtns[i -1])).frame.size.width + ((UIButton *)(self.arrbtns[i -1])).frame.origin.x, 0, width, self.frame.size.height - 1)];
        }
        
        [btn setTitle:str forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont mtc_font_30];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.arrbtns addObject:btn];
    }
}

//- (void)CreateBtnsWithArray:(NSArray *)array
//{
//    CGFloat lenth = [self getlongeststr:array];
//    for (NSInteger i = 0; i<array.count; i++)
//    {
//        NSString *str = array[i];
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (lenth + 12) * i, 0, lenth, self.frame.size.height - 1)];
//        [btn setTitle:str forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont mtc_font_30];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        btn.tag = i;
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
//        [self.arrbtns addObject:btn];
//    }
//}

- (CGFloat)getlength:(NSString *)string
{
        CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
    return size.width + 15;
}

- (CGFloat)getlongeststr:(NSArray *)array
{
    CGFloat length = 0;
    for (NSInteger i = 0; i<array.count; i++)
    {
        CGSize size = [array[i] boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_30]} context:NULL].size;
        if (length <= size.width)
        {
            length = size.width;
        }
    }
    self.longestlength = length;
    return length + 4;
}

#pragma mark - init
- (NSMutableArray *)arrbtns
{
    if (!_arrbtns)
    {
        _arrbtns = [[NSMutableArray alloc] init];
    }
    return _arrbtns;
}

- (UILabel *)lblLine
{
    if (!_lblLine)
    {
        _lblLine = [[UILabel alloc] init];
        [_lblLine setBackgroundColor:[UIColor themeBlue]];
    }
    return _lblLine;
}
@end
