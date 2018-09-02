//
//  ServiceTeamMembersViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceTeamMembersViewController.h"

@interface ServiceTeamMemberCell : UIControl
{
    UIImageView* ivStaff;
    UILabel* lbStaffName;
    
    UIImageView* ivLeader;
}

- (void) setStaffInfo:(StaffInfo*) staff;
@end

@implementation ServiceTeamMemberCell

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
        [lbStaffName setFont:[UIFont font_24]];
        [lbStaffName setTextColor:[UIColor colorWithHexString:@"F4F4F4"]];
        
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
    
    [ivLeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(ivStaff);
        make.height.mas_equalTo(@15);
        make.bottom.equalTo(ivStaff);
    }];
}

- (void) setStaffInfo:(StaffInfo*) staff
{
    [lbStaffName setText:staff.staffName];
    
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

@interface ServiceTeamMembersViewController ()
<TaskObserver>
{
    
    UIScrollView* scrollview;
    NSMutableArray* cells;
}
@end

@implementation ServiceTeamMembersViewController

- (void) loadView
{
    scrollview = [[UIScrollView alloc]init];
    [scrollview setBackgroundColor:[UIColor mainThemeColor]];
    [self setView:scrollview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self teamStaffItemLoaded:self.staffs];
}


- (void) teamStaffItemLoaded:(NSArray*) items
{
    NSMutableArray* staffItems = [NSMutableArray arrayWithArray:items];
    for (StaffInfo* staff in staffItems)
    {
        if (staff.staffId == self.teamStaffId)
        {
            [staffItems removeObject:staff];
            [staffItems insertObject:staff atIndex:0];
            break;
        }
    }
    
    [self setStaffs:[NSArray arrayWithArray:staffItems]];
    
    [self createStaffCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createStaffCells
{
    NSArray* subviews = [self.view subviews];
    for (UIView* sub in subviews)
    {
        [sub removeFromSuperview];
    }
    
    CGFloat cellWidth = [UIScreen mainScreen].applicationFrame.size.width/4;
    
    cells = [NSMutableArray array];
    for (NSInteger index = 0; index < _staffs.count; ++index)
    {
        StaffInfo* staff = _staffs[index];
        CGRect rtCell = CGRectMake(cellWidth * index, 0, cellWidth, scrollview.height);
        ServiceTeamMemberCell* cell = [[ServiceTeamMemberCell alloc]initWithFrame:rtCell];
        [scrollview addSubview:cell];
        [cells addObject:cell];
        
        [cell setStaffInfo:staff];
        [cell setIsTeamLeader:(staff.staffId == self.teamStaffId)];
        
        [cell addTarget:self action:@selector(teamStaffCellClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [scrollview setContentSize:CGSizeMake(cellWidth * _staffs.count, self.view.height)];
}

- (void) teamStaffCellClicked:(id) sender
{
    NSInteger clickedIndex = [cells indexOfObject:sender];
    if (NSNotFound == clickedIndex)
    {
        return;
    }
    
    StaffInfo* staff = _staffs[clickedIndex];
    //跳转到医生详情 StaffDetailViewController
    [HMViewControllerManager createViewControllerWithControllerName:@"StaffDetailViewController" ControllerObject:staff];

}

- (void) task:(NSString *)taskId Result:(id)taskResult
{
    if (!taskId || 0 == taskId.length)
    {
        return;
    }
    NSString* taskname = [TaskManager tasknameWithTaskId:taskId];
    if (!taskname || 0 == taskname.length)
    {
        return;
    }
    

}

@end
