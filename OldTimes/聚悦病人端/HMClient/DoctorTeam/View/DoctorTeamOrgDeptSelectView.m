//
//  DoctorTeamOrgDeptSelectView.m
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DoctorTeamOrgDeptSelectView.h"

@interface DoctorTeamOrgDeptSelectCell ()
{
    UILabel* lbSelectName;
    UIImageView* ivArrow;
}


@end

@implementation DoctorTeamOrgDeptSelectCell

- (id) init
{
    self = [super init];
    if (self)
    {
        lbSelectName = [[UILabel alloc]init];
        [self addSubview:lbSelectName];
        [lbSelectName setFont:[UIFont font_30]];
        [lbSelectName setTextColor:[UIColor commonTextColor]];
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"doctor_icon_arrows_down"]];
        [self addSubview:ivArrow];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbSelectName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(lbSelectName.mas_right);
        make.right.lessThanOrEqualTo(self).with.offset(-5);
    }];
    
}

- (void) setSelectedName:(NSString*) selectname
{
    [lbSelectName setText:selectname];
}

@end

@interface DoctorTeamOrgDeptSelectView ()

@end

@implementation DoctorTeamOrgDeptSelectView

- (id) init
{
    self = [super init];
    if (self)
    {
        _orgSelectCell = [[DoctorTeamOrgDeptSelectCell alloc]init];
        [_orgSelectCell setSelectedName:@"全部医院"];
        [self addSubview:_orgSelectCell];
        [_orgSelectCell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.and.bottom.equalTo(self);
        }];
        
        _deptSelectCell = [[DoctorTeamOrgDeptSelectCell alloc]init];
        [_deptSelectCell setSelectedName:@"全部科室"];
        [self addSubview:_deptSelectCell];
        [_deptSelectCell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_orgSelectCell.mas_right);
            make.top.and.bottom.equalTo(self);
            make.right.equalTo(self);
            make.width.equalTo(_orgSelectCell);
        }];
        
        //[_deptSelectCell setBackgroundColor:[UIColor redColor]];
        
    }
    return self;
}
@end
