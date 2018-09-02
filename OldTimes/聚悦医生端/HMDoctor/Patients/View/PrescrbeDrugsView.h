//
//  PrescrbeDrugsView.h
//  HMDoctor
//
//  Created by lkl on 16/6/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrugInfo.h"
#import "PrescribeInfo.h"

@interface PrescrbeDrugsView : UIView

@property (nonatomic, strong) UIButton *deleteBtn;

- (void)setDrugInfo:(DrugInfo *)info;
- (void)setPrescribeDetailDrugsInfo:(PrescribeTempInfo *)info;

@end

@interface DrugsUsagesSelectControl : UIControl

@property (nonatomic, retain) UILabel *lbContent;
@property (nonatomic, retain) UIImageView *ivArrow;

- (void)setContent:(NSString *)content;

@end

@interface DrugsUsagesSelectView : UIView

@property(nonatomic, retain) UITextField *tfDosage;

@property(nonatomic, retain) DrugsUsagesSelectControl *dosageControl;
@property(nonatomic, retain) DrugsUsagesSelectControl *unitControl;
@property(nonatomic, retain) DrugsUsagesSelectControl *frequencyControl;
@property(nonatomic, retain) DrugsUsagesSelectControl *usageControl;

@end

@interface DrugsUsagesView : UIView

@property (nonatomic, retain) UITextField *tfUsages;
- (void)setName:(NSString *)name unit:(NSString *)unit;

@end