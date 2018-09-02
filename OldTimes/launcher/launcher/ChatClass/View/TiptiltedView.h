//
//  TiptiltedView.h
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    viewKind_Attended,
    viewKind_RejectAttend,
    viewKind_Approve,
    viewKind_RejectApprove,
    viewKind_BackApprove,
    viewKind_PassTo,
    viewKind_agree,
    viewKind_disAgree
}viewKind;

@interface TiptiltedView : UIView
- (void)setdataWithType:(viewKind)type;
@end
