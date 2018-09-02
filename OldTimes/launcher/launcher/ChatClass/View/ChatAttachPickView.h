//
//  ChatAttachPickView.h
//  Titans
//
//  Created by Remon Lv on 14-9-15.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  底部其它输入View

#import <UIKit/UIKit.h>
@class ChatAttachPickBtn;

typedef enum
{
    tag_pick_min = -1,
    tag_pick_img,
    tag_pick_takePhoto,
    
    
   
//    tag_pick_file,
//    tag_pick_video,
//    tag_pick_location,
    tag_pick_task,
    tag_pick_max
} ChatAttachPick_tag;

@protocol ChatAttachPickViewDelegate <NSObject>

@optional
// 点击按钮的事件
- (void)ChatAttachPickViewDelegateCallBack_BtnClickedWithTag:(ChatAttachPick_tag)tag;

@end

@interface ChatAttachPickView : UIView

@property (nonatomic,weak) id <ChatAttachPickViewDelegate> delegate;

@end


#pragma mark - MyButton
@interface ChatAttachPickBtn : UIView
{
    UIButton *_btn;
    UILabel *_lbTitle;
}

// 初始化单个按钮的方法
- (id)initWithFrame:(CGRect)frame ImageName:(NSString *)imgName Title:(NSString *)title Tag:(NSInteger)tag Target:(id)target Action:(SEL)action;

@end
