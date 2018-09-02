//
//  PrescribeDetailTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrescrbeDrugsView.h"
#import "PrescribeInfo.h"

@interface PrescribeDetailTableViewCell : UITableViewCell

@property (nonatomic, strong)  PrescrbeDrugsView *addDrugsView;
@property (nonatomic, strong)  DrugsUsagesSelectView *drugselectView;
@property (nonatomic, strong)  DrugsUsagesView *drugsDaysView;
@property (nonatomic, strong)  DrugsUsagesView *drugsTotalView;
@property (nonatomic, strong) UITextField *remarkTF;
- (void)setPrescribeDetailDrugsInfo:(PrescribeTempInfo *)info;

@end
