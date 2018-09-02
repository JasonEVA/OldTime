//
//  ChatAttachPickView.m
//  Titans
//
//  Created by Remon Lv on 14-9-15.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatAttachPickView.h"
#import "QuickCreateManager.h"
#import "Slacker.h"
#import "MyDefine.h"

#define IMG_BTN_PHOTO       @"message_chat_photo"
#define IMG_BTN_IMG         @"message_chat_image"
#define IMG_BTN_FILE        @"message_chat_file"
#define IMG_BTN_LOCATION    @"message_chat_location"
#define IMG_BTN_CHECK       @"message_chat_check"

#define TITLE_BTN_VIDEO       @"视频"

@implementation ChatAttachPickView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // “文件”暂时屏蔽掉
//        NSArray *arrImg = [NSArray arrayWithObjects:IMG_BTN_IMG, IMG_BTN_TAKEPHOTO, IMG_BTN_FILE, IMG_BTN_LOCATION, nil];
//        NSArray *arrTitle = [NSArray arrayWithObjects:@"(TITLE_BTN_IMG), @"(TITLE_BTN_TAKEPHOTO, LOCL(TITLE_BTN_FILE), @"(TITLE_BTN_LOCATION), nil];
        NSArray *arrImg = [NSArray arrayWithObjects:IMG_BTN_IMG,IMG_BTN_PHOTO, IMG_BTN_CHECK, nil];
        NSArray *arrTitle = [NSArray arrayWithObjects:LOCAL(APPLY_PICTURE),LOCAL(CAMERA),LOCAL(Application_Mission), nil];
        
        CGFloat w_view = frame.size.width / arrImg.count;
        for (ChatAttachPick_tag tag = tag_pick_min + 1; tag < tag_pick_max; tag ++)
        {
            NSString *imgName = [arrImg objectAtIndex:tag];
            NSString *title = [arrTitle objectAtIndex:tag];
            
            ChatAttachPickBtn *btn = [[ChatAttachPickBtn alloc] initWithFrame:CGRectMake(tag * w_view, 0, w_view, frame.size.height) ImageName:imgName Title:title Tag:tag Target:self Action:@selector(btnClicked:)];
            [self addSubview:btn];
        }
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

#pragma mark -- Private Method
- (void)btnClicked:(id)sender
{
    ChatAttachPick_tag tag = (ChatAttachPick_tag)(((UIButton *)sender).tag);
    
    // 转发按钮点击的委托
    if ([self.delegate respondsToSelector:@selector(ChatAttachPickViewDelegateCallBack_BtnClickedWithTag:)])
    {
        [self.delegate ChatAttachPickViewDelegateCallBack_BtnClickedWithTag:tag];
    }
}

@end



#pragma mark - MyButton

#define W_BTN   56
#define Y_BTN   18
#define M_TITLE 7
#define H_TITLE 15

@implementation ChatAttachPickBtn

- (id)initWithFrame:(CGRect)frame ImageName:(NSString *)imgName Title:(NSString *)title Tag:(NSInteger)tag Target:(id)target Action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 按钮
        _btn = [QuickCreateManager creatButtonWithFrame:CGRectMake((frame.size.width - W_BTN) * 0.5, Y_BTN, W_BTN, W_BTN) Title:nil TitleFont:nil TitleColor:nil BgImage:[UIImage imageNamed:imgName] HighImage:nil BgColor:nil Tag:tag];
        [_btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [_btn setTag:tag];
        [self addSubview:_btn];
        
        // 标签
        _lbTitle = [QuickCreateManager creatLableWithFrame:CGRectMake(0, [Slacker getValueWithFrame:_btn.frame WithX:NO] + M_TITLE, frame.size.width, H_TITLE) Text:title Font:[UIFont systemFontOfSize:14] Alignment:NSTextAlignmentCenter Color:[UIColor grayColor]];
        [self addSubview:_lbTitle];
    }
    return self;
}

@end