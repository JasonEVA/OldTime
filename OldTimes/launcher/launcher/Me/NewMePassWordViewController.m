//
//  NewMePassWordViewController.m
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMePassWordViewController.h"
#import "MePassWordOriginalTableViewCell.h"
//#import "MeNewPassWordTableViewCell.h"
#import "NewMeNewPassWordTableViewCell.h"
#import "MeVerifiedcodeTableViewCell.h"
#import "MeRevisedCodeRequest.h"
#import "UnifiedUserInfoManager.h"
#import "UIImage+Manager.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import <Masonry.h>

@interface NewMePassWordViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,BaseRequestDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSString *strOriginal;
@property (nonatomic, strong) NSString *strNew;
@property (nonatomic, strong) NSString *strConfirm;
@property (nonatomic, strong) NSString *strCheck;
@property (nonatomic) BOOL NumberisOK;

@end

@implementation NewMePassWordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_REVISE_CODE);
    UIColor * color = [UIColor blackColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view addSubview:self.tableview];
    [self CreateFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.NumberisOK = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Privite Methods
- (void)btnClickConfrim
{
    if (![self checkdata]) {
        return;
    }
    
    [self postLoading];
    
    MeRevisedCodeRequest *request = [[MeRevisedCodeRequest alloc] initWithDelegate:self];
    [request getShowID:[UnifiedUserInfoManager share].userShowID oldPassword:self.strOriginal newPassword:self.strNew];
}

- (void)GetValueWith:(UITextField *)textField string:(NSString *)string
{
    if (!string)
    {
        if (textField.tag == 99)
        {
            self.strOriginal = textField.text;
        }
        else if (textField.tag == 100)
        {
            self.strNew = textField.text;
        }
        else if (textField.tag == 101)
        {
            self.strConfirm = textField.text;
        }
        else
        {
            self.strCheck = textField.text;
        }
    }
    else
    {
        if (textField.tag == 99)
        {
            self.strOriginal = string;
        }
        else if (textField.tag == 100)
        {
            self.strNew = string;
        }
        else if (textField.tag == 101)
        {
            self.strConfirm = string;
        }
        else
        {
            self.strCheck = string;
        }
    }
    
}

- (void)CreateFrame
{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BOOL)checkdata
{
    if ([self.strNew isEqualToString:self.strConfirm] && self.NumberisOK)
    {
        [self postLoading];
        return YES;
    }
    else
    {
        if (![self.strNew isEqualToString:self.strConfirm])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(ME_KINDLY_WARN) message:LOCAL(ME_NEWPW_NOTTHESAME) delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil, nil];
            alertView.tag = 100;
            [alertView show];
        }
        else if (!self.NumberisOK)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(ME_KINDLY_WARN) message:LOCAL(ME_NEWPW_NOTASREQUIRED) delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil, nil];
            alertView.tag = 101;
            [alertView show];
        }
        return NO;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 60;
    }
    else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        return 90;
    }
    else
    {
        return 45;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //    if (section == 0)
    //    {
    //        return nil;
    //    }
    //    else
    //    {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,80)];
    view.backgroundColor = [UIColor clearColor]; // [UIColor grayBackground];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(13, 22, self.view.frame.size.width - 26, 45)];
    [btn setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
    
    [btn setTitle:LOCAL(ME_CONFIRM_REVISE) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClickConfrim) forControlEvents:UIControlEventTouchUpInside];
    
    btn.layer.cornerRadius = 5.0f;
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
        return 3;
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
            cell.lblTitle.text = LOCAL(ME_ORGINAL_PASSWORD);
            cell.tfdOriginal.delegate = self;
            cell.tfdOriginal.tag = 99;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            NewMeNewPassWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeNewPassWordTableViewCellID"];
            if (!cell)
            {
                cell = [[NewMeNewPassWordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MeNewPassWordTableViewCellID"];
            }
            cell.lblTitle.text = LOCAL(ME_NEW_PASSWORD);
            cell.tfdNewPassWord.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            MePassWordOriginalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MePassWordOriginalTableViewCellID"];
            if (!cell)
            {
                cell = [[MePassWordOriginalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MePassWordOriginalTableViewCellID"];
            }
            cell.lblTitle.text = LOCAL(ME_CONFIRM_PASSWORD);
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL haveLowercase = NO;
    BOOL haveUpercase = NO;
    BOOL haveNumber = NO;
    BOOL haveSpeacial = NO;
    BOOL MorethanFive = NO;
    NSMutableArray *arrStr = [[NSMutableArray alloc] init];
    
    NSString *strtextfield = [[NSString alloc] init];
    if (textField.tag == 100 || textField.tag == 99 ||textField.tag == 101)
    {
        if (range.length == 0)
        {
            strtextfield = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }
        else
        {
            strtextfield = [textField.text substringToIndex:([textField.text length] - 1)];
        }
        //        if (strtextfield.length > 16)
        //        {
        //            UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:LOCAL(ME_WARN) message:LOCAL(ME_PW_LESSTHAN16) delegate:self cancelButtonTitle:LOCAL(CERTAIN) otherButtonTitles:nil, nil];
        //            [Alert show];
        //            [self GetValueWith:textField string:nil];
        //            return NO;
        //        }
        //        else
        //        {
        [self GetValueWith:textField string:strtextfield];
        //        }
    }
    else
    {
        [self GetValueWith:textField string:strtextfield];
    }
    
    if (textField.tag == 100)
    {
        for(int i =0; i < [strtextfield length]; i++)
        {
            NSString *temp = [strtextfield substringWithRange:NSMakeRange(i, 1)];
            [arrStr addObject:temp];
        }
        NSPredicate *pre_Lowercase = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[a-z]"];
        NSPredicate *pre_Upercase = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[A-Z]"];
        NSPredicate *pre_Number = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[0-9]"];
        NSPredicate *pre_Speacial = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"\\*|\\(|\\)|&|\\%|\\$|\\¥|\\#|\\@|\\!|\\+|\\_|\\-|\\{|\\}|\\?|\\<|\\>|\\/|\\;|\\:|\\'|\"|\\[|\\]|\\||\\.|\\`|\\,|\\＝|\\~|\\￡|\\€|\\●"];
        for (int i = 0; i<arrStr.count; i++)
        {
            NSString *temp = [arrStr objectAtIndex:i];
            if ([pre_Lowercase evaluateWithObject:temp])
            {
                haveLowercase = YES;
            }
            if ([pre_Upercase evaluateWithObject:temp])
            {
                haveUpercase = YES;
            }
            if ([pre_Number evaluateWithObject:temp])
            {
                haveNumber = YES;
            }
            if ([pre_Speacial evaluateWithObject:temp])
            {
                haveSpeacial = YES;
            }
        }
        
        if (strtextfield.length >=5)
        {
            MorethanFive = YES;
        }
        
        NewMeNewPassWordTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        SecurityType type;
        NSInteger index = (NSInteger)haveNumber + (NSInteger)haveLowercase + (NSInteger)haveUpercase + (NSInteger)haveSpeacial;
        if (MorethanFive)
        {
            switch (index)
            {
                case 1:
                    type = SecurityType_Low;
                    break;
                case 2:
                    type = SecurityType_Middle;
                    break;
                case 3:
                    type = SecurityType_High;
                    break;
                case 4:
                    type = SecurityType_High;
                    break;
                default:
                    type = SecurityType_None;
                    break;
            }
        }
        else
        {
            if (index == 0)
            {
                type = SecurityType_None;
            }
            else
            {
                type = SecurityType_Low;
            }
            
        }
        
        [cell SetSecurityType:type];
//        cell.btnLowercase.selected = haveLowercase;
//        cell.btnUppercase.selected = haveUpercase;
//        cell.btnSpecialcase.selected = haveSpeacial;
//        cell.btnNumber.selected = haveNumber;
//        cell.btnMorethaneight.selected = MorethanEight;
        
//        if (haveLowercase && haveNumber && haveSpeacial && haveUpercase && MorethanFive)
//        {
        if (strtextfield.length > 0)
        {
            self.NumberisOK = YES;
        }
        else
        {
            self.NumberisOK = NO;
        }
        
//        }
        
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NewMeNewPassWordTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell SetSecurityType:SecurityType_None];
    return YES;
}

#pragma mark - baserequest delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount
{
    if ([response isKindOfClass:[MeRevisedCodeResponse class]])
    {
        [self RecordToDiary:@"修改密码成功"];
        [[UnifiedUserInfoManager share] savePassword:self.strConfirm];
        [self postSuccess:LOCAL(CHANGESUCCESS)];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage
{
    [self postError:errorMessage];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        MePassWordOriginalTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.tfdOriginal becomeFirstResponder];
    }
    else if (alertView.tag == 101)
    {
        NewMeNewPassWordTableViewCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.tfdNewPassWord becomeFirstResponder];
    }
}

#pragma mark - init
- (UITableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        if([_tableview respondsToSelector:@selector(setSeparatorColor:)])
        {
            [_tableview setSeparatorColor:[UIColor mtc_colorWithR:196 g:195 b:200]];
        }
        
    }
    return _tableview;
}


@end
