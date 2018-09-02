//
//  RoundsMessionTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 16/9/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundsMessionModel.h"

@interface RoundsMessionTableViewCell : UITableViewCell
{
    
}

@property (nonatomic,strong) UIButton *archiveButton;
@property (nonatomic, readonly) UIButton* roundsButton;

- (void) setRoundsMessionModel:(RoundsMessionModel*) mession;

@end
