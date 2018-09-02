//
//  CDASelectCommitDoctorViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CDASelectCommitDoctorViewController.h"
#import "StaffTeamDoctorModel.h"

@interface CDASelectCommitDoctorTableViewCell : UITableViewCell
{
    UILabel* staffNameLable;
    UIImageView* selectedImageViwe;
}

- (void) setIsSelected:(BOOL) isSelected;
- (void) setStaffTeamDoctorModel:(StaffTeamDoctorModel*) doctorModel;
@end

@implementation CDASelectCommitDoctorTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        staffNameLable = [[UILabel alloc]init];
        [self.contentView addSubview:staffNameLable];
        [staffNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        [staffNameLable setFont:[UIFont systemFontOfSize:15]];
        [staffNameLable setTextColor:[UIColor commonTextColor]];
        
        selectedImageViwe = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_select_blue"]];
        [self.contentView addSubview:selectedImageViwe];
        [selectedImageViwe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 13));
            make.right.equalTo(self.contentView).with.offset(-12.5);
        }];
        [selectedImageViwe setHidden:YES];
        
    }
    return self;
}

- (void) setStaffTeamDoctorModel:(StaffTeamDoctorModel*) doctorModel
{
    [staffNameLable setText:doctorModel.staffName];
}

- (void) setIsSelected:(BOOL) isSelected
{
    [selectedImageViwe setHidden:!isSelected];
}

@end

@interface CDASelectCommitDoctorTableViewController : UITableViewController
{
    
}
@property (nonatomic, readonly) NSArray* doctorModels;
@property (nonatomic, readonly) StaffTeamDoctorModel* selectedDoctorModel;
@end

@implementation CDASelectCommitDoctorTableViewController

