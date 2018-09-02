//
//  IMChartBaseViewController.h
//  HMDoctor
//
//  Created by yinquan on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "IMTextMessageInputView.h"

@interface IMChartBaseViewController : UIViewController
{
    ContactDetailModel* contactDetail;      //联系人详情
    UIView* chatview;
    UIView* messageInputView;
}
@property (nonnull, readonly) UITableViewController* tvcMessages;

- (id)initWithDetailModel:(ContactDetailModel *)detailModel;

@end
