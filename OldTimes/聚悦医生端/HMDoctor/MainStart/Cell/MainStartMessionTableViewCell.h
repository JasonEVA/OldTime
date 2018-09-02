//
//  MainStartMessionTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainStartMessionTableViewCell : UITableViewCell
{
    UIImageView* ivIcon;
    UILabel* lbName;
    UILabel* lbComment;
}

- (void) setMessionType:(NSString*) type Icon:(UIImage*) icon;
- (void) setMessionComment:(NSString*) comment;

@end

@interface MainStartWarningMessionTableViewCell : MainStartMessionTableViewCell

@end