- (id) initWithDoctorModels:(NSArray*) doctorModels
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        _doctorModels = doctorModels;
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.doctorModels)
    {
        return self.doctorModels.count;
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDASelectCommitDoctorTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CDASelectCommitDoctorTableViewCell"];
    if (!cell)
    {
        cell = [[CDASelectCommitDoctorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CDASelectCommitDoctorTableViewCell"];
    }
    StaffTeamDoctorModel* doctorModel = self.doctorModels[indexPath.row];
    [cell setStaffTeamDoctorModel:doctorModel];
    
    if (!_selectedDoctorModel)
    {
        [cell setIsSelected:NO];
    }
    else
    {
        [cell setIsSelected:(doctorModel == _selectedDoctorModel)];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StaffTeamDoctorModel* doctorModel = self.doctorModels[indexPath.row];
    _selectedDoctorModel = doctorModel;
    [self.tableView reloadData];
    
}

@end

@interface CDASelectCommitDoctorViewController ()
<TaskObserver>
{
    NSArray* doctorModels;
    UIView* selectDoctorView;
    
    CDASelectCommitDoctorTableViewController* tvcSelect;
}

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) CommitDoctorSelectedBlock commitDoctorSelectedBlock;

@end

@implementation CDASelectCommitDoctorViewController

- (void) loadView
{
    UIControl* closeControl = [[UIControl alloc]init];
    [self setView:closeControl];
    
    [closeControl setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    [closeControl addTarget:self action:@selector(closeController) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取团队成员 GetStaffTeamsTask
    [self.view showWaitView];
    StaffInfo* staff = [[UserInfoHelper defaultHelper]currentStaffInfo];
    NSMutableDictionary* dicPost = [NSMutableDictionary dictionary];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", staff.staffId] forKey:@"staffId"];
    [dicPost setValue:[NSString stringWithFormat:@"%ld", self.userId] forKey:@"userId"];
    [dicPost setValue:@"JD_3_REPORT" forKey:@"functionCode"];
    [[TaskManager shareInstance] createTaskWithTaskName:@"GetUserTeamStaffByFunctionCodeTask" taskParam:dicPost TaskObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void) showInParentController:(UIViewController*) parentController
                         userId:(NSInteger) userId
      commitDoctorSelectedBlock:(CommitDoctorSelectedBlock)block
{
    if (!parentController)
    {
        return;
    }
    
    CDASelectCommitDoctorViewController* vcSelect = [[CDASelectCommitDoctorViewController alloc]initWithNibName:nil bundle:nil];
    [parentController addChildViewController:vcSelect];
    [vcSelect setUserId:userId];
    [parentController.view addSubview:vcSelect.view];
    
    [vcSelect.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(parentController.view);
        make.top.and.bottom.equalTo(parentController.view);
    }];
    
    
    
    [vcSelect setCommitDoctorSelectedBlock:block];
}

- (void) closeController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void) confirmButtonClicked:(id) sender
{
    StaffTeamDoctorModel* doctorModel = tvcSelect.selectedDoctorModel;
    if (!doctorModel)
    {
        [self showAlertMessage:@"请选择需要提交的医生。"];
        return;
    }
    if (self.commitDoctorSelectedBlock)
    {
        self.commitDoctorSelectedBlock(doctorModel.userId);
    }
    [self closeController];
}

//创建医生选择列表
- (void) createSelectDoctorTable
{
    if (selectDoctorView)
    {
        return;
    }
    
    CGFloat viewHeight = 40 + 45;
    CGFloat tableHeight = 42 * doctorModels.count;
    viewHeight += tableHeight;
    if (viewHeight >= self.view.height -60)
    {
        viewHeight = self.view.height;
    }
    
    selectDoctorView = [[UIView alloc]init];
    [self.view addSubview:selectDoctorView];
    [selectDoctorView setBackgroundColor:[UIColor whiteColor]];
    selectDoctorView.layer.cornerRadius = 5;
    selectDoctorView.layer.masksToBounds = YES;
    
    [selectDoctorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([NSNumber numberWithFloat:viewHeight]);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).with.offset(12.5);
        make.right.equalTo(self.view).with.offset(-12.5);
    }];
    
    UILabel* titleLable = [[UILabel alloc]init];
    [selectDoctorView addSubview:titleLable];
    [titleLable setBackgroundColor:[UIColor whiteColor]];
    [titleLable setText:@"请选择提交给哪位医生"];
    [titleLable setTextColor:[UIColor commonGrayTextColor]];
    [titleLable setFont:[UIFont systemFontOfSize:14]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.equalTo(selectDoctorView);
        make.height.mas_equalTo(@40);
    }];
    
    
    UIView* buttonsView = [[UIView alloc]init];
    [selectDoctorView addSubview:buttonsView];
    [buttonsView setBackgroundColor:[UIColor whiteColor]];
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(selectDoctorView);
        make.height.mas_equalTo(@45);
    }];
    
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonsView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttonsView);
        make.top.and.bottom.equalTo(buttonsView);
    }];
    
    [cancelButton addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonsView addSubview:confirmButton];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelButton.mas_right);
        make.top.and.right.and.bottom.equalTo(buttonsView);
        make.right.equalTo(buttonsView);
        make.width.equalTo(cancelButton);
    }];
    
    [confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmButton showLeftLine];
    
    [buttonsView showTopLine];
    
    tvcSelect = [[CDASelectCommitDoctorTableViewController alloc]initWithDoctorModels:doctorModels];
    [self addChildViewController:tvcSelect];
    [selectDoctorView addSubview:tvcSelect.tableView];
    [tvcSelect.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(selectDoctorView);
        make.top.equalTo(titleLable.mas_bottom);
        make.bottom.equalTo(buttonsView.mas_top);
    }];
}

#pragma mark TaskObserver
- (void) task:(NSString*) taskId FinishError:(EStepErrorCode) taskError ErrorMessage:(NSString*) errorMessage
{
    [self.view closeWaitView];
    if (StepError_None != taskError)
    {
        [self showAlertMessage:errorMessage];
        [self closeController];
        return;
    }
    
    if (!doctorModels || 0 == doctorModels.count)
    {
        [self showAlertMessage:@"团队中没有医生。"];
        [self closeController];
        return;
    }
    [self createSelectDoctorTable];
}

- (void) task:(NSString *)taskId Result:(id) taskResult
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
    
    if ([taskname isEqualToString:@"GetUserTeamStaffByFunctionCodeTask"])
    {
        if (taskResult && [taskResult isKindOfClass:[NSArray class]])
        {
            doctorModels = (NSArray*) taskResult;
        }
    }
}
@end
