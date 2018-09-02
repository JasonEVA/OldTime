//
//  NewCreatProjectViewController.m
//  launcher
//
//  Created by TabLiu on 16/2/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCreatProjectViewController.h"
#import "ProjectContentModel.h"
#import "ContactPersonDetailInformationModel.h"
#import "TaskTwoLabelsWithArrowTableViewCell.h"
#import "SelectContactBookViewController.h"
#import "TaskOnlyTextFieldTableViewCell.h"
#import "ProjectDetailRequest.h"
#import "ProjectCreateRequest.h"
#import "ProjectEditRequest.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"
//#import "NewEditingProjectViewController.h"

#import "NewProjectAddRequest.h"

@interface NewCreatProjectViewController ()<UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate, BaseRequestDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSMutableArray *editPerson;

@property (nonatomic, copy  ) ProjectContentModel   *editProject;
@property (nonatomic, copy  ) NSString       *editTitle;

@property (nonatomic, copy) void (^completionBlock)(ProjectContentModel *);
@property (nonatomic, copy) void (^editCompletionBlock)();

@end

@implementation NewCreatProjectViewController

- (instancetype)initWithProjectModel:(ProjectContentModel *)project completion:(void (^)())completion {
    self = [super init];
    if (self) {
        _editProject = project;
        _editCompletionBlock = completion;
    }
    return self;
}

- (instancetype)initWithCompletion:(void (^)(ProjectContentModel *))completion {
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
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)save {
    NSString * str =@"";
    str = _textField.text;
    [self creatProjectRequestWith:str people:self.editPerson];
}

- (void)creatProjectRequestWith:(NSString *)projectName people:(NSArray *)array
{
    NewProjectAddRequest * request2 = [[NewProjectAddRequest alloc] initWithDelegate:self];
    [request2 createProject:projectName people:array];
}


#pragma mark - Private Method

/** 获取分配组成的string */
- (NSMutableAttributedString *)personString {
    NSArray *array = _editPerson;
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
        SelectContactBookViewController *VC = [[SelectContactBookViewController alloc] initWithSelectedPeople:@[]];
        
        __weak typeof(self) weakSelf = self;
        [VC selectedPeople:^(NSArray *people) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.editPerson = [NSMutableArray arrayWithArray:people];
            [strongSelf.tableview reloadData];
        }];
        
        VC.selfSelectable = YES;
        [self presentViewController:VC animated:YES completion:nil];
    }
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    [self hideLoading];
    if ([request isKindOfClass:[NewProjectAddRequest class]]) {
        [self RecordToDiary:LOCAL(NEWMISSION_ADD_MISSION_FINISH)];
        NewProjectAddResponse * resp = (NewProjectAddResponse *)response;
        ProjectContentModel * model = [[ProjectContentModel alloc] init];
        model.showId = resp.showId;
        model.name = _textField.text;
        if (self.completionBlock) {
            self.completionBlock(model);
        }
        [self back];
        [self postSuccess];
    }
    
    else if ([request isKindOfClass:[ProjectDetailRequest class]]) {
        [self RecordToDiary:LOCAL(NEWMISSION_GET_MISSION_DETAIL_SUCCESS)];
    }
    
    else if ([request isKindOfClass:[ProjectEditRequest class]]) {
        [self RecordToDiary:LOCAL(NEWMISSION_EDIT_MISSION_FINISH)];
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
