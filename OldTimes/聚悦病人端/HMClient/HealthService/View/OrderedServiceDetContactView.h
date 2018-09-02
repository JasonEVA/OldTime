//
//  OrderedServiceDetContactView.h
//  HMClient
//
//  Created by yinquan on 16/11/15.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderedServiceDetContactView : UIView

@property (nonatomic, readonly) UILabel* contactNoticeLable;
@property (nonatomic, readonly) UILabel* contactTimeLable;

@property (nonatomic, readonly) UIButton* contactButton;    //联系客服
@property (nonatomic, readonly) UIButton* contactAdviserButton; //联系健康顾问

@end

//商品
@interface OrderedGoodsDetContactView : OrderedServiceDetContactView

@end

//增值服务
@interface OrderedValueAddedServiceDetContactView : OrderedServiceDetContactView

@end

//套餐服务
@interface OrderedPackageServiceDetContactView : OrderedServiceDetContactView

@end
