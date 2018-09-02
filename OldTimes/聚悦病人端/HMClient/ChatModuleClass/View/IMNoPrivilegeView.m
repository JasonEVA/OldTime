//
//  IMNoPrivilegeView.m
//  HMClient
//
//  Created by jasonwang on 16/8/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "IMNoPrivilegeView.h"
#import "HMSessionListInteractor.h"

@implementation IMNoPrivilegeView


/* 0 未知状态
 1 可聊天
 2 套餐到期
 3 套餐退订
 4 套餐不包含图文资讯
 5 单次咨询服务到期
 6 员工无权限*/

- (instancetype)initWithIMStatus:(NSInteger)status {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        UIButton* updateServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];

        if ([self acquireBtnStringWithStatus:status].length) {
            [self addSubview:updateServiceButton];
            [updateServiceButton setBackgroundImage:[UIImage rectImage:CGSizeMake(90, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
            [updateServiceButton setTitle:[self acquireBtnStringWithStatus:status] forState:UIControlStateNormal];
            updateServiceButton.layer.cornerRadius = 15;
            updateServiceButton.layer.masksToBounds = YES;
            [updateServiceButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [updateServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            updateServiceButton.tag = status;
            
            [updateServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(90, 30));
                make.right.equalTo(self).with.offset(-15);
                make.centerY.equalTo(self);
            }];
            
            [updateServiceButton addTarget:self action:@selector(updateServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UILabel* lbVip = [[UILabel alloc]init];
        [self addSubview:lbVip];
        [lbVip setBackgroundColor:[UIColor clearColor]];
        [lbVip setText:[self acquireTitleStringWithStatus:status]];
        [lbVip setFont:[UIFont systemFontOfSize:15]];
        [lbVip setTextColor:[UIColor colorWithHexString:@"333333"]];
        
        [lbVip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(15);
            make.centerY.equalTo(self);
            make.right.lessThanOrEqualTo([self acquireBtnStringWithStatus:status].length ? updateServiceButton.mas_left :self).offset(-15);
        }];
        
    }
    return self;
}

- (NSString *)acquireTitleStringWithStatus:(NSInteger)status {
    NSString *tempStr = @"未知类型";
    switch (status) {
        case 0:
            tempStr = @"数据异常，请联系客服";
            break;
        case 1:
            tempStr = @"可聊天";
            break;
        case 2:
            tempStr = @"套餐到期";
            break;
        case 3:
            tempStr = @"套餐退订";
            break;
        case 4:
            tempStr = @"套餐不包含图文资讯";
            break;
        case 5:
            tempStr = @"单次咨询服务到期";
            break;
        case 6:
            tempStr = @"员工无权限";
            break;
            
        default:
            break;
    }
    return tempStr;
}

- (NSString *)acquireBtnStringWithStatus:(NSInteger)status {
    NSString *tempStr = @"";
    switch (status) {
        case 0:
            tempStr = @"联系客服";
            break;
        case 1:
            tempStr = @"";
            break;
        case 2:
            tempStr = @"续费服务";
            break;
        case 3:
            tempStr = @"购买服务";
            break;
        case 4:
            tempStr = @"升级服务";
            break;
        case 5:
            tempStr = @"续费服务";
            break;
        case 6:
            tempStr = @"";
            break;
            
        default:
            break;
    }
    return tempStr;
}

- (void) updateServiceButtonClicked:(UIButton *) sender
{
    
    if (!sender.tag) {
        //跳转到客服咨询
        UIWebView * callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:4008332616"]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];

    }
    else {
        //跳转到服务订购列表
        [[HMSessionListInteractor sharedInstance] gotoBuyService];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
