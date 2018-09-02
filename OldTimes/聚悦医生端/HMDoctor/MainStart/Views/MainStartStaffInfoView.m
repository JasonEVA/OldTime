//
//  MainStartStaffInfoView.m
//  HMDoctor
//
//  Created by yinquan on 16/4/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MainStartStaffInfoView.h"

@interface MainStartStaffInfoView ()
{
    UIView* funsview;
    UIView* patientview;
    
    UIImageView* ivFuns;
    UILabel* lbFuns;
    UILabel* lbFunsCount;
    
    UIImageView* ivPatient;
    UILabel* lbPatient;
    UILabel* lbPatientCount;
}

@end

@implementation MainStartStaffInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor mainThemeColor]];
        
        funsview = [[UIView alloc]init];
        [self addSubview:funsview];
        
        
        patientview = [[UIView alloc]init];
        [self addSubview:patientview];
        //[patientview setBackgroundColor:[UIColor redColor]];

            
        ivFuns = [[UIImageView alloc]init];
        [funsview addSubview:ivFuns];
        [ivFuns setImage:[UIImage imageNamed:@"ic_main_funs"]];
        
        lbFuns = [[UILabel alloc]init];
        [funsview addSubview:lbFuns];
        [lbFuns setFont:[UIFont systemFontOfSize:11]];
        [lbFuns setTextColor:[UIColor whiteColor]];
        [lbFuns setText:@"粉丝:"];
        
        lbFunsCount = [[UILabel alloc]init];
        [funsview addSubview:lbFunsCount];
        [lbFunsCount setFont:[UIFont systemFontOfSize:11]];
        [lbFunsCount setTextColor:[UIColor whiteColor]];
        [lbFunsCount setText:@"0"];
        
        ivPatient = [[UIImageView alloc]init];
        [patientview addSubview:ivPatient];
        [ivPatient setImage:[UIImage imageNamed:@"ic_main_patient"]];
        
        lbPatient = [[UILabel alloc]init];
        [patientview addSubview:lbPatient];
        [lbPatient setFont:[UIFont systemFontOfSize:11]];
        [lbPatient setTextColor:[UIColor whiteColor]];
        [lbPatient setText:@"用户:"];
        
        lbPatientCount = [[UILabel alloc]init];
        [patientview addSubview:lbPatientCount];
        [lbPatientCount setFont:[UIFont systemFontOfSize:11]];
        [lbPatientCount setTextColor:[UIColor whiteColor]];
        [lbPatientCount setText:@"0"];
        
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [funsview mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(160 * kScreenScale, self.height));
        make.height.equalTo(self);
        make.width.equalTo(@(self.width/2));
        make.top.equalTo(self);
        make.left.equalTo(self);
    }];
    
    [patientview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.width.equalTo(@(self.width/2));
        make.top.equalTo(self);
        make.right.equalTo(self.mas_right);
    }];
    
   [lbFunsCount mas_makeConstraints:^(MASConstraintMaker *make) {
       //make.height.mas_equalTo(@15);
       make.centerY.equalTo(funsview);
       make.right.mas_equalTo(funsview.mas_right).with.offset(-10);
   }];

    [lbFuns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.centerY.equalTo(funsview);
        make.right.equalTo(lbFunsCount.mas_left);
    }];
    
    [ivFuns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12 * kScreenScale, 11 * kScreenScale));
        make.centerY.equalTo(funsview);
        make.right.equalTo(lbFuns.mas_left).with.offset(-4);
    }];
    
    [ivPatient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 11));
        make.centerY.equalTo(patientview);
        make.left.equalTo(patientview).with.offset(10);
    }];
    
    [lbPatient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.centerY.equalTo(patientview);
        make.left.equalTo(ivPatient.mas_right).with.offset(4);
    }];

    [lbPatientCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@15);
        make.centerY.equalTo(patientview);
        make.left.mas_equalTo(lbPatient.mas_right);
    }];
}

- (void) setStaffInfo
{
    StaffInfo* staff = [UserInfoHelper defaultHelper].currentStaffInfo;
    [lbFunsCount setText:staff.fans];
}

- (void)setStaffPatientCount:(NSString*)patientCount
{
    [lbPatientCount setText:patientCount];
}

@end
