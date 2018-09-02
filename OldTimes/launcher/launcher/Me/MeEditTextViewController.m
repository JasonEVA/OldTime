//
//  MeEditTextViewController.m
//  launcher
//
//  Created by Kyle He on 15/9/30.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeEditTextViewController.h"
#import "MeReviseUserInformationRequest.h"
#import "UnifiedUserInfoManager.h"
#import "Category.h"
#import "MyDefine.h"


@interface MeEditTextViewController ()<UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate, UITextFieldDelegate>

@property(nonatomic, strong) UITableView  *tableview;
@property(nonatomic, strong) UITextField  *textField;
@property(nonatomic, copy) getTextWithBlock  textBlock;

@property (nonatomic, assign) BOOL isEdited;

@end

@implementation MeEditTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableview];
    self.title = self.cellTitle;
    [self showLeftItemWithSelector:@selector(backClick)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)backClick
{
    if (!self.isEdited) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    [self postLoading];
    if (self.textBlock) {
        self.textBlock(self.textField.text);
    }
    if ([self.title isEqualToString:LOCAL(ME_NAME)]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.myInfoModel.show_id, @"SHOW_ID",self.textField.text, @"U_TRUE_NAME",self.myInfoModel.u_mail, @"U_MAIL",self.myInfoModel.sqlu_dept_id, @"U_DEPT_ID",self.myInfoModel.u_job, @"U_JOB",nil];
        MeReviseUserInformationRequest *request = [[MeReviseUserInformationRequest alloc] initWithDelegate:self];
        [request ChangePersonInfoWithDict:dict];
    }
    else if ([self.title isEqualToString:LOCAL(ME_OFFICE)])
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.myInfoModel.show_id, @"SHOW_ID",self.myInfoModel.u_true_name, @"U_TRUE_NAME",self.myInfoModel.u_mail, @"U_MAIL",self.myInfoModel.sqlu_dept_id, @"U_DEPT_ID",self.textField.text,@"U_TELEPHONE",self.myInfoModel.u_job, @"U_JOB", nil];
        MeReviseUserInformationRequest *request = [[MeReviseUserInformationRequest alloc] initWithDelegate:self];
        [request ChangePersonInfoWithDict:dict];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Interface Method
- (void)getContextWithBlock:(getTextWithBlock)context
{
    self.textBlock  = context;
}

- (void)setData:(NSString *)string
{
    self.textField.text = string;
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.isEdited = YES;
    return YES;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *uID = @"MeEditTextViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:uID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:uID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = self.textField;
        cell.textLabel.font = [UIFont mtc_font_30];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = self.cellTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textField becomeFirstResponder];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[MeReviseUserInformationResponse class]])
    {
        [self postSuccess:LOCAL(CHANGESUCCESS)];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}


#pragma mark - Initializer
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview ;
}

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 44)];
        _textField.textAlignment = NSTextAlignmentRight;
        [_textField setDelegate:self];
		_textField.keyboardType = UIKeyboardTypePhonePad;
//        [_textField setEnabled:NO];
    }
    return _textField;
}

- (ContactPersonDetailInformationModel *)myInfoModel
{
    if (!_myInfoModel)
    {
        _myInfoModel = [[ContactPersonDetailInformationModel alloc] init];
    }
    return _myInfoModel;
}
@end
