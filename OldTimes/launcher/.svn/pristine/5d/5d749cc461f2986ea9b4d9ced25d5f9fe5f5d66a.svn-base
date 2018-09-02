//
//  MeReviseMailViewController.m
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeReviseMailViewController.h"
#import "MyDefine.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "MePassWordOriginalTableViewCell.h"
#import "MeVerifiedcodeTableViewCell.h"
#import "MeTextFieldTableViewCell.h"
#import "MeReviseUserInformationRequest.h"


@interface MeReviseMailViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) GetbackDataBlock getbackblock;
@property (nonatomic, strong) NSString *strloginPassWord;
@property (nonatomic, strong) NSString *strNewMail;
@property (nonatomic, strong) NSString *strCheckNo;
@end

@implementation MeReviseMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_CHANGE_MAIL);
    [self.view addSubview:self.tableview];
    [self CreateFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Privite Methods
- (void)btnClickConfrim
{
    if ([self CheckData])
    {
        [self postLoading];
        self.getbackblock(self.strNewMail);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.myInfoModel.show_id, @"SHOW_ID",self.myInfoModel.u_true_name, @"U_TRUE_NAME",self.strNewMail, @"U_MAIL",self.myInfoModel.sqlu_dept_id, @"U_DEPT_ID",self.myInfoModel.u_job, @"U_JOB", nil];
        MeReviseUserInformationRequest *request = [[MeReviseUserInformationRequest alloc] initWithDelegate:self];
        [request ChangePersonInfoWithDict:dict];
    }
}

- (void)CreateFrame
{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BOOL)CheckData
{
    if (self.strloginPassWord == nil || [self.strloginPassWord isEqualToString:@""])
    {
        UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:LOCAL(ME_KINDLY_WARN) message:LOCAL(ME_LOGIN_PW_NEED_EXIST) delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil, nil];
        AlertView.tag = 100;
        [AlertView show];
        return NO;
    }
    else if (self.strNewMail == nil || [self.strNewMail isEqualToString:@""])
    {
        UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:LOCAL(ME_KINDLY_WARN) message:LOCAL(ME_NEWMAIL_NEED) delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil, nil];
        AlertView.tag = 101;
        [AlertView show];
        return NO;
//    }else if (self.strCheckNo == nil || [self.strCheckNo isEqualToString:@""])
//    {
//        UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:LOCAL(ME_KINDLY_WARN) message:LOCAL(ME_CHECKCODE_NEED) delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil, nil];
//        AlertView.tag = 102;
//        [AlertView show];
//        return NO;
    } else
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:self.strNewMail])
        {
            return YES;
        }
        else
        {
            UIAlertView *AlertView = [[UIAlertView alloc] initWithTitle:LOCAL(ME_KINDLY_WARN) message:LOCAL(ME_INPUT_RIGHT_MAIL) delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil, nil];
            AlertView.tag = 103;
            [AlertView show];
            return NO;
        }
    }
}

- (void)setBlock:(GetbackDataBlock)block
{
    self.getbackblock = block;
}

#pragma mark tableviewdelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.01;
    }
    else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor]; //[UIColor grayBackground];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if (section == 0)
//    {
//        return nil;
//    }
//    else
//    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,75)];
        view.backgroundColor = [UIColor clearColor]; //[UIColor grayBackground];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, self.view.frame.size.width - 20, 40)];
        [btn setBackgroundColor:[UIColor themeBlue]];
        [btn setTitle:LOCAL(ME_CONFIRM_REVISE) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClickConfrim) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 2.0f;
        btn.clipsToBounds = YES;
        [view addSubview:btn];
        return view;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            MePassWordOriginalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MePassWordOriginalTableViewCellID"];
            if (!cell)
            {
                cell = [[MePassWordOriginalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MePassWordOriginalTableViewCellID"];
            }
            cell.lblTitle.text = LOCAL(ME_LOGIN_PW);
            cell.tfdOriginal.delegate = self;
            cell.tfdOriginal.tag = 100;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            MeTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeTextFieldTableViewCellID"];
            if (!cell)
            {
                cell = [[MeTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeTextFieldTableViewCellID"];
            }
            cell.lblTitle.text = LOCAL(ME_NEW_MAIL);
            cell.tfdOriginal.delegate = self;
            cell.tfdOriginal.tag = 101;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        MeVerifiedcodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeVerifiedcodeTableViewCellID"];
        if (!cell)
        {
            cell = [[MeVerifiedcodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeVerifiedcodeTableViewCellID"];
        }
        cell.lblTitle.text = LOCAL(ME_CHECK_CODE);
        cell.tfdVerify.delegate = self;
        cell.tfdVerify.tag = 102;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strtextfield = [[NSString alloc] init];
    if (range.length == 0)
    {
        strtextfield = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    else
    {
        strtextfield = [textField.text substringToIndex:([textField.text length] - 1)];
    }
    if (textField.tag == 100)
    {
        self.strloginPassWord = strtextfield;
    }
    else if (textField.tag == 101)
    {
        self.strNewMail = strtextfield;
    }
    else
    {
        self.strCheckNo = strtextfield;
    }
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        MePassWordOriginalTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.tfdOriginal becomeFirstResponder];
    }
    else if (alertView.tag == 101)
    {
        MeTextFieldTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.tfdOriginal becomeFirstResponder];
    }
    else if (alertView.tag == 102)
    {
        MeVerifiedcodeTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.tfdVerify becomeFirstResponder];
    }
    else if (alertView.tag == 103)
    {
        MeTextFieldTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.tfdOriginal becomeFirstResponder];
    }
}

#pragma mark - baserequest delegate
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

#pragma mark - init
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
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
