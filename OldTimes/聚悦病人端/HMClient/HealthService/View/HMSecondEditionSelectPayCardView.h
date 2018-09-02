//
//  HMSecondEditionSelectPayCardView.h
//  HMClient
//
//  Created by jasonwang on 2016/11/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//  支付选择银行卡弹出view

#import <UIKit/UIKit.h>
@class HMPingAnPayCardModel;
@protocol HMSecondEditionSelectPayCardViewDelegate <NSObject>

- (void)HMSecondEditionSelectPayCardViewDelegateCallBack_addCard;

- (void)HMSecondEditionSelectPayCardViewDelegateCallBack_deleteCard:(HMPingAnPayCardModel *)deleteCard;
@end
typedef void (^shotBlock)(NSInteger tag);

@interface HMSecondEditionSelectPayCardView : UIView
- (void)btnClick:(shotBlock)block;
@property (nonatomic, weak) id<HMSecondEditionSelectPayCardViewDelegate> delegate;
@property (nonatomic, strong) HMPingAnPayCardModel *selectedCard;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *confirmPayBtn;
// 数据源方法
- (void)fillDataWithArray:(NSArray <HMPingAnPayCardModel* >*)array;
// 更新UI
- (void)updateUI;
@end
