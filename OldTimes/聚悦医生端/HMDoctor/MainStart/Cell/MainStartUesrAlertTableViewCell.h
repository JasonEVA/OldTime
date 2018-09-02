//
//  MainStartUesrAlertTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/3.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAlertInfo.h"

@class MainStartUesrAlertUndealView;

//
@interface MainStartUserAlertView : UIView

@property (nonatomic, readonly) UIButton* archiveButton;
- (void) setUserAlert:(UserAlertInfo*) alert;
@end

//待处理view
@interface MainStartUesrAlertUndealView : UIView

@property (nonatomic,strong) UIButton *statusbutton;
@property (nonatomic, strong) UIButton *contactBtn;

@end

//全部view
@interface MainStartUesrAlertAllStatusView : UIView

@end


//全部
@interface MainStartUesrAlertTableViewCell : UITableViewCell
- (void) setUserAlert:(UserAlertInfo*) alert;
@property (nonatomic, strong) MainStartUserAlertView *userAlertView;
@end

//待处理
@interface MainStartUesrAlertUndealTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton *statusbutton;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, strong) MainStartUserAlertView *userAlertView;
@property (nonatomic,strong) MainStartUesrAlertUndealView *undealView;  //待处理
- (void) setUserAlert:(UserAlertInfo*) alert;

@end



