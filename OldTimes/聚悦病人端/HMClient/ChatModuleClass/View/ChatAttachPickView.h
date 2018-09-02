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
    
    tag_pick_healthPlan, // 健康计划
    tag_pick_survey,    // 随访
    tag_pick_inquiry, // 问诊
    tag_pick_prescribe, // 开处方
    tag_pick_care, // 关怀
    tag_pick_evaluate, // 评估
    tag_pick_wardRound, // 查房

    tag_pick_max
} ChatAttachPick_tag;

typedef NS_ENUM(NSUInteger, ChatAttachPickType) {
    ChatAttachPickTypeBase, // 基本图片，照相
    ChatAttachPickTypeFull, // 全部
};


#define H_COMMON_VIEW  50           // 语音文字输入栏高度
#define H_ATTACH_VIEW  110          // 附件输入栏高度

@protocol ChatAttachPickViewDelegate <NSObject>

@optional
// 点击按钮的事件
- (void)ChatAttachPickViewDelegateCallBack_BtnClickedWithTag:(ChatAttachPick_tag)tag;

@end

@interface ChatAttachPickView : UIView

@property (nonatomic,weak) id <ChatAttachPickViewDelegate> delegate;

// 配置附件栏输入类型,必须设置
- (void)configAttachPickViewType:(ChatAttachPickType)attachPickType;

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
