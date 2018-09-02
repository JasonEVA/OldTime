//
//  TeamStaffListView.m
//  HMClient
//
//  Created by yinqaun on 16/5/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "TeamStaffListView.h"

@interface TeamStaffListCell : UIControl
{
    UIImageView* ivStaff;
    UILabel* lbStaffName;
    UILabel* lbStaffType;
    UIImageView* ivLeader;
    //UILabel* lbLeader;
}

- (void) setStaffInfo:(StaffInfo*) staff;
@end

@implementation TeamStaffListCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ivStaff = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default_staff"]];
        [self addSubview:ivStaff];
        ivStaff.layer.borderWidth = 0.5;
        ivStaff.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        ivStaff.layer.cornerRadius = 25;
        ivStaff.layer.masksToBounds = YES;
        
        lbStaffName = [[UILabel alloc]init];
        [self addSubview:lbStaffName];
        [lbStaffName setFont:[UIFont font_30]];
        [lbStaffName setTextColor:[UIColor whiteColor]];
        
        lbStaffType = [[UILabel alloc]init];
        [self addSubview:lbStaffType];
        [lbStaffType setFont:[UIFont font_24]];
        [lbStaffType setTextColor:[UIColor colorWithHexString:@"F4F4F4"]];
        
        ivLeader = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_ggroup_leader"]];
        [ivStaff addSubview:ivLeader];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(ivStaff.mas_bottom).with.offset(4);
    }];
    
    [lbStaffType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(lbStaffName.mas_bottom).with.offset(4);
    }];
    
    [ivLeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(ivStaff);
        make.height.mas_equalTo(@15);
        make.bottom.equalTo(ivStaff);
    }];
    
}

- (void) setStaffInfo:(StaffInfo*) staff
{
    [lbStaffName setText:staff.staffName];
    [lbStaffType setText:staff.teamStaffTypeName];
    
    if (staff.imgUrl)
    {
        [ivStaff sd_setImageWithURL:[NSURL URLWithString:staff.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_default_staff"]];
    }
}

- (void) setIsTeamLeader:(BOOL) isTeamLeader
{
    [ivLeader setHidden:!isTeamLeader];
}

@end

@interface TeamStaffListView ()
{
    NSMutableArray* teamStaffs;
    NSInteger teamLeaderStaffId;
    
    NSMutableArray* cells;
}

@end


@implementation TeamStaffListView

- (void) setTeamStaffs:(NSArray*) staffs TeamStaffId:(NSInteger) teamStaffId
{
    teamStaffs = [NSMutableArray arrayWithArray:staffs];
    teamLeaderStaffId = teamStaffId;
    
    for (StaffInfo* staff in teamStaffs)
    {
        if (staff.staffId == teamStaffId)
        {
            //团队长
            [teamStaffs removeObject:staff];
            [teamStaffs insertObject:staff atIndex:0];
            break;
        }
    }
    
    [self createStaffCells];
}

- (void) createStaffCells
{
    NSArray* subviews = [self subviews];
    for (UIView* sub in subviews)
    {
        [sub removeFromSuperview];
    }
    
    CGFloat cellWidth = self.width/4;
    
    cells = [NSMutableArray array];
    for (NSInteger index = 0; index < teamStaffs.count; ++index)
    {
        StaffInfo* staff = teamStaffs[index];
        CGRect rtCell = CGRectMake(cellWidth * index, 0, cellWidth, self.height);
        TeamStaffListCell* cell = [[TeamStaffListCell alloc]initWithFrame:rtCell];
        [self addSubview:cell];
        [cells addObject:cell];
        
        [cell setStaffInfo:staff];
        [cell setIsTeamLeader:(staff.staffId == teamLeaderStaffId)];
        
        [cell addTarget:self action:@selector(teamStaffCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setContentSize:CGSizeMake(cellWidth * teamStaffs.count, self.height)];
}

- (void) teamStaffCellClicked:(id) sender
{
    NSInteger clickedIndex = [cells indexOfObject:sender];
    if (NSNotFound == clickedIndex)
    {
        return;
    }
    
    StaffInfo* staff = teamStaffs[clickedIndex];
    //跳转到医生详情 StaffDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"StaffDetailViewController" ControllerObject:staff];
}



@end
