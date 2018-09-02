//
//  AtStaffSelectViewController.m
//  HMClient
//
//  Created by yinqaun on 16/6/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AtStaffSelectViewController.h"
#import "AtStaffSelectTableViewCell.h"

@protocol AtStaffSelectTableViewSelectDelegate <NSObject>

- (void) staffSelected:(StaffInfo*) staff;

@end

@interface AtStaffSelectTableViewController : UITableViewController
{
    NSArray* staffs;
}
@property (nonatomic, weak) id<AtStaffSelectTableViewSelectDelegate> selectedDelegate;
- (id) initWithStaffList:(NSArray*) staffList;

@end

@interface AtStaffSelectViewController ()
<AtStaffSelectTableViewSelectDelegate>
{
    AtStaffSelectTableViewController* tvcSelect;
    
}
@property (nonatomic, strong) AtSelectStaffBlock selectblock;

- (id) initWithStaffList:(NSArray*) staffList;
@property (nonatomic, retain) NSArray* staffs;
@end



@implementation AtStaffSelectViewController

+ (void) showInParentController:(UIViewController*) parentController
                      StaffList:(NSArray*) staffList
             AtSelectStaffBlock:(AtSelectStaffBlock)block
{
    if (!parentController || !staffList)
    {
        return;
    }
    
    AtStaffSelectViewController* vcSelect = [[AtStaffSelectViewController alloc]initWithStaffList:staffList];
    [parentController addChildViewController:vcSelect];
    [vcSelect setSelectblock:block];
    [parentController.view addSubview:vcSelect.view];
    [vcSelect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
    
    [vcSelect setStaffs:staffList];
    
}

- (id) initWithStaffList:(NSArray*) staffList
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _staffs = staffList;
    }
    return self;
}

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc]init];
    [self setView:closeControl];
    [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [closeControl addTarget:self action:@selector(closeSelectController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_staffs)
    {
        [self createSelectTable];
    }
    
}

- (void) staffSelected:(StaffInfo *)staff
{
    if (_selectblock)
    {
        _selectblock(staff);
    }
    [self closeSelectController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeSelectController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) createSelectTable
{
    CGFloat tableHeight = 47 * _staffs.count;
    if (tableHeight >= 320)
    {
        tableHeight = 320;
    }
    
    tvcSelect = [[AtStaffSelectTableViewController alloc]initWithStaffList:_staffs];
    [self addChildViewController:tvcSelect];
    [self.view addSubview:tvcSelect.tableView];
    [tvcSelect.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
        make.height.mas_offset([NSNumber numberWithFloat:tableHeight]);
    }];
    
    [tvcSelect setSelectedDelegate:self];
}

@end

@implementation AtStaffSelectTableViewController

- (id) initWithStaffList:(NSArray*) staffList
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        staffs = staffList;
    }
    return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (staffs)
    {
        return staffs.count;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AtStaffSelectTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AtStaffSelectTableViewCell"];
    if (!cell)
    {
        cell = [[AtStaffSelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AtStaffSelectTableViewCell"];
    }
    
    StaffInfo* staff = staffs[indexPath.row];
    [cell setStaff:staff];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffInfo* staff = staffs[indexPath.row];
    if (_selectedDelegate && [_selectedDelegate respondsToSelector:@selector(staffSelected:)])
    {
        [_selectedDelegate staffSelected:staff];
    }
}
@end
