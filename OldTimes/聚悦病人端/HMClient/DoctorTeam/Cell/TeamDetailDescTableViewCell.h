//
//  TeamDetailDescTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamDetailDescTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UIButton* expendbutton;
- (void) setTeamDesc:(NSString*) teamdesc;
- (void) setExtendStyle:(NSInteger) style;
@end
