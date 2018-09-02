//
//  HMSEPersonSpaceCollectionTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2017/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版我的界面头部collection cell

typedef NS_ENUM(NSUInteger, SEPersonSpaceCollectionType) {
    
    SEPersonSpaceCollectionType_MyOrder,       // 我的订单
    
    SEPersonSpaceCollectionType_MyService,     // 我的服务
    
    SEPersonSpaceCollectionType_MyAppointment,        // 我的约诊
    
    SEPersonSpaceCollectionType_MyIntegal,      //我的积分
    
};

@protocol HMSEPersonSpaceCollectionTableViewCellDelegate <NSObject>

- (void)HMSEPersonSpaceCollectionTableViewCellDelegateCallBack_CollectType:(SEPersonSpaceCollectionType)type;

@end

#import <UIKit/UIKit.h>

@interface HMSEPersonSpaceCollectionTableViewCell : UITableViewCell
@property (nonatomic, weak) id<HMSEPersonSpaceCollectionTableViewCellDelegate> personSpaceDelegate;
@end
