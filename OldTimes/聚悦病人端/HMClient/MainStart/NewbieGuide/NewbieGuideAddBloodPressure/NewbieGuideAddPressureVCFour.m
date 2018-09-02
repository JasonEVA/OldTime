//
//  NewbieGuideAddPressureVCFour.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewbieGuideAddPressureVCFour.h"
#import "BodyDetectUniversalPickerView.h"

@interface NewbieGuideAddPressureVCFour ()
@property (nonatomic, copy)  NSString  *currentImageName; // <##>
@property (nonatomic, strong)  MASConstraint  *pickerBottomContraint; // <##>
@end

@implementation NewbieGuideAddPressureVCFour

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentImageName = @"newbieGuide_addPressure4";
    [self configBackgroundImageView:self.currentImageName];
    [self p_configPickerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backgroundImageViewClicked {
    if ([self.currentImageName isEqualToString:@"newbieGuide_addPressure4"]) {
        self.currentImageName = @"newbieGuide_addPressure5";
        [self configBackgroundImageView:self.currentImageName];
        [self p_showPicker];
    }
}

- (void)p_configPickerView {
    NSMutableArray *sysData = [[NSMutableArray alloc] init];
    for (int i = 30; i <= 350; i++)
    {
        [sysData addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSMutableArray *diaData = [[NSMutableArray alloc] init];
    for (int i = 10; i <= 300; i++)
    {
        [diaData addObject:[NSString stringWithFormat:@"%d",i]];
    }
    __weak typeof(self) weakSelf = self;
    BodyDetectUniversalPickerView *selectView = [[BodyDetectUniversalPickerView alloc] initWithDataArray:@[sysData,diaData] detaultArray:@[@"120", @"80"] pickerType:k_PickerType_BloodPressure dataCallBackBlock:^(NSMutableArray *selectedItems) {
        if (![selectedItems.firstObject isEqualToString:@"120"] && ![selectedItems.lastObject isEqualToString:@"80"]) {
            [weakSelf pickerViewScrollComplete];
        }
    }];
    [self.backgroundImageView addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroundImageView);
        self.pickerBottomContraint = make.bottom.equalTo(self.backgroundImageView).offset(kPickerViewHeight.floatValue);
        make.height.equalTo(kPickerViewHeight);
    }];
}

- (void)p_showPicker {
    self.pickerBottomContraint.offset = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
