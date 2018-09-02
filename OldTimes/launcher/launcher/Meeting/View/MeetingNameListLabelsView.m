//
//  MeetingNameListLabelsView.m
//  launcher
//
//  Created by 马晓波 on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeetingNameListLabelsView.h"
#import "MyDefine.h"


@interface MeetingNameListLabelsView()
@property (nonatomic) CGRect Getframe;
@property (nonatomic, strong) NSArray *arrNameList;
@end

#define Interval  17
#define LabelHeight 37
#define LabelWidth 60

@implementation MeetingNameListLabelsView

-(instancetype)initWithFrame:(CGRect)frame ArrNameLsit:(NSArray *)arrNameList
{
    if (self = [super initWithFrame:frame])
    {
        _Getframe = frame;
        
        self.arrNameList = arrNameList;
        [self CreatLabelsWithNamearr:arrNameList];
        self.frame = self.frame = CGRectMake(frame.origin.x, frame.origin.y, _Getframe.size.width + 5, Interval *(arrNameList.count - 1) + LabelHeight *arrNameList.count);
    }
    return self;
}

- (void)CreatLabelsWithNamearr:(NSArray *)arrNameList;
{
    for (int i = 0; i <arrNameList.count; i++)
    {
        MeetingNameListBtn *btn = [[MeetingNameListBtn alloc] init];
        btn.label.frame = CGRectMake(0, Interval *i + LabelHeight *i, LabelWidth, LabelHeight);
        btn.label.textColor = [UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:1];
        btn.label.font = [UIFont systemFontOfSize:16];
        btn.label.textAlignment = NSTextAlignmentLeft;
        NSString *str = [arrNameList objectAtIndex:i];
        CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(btn.label.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.label.font} context:NULL].size;
//        CGSize size = [str sizeWithFont:btn.label.font constrainedToSize:CGSizeMake(MAXFLOAT, btn.label.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        [btn.label setFrame:CGRectMake(0, Interval *i + LabelHeight *i, size.width, LabelHeight)];
        btn.label.text = [arrNameList objectAtIndex:i];
        if (size.width > _Getframe.size.width)
        {
            _Getframe = CGRectMake(_Getframe.origin.x, _Getframe.origin.y, size.width, _Getframe.size.height);
        }
        btn.frame = btn.label.frame;
        
        btn.label.frame = CGRectMake(0, 0, btn.label.frame.size.width, btn.label.frame.size.height);
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.arrBtns addObject:btn];
        [self addSubview:btn];
    }
}

#pragma mark - Privite Methods
- (void)btnClick:(MeetingNameListBtn *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MeetingNameListLabelsViewCallback_delegateWithbtn:)])
    {
        [self.delegate MeetingNameListLabelsViewCallback_delegateWithbtn:btn];
    }
}

#pragma mark - init
- (NSMutableArray *)arrBtns
{
    if (!_arrBtns)
    {
        _arrBtns = [[NSMutableArray alloc] init];
    }
    return _arrBtns;
}

- (NSArray *)arrNameList
{
    if (!_arrNameList)
    {
        _arrNameList = [[NSArray alloc] init];
    }
    return _arrNameList;
}
@end
