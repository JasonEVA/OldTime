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
//#import "MyDefine.h"

@interface NewApplycommentbtnsView()
@property (nonatomic, strong) NSMutableArray *arrbtns;
@property (nonatomic, strong) UILabel *lblLine;
@property (nonatomic) CGFloat longestlength;
@property (nonatomic, strong)  UIButton  *currentSelectedBtn; // <##>
@property (nonatomic, strong)  UIButton  *writeComment; // <##>
@property (nonatomic, copy)  WriteCommentButtonClicked  writeCommentBlock; // <##>
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
        NSArray *array = @[@"全部",@"评论",@"操作"];UIView *topLine = [UIView new];
        [topLine setBackgroundColor:[UIColor systemLineColor_c8c7cc]];
        [self addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@0.5);
        }];

        self.backgroundColor = [UIColor whiteColor];
        [self CreateBtnsWithArray:array];
        [self setframes];
    }
    return self;
}

- (void)setframes
{
    [self addSubview:self.writeComment];
    [self addSubview:self.lblLine];
    UIButton *btn = self.arrbtns[0];
    [self.lblLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(btn);
        make.left.right.equalTo(btn);
        make.top.equalTo(btn.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [self.writeComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 8));
        make.width.mas_equalTo(70);
    }];
}

- (void)setblock:(passvalueblock)block
{
    if (block)
    {
        self.myblock = block;
    }
}
- (void)addNotiWriteCommentButtonClicked:(WriteCommentButtonClicked)block {
    if (!block) {
        return;
    }
    self.writeCommentBlock = block;
}

- (void)btnClick:(UIButton *)sender
{
    self.currentSelectedBtn.selected = !self.currentSelectedBtn.selected;
    self.currentSelectedBtn = sender;
    self.currentSelectedBtn.selected = YES;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGRect frame = sender.frame;
        strongSelf.lblLine.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 1);
        if (strongSelf.myblock)
        {
            strongSelf.myblock(sender.tag);
        }
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGRect frame = sender.frame;
        strongSelf.lblLine.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 1);
    }];
}

- (void)writeCommentButtonClicked {
    self.writeCommentBlock();
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
            self.currentSelectedBtn = btn;
            self.currentSelectedBtn.selected = YES;
        }
        else
        {
            btn = [[UIButton alloc] initWithFrame:CGRectMake(((UIButton *)(self.arrbtns[i -1])).frame.size.width + ((UIButton *)(self.arrbtns[i -1])).frame.origin.x, 0, width, self.frame.size.height - 1)];
        }
        
        [btn setTitle:str forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont font_30];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor commonDarkGrayColor_666666] forState:UIControlStateNormal];

        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = (TaskCommentType)i;
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
//        btn.titleLabel.font = [UIFont font_30];
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
        CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont font_30]} context:NULL].size;
    return size.width + 15;
}

- (CGFloat)getlongeststr:(NSArray *)array
{
    CGFloat length = 0;
    for (NSInteger i = 0; i<array.count; i++)
    {
        CGSize size = [array[i] boundingRectWithSize:CGSizeMake(MAXFLOAT,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont font_30]} context:NULL].size;
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

- (UIButton *)writeComment {
    if (!_writeComment) {
        _writeComment = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeComment setImage:[UIImage imageNamed:@"mission_comment"] forState:UIControlStateNormal];
        [_writeComment setTitle:@"写评论" forState:UIControlStateNormal];
        _writeComment.titleLabel.font = [UIFont font_30];
        [_writeComment setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
        [_writeComment setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
        _writeComment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_writeComment addTarget:self action:@selector(writeCommentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeComment;
}
@end
