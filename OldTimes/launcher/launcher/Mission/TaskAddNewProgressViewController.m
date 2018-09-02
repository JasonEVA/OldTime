//
//  TaskAddNewProgressViewController.m
//  launcher
//
//  Created by 马晓波 on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskAddNewProgressViewController.h"
#import "ContactPersonDetailInformationModel.h"
#import "TaskTwoLabelsWithArrowTableViewCell.h"
#import "SelectContactBookViewController.h"
#import "TaskOnlyTextFieldTableViewCell.h"
#import "ProjectDetailRequest.h"
#import "ProjectCreateRequest.h"
#import "ProjectEditRequest.h"
#import <Masonry/Masonry.h>
#import "ProjectModel.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface TaskAddNewProgressViewController () <UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate, BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSMutableArray *editPerson;

@property (nonatomic, copy  ) ProjectModel   *editProject;
@property (nonatomic, copy  ) NSString       *editTitle;

@property (nonatomic, copy) void (^completionBlock)(ProjectModel *);
@property (nonatomic, copy) void (^editCompletionBlock)();

@end

@implementation TaskAddNewProgressViewController

- (instancetype)initWithProjectModel:(ProjectModel *)project completion:(void (^)())completion {
    self = [super init];
    if (self) {
        _editProject = project;
        _editCompletionBlock = completion;
    }
    return self;
}

- (instancetype)initWithCompletion:(void (^)(ProjectModel *))completion {
    self = [super init];
    if (self) {
        self.completionBlock = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.editProject ? LOCAL(MISSION_EDITPROJECT) : LOCAL(MISSION_NEWPROJECT);
    
    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:LOCAL(SAVE) style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    [self.navigationItem setLeftBarButtonItem:btnLeft];
    [self.navigationItem setRightBarButtonItem:btnRight];
    
    if (!self.editProject) {
        [self initComponents];
        return;
    }
    
    [self postLoading];
    ProjectDetailRequest *request = [[ProjectDetailRequest alloc] initWithDelegate:self];
    [request detailShowId:self.editProject.showId];
}

- (void)initComponents {
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Button Click
- (void)back {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)save {
    if (![self checkInformation]) {
        return;
    }
    
    [self postLoading];
    if (self.editProject) {
        ProjectEditRequest *editRequest = [[ProjectEditRequest alloc] initWithDelegate:self];
        [editRequest editProjectShowId:self.editProject.showId name:self.textField.text people:[self showArray]];
    }
    
    else {
        ProjectCreateRequest *createRequest = [[ProjectCreateRequest alloc] initWithDelegate:self];
        [createRequest createProject:self.textField.text people:self.editPerson];
    }
}

#pragma mark - Private Method
- (BOOL)checkInformation {
    if (![self.textField.text length]) {
        [self postError:LOCAL(MEETING_INPUT_TITLE)];
        return NO;
    }
    
    NSArray *array = self.editPerson ?: self.editProject.arrayMembers;
    if (![array count]) {
        [self postError:LOCAL(MEETING_INPUT_ATTENDERS)];
        return NO;
    }
    
    return YES;
}

- (NSArray *)showArray {
    return self.editPerson ?: self.editProject.arrayMembers;
}

/** 获取分配组成的string */
- (NSMutableAttributedString *)personString {
    NSArray *array = [self showArray];
    if (!array) {
        NSMutableAttributedString *allAttStr = [[NSMutableAttributedString alloc] initWithString:@""];
        return allAttStr;
    }
    
    NSString *string = @"";
    // 只拼接2个，其余＋n
    for (NSInteger i = 0; i < [array count]; i ++) {
        ContactPersonDetailInformationModel *personModel = [array objectAtIndex:i];
        if (i == 0) {
            string = personModel.u_true_name;
        } else {
            if (i == 1) {
                string = [string stringByAppendingFormat:@"、%@",personModel.u_true_name];
                break;
            }
        }
    }
    
    NSInteger count = array.count;
    if (count > 2) {
        string = [string stringByAppendingFormat:@" %@",LOCAL(APPLY_MORE)];
    }
    NSRange range = [string rangeOfString:LOCAL(APPLY_MORE)];
    NSMutableAttributedString *allAttStr = [[NSMutableAttributedString alloc] initWithString:string];
    [allAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor mtc_colorWithHex:0x2e9efb] range:range];
    return allAttStr;
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TaskOnlyTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
        if (!cell) {
            cell = [[TaskOnlyTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
            cell.texfFieldTitle.delegate = self;
            self.textField = cell.texfFieldTitle;
            cell.texfFieldTitle.text = self.editProject.name ?: @"";
        }
        return cell;
    }
    
    TaskTwoLabelsWithArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaskTwoLabelsWithArrowTableViewCell identifier]];
    if (!cell) {
        cell = [[TaskTwoLabelsWithArrowTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[TaskTwoLabelsWithArrowTableViewCell identifier]];
    }
    [cell lblTitle].text = LOCAL(MISSION_MEMBER);
    [cell lblContent].attributedText = [self personString];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        SelectContactBookViewController *VC = [[SelectContactBookViewController alloc] initWithSelectedPeople:[self showArray]];

        __weak typeof(self) weakSelf = self;
        [VC selectedPeople:^(NSArray *people) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.editPerson = [NSMutableArray arrayWithArray:people];
            [strongSelf.tableview reloadData];
        }];
        
        //VC.selfSelectable = NO;
        [self presentViewController:VC animated:YES completion:nil];
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    [self hideLoading];
    if ([request isKindOfClass:[ProjectCreateRequest class]]) {
        [self RecordToDiary:@"新建任务成功"];
        [self postSuccess];
        ProjectModel *project = [[ProjectModel alloc] init];
        project.name = self.textField.text;
        project.showId = [(id)response showId];
        
        !self.completionBlock ?: self.completionBlock(project);
        
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@NO afterDelay:1.0];
    }
    
    else if ([request isKindOfClass:[ProjectDetailRequest class]]) {
        [self RecordToDiary:@"获取任务详情成功"];
        ProjectModel *model = [(id)response project];
        self.editProject.arrayMembers = model.arrayMembers;
        [self initComponents];
    }
    
    else if ([request isKindOfClass:[ProjectEditRequest class]]) {
        [self RecordToDiary:@"编辑任务成功"];
        self.editProject.name = self.textField.text;
        !self.editCompletionBlock ?: self.editCompletionBlock();
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
    [self RecordToDiary:[NSString stringWithFormat:@"新建任务界面失败:%@",errorMessage]];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self save];
    return YES;
}

#pragma mark - init
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = [UIColor mtc_colorWithHex:0xf1f1f1];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}
@end
