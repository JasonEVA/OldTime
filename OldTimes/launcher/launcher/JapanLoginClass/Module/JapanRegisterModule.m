//
//  JapanRegisterModule.m
//  launcher
//
//  Created by williamzhang on 16/4/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanRegisterModule.h"
#import "BaseInputTableViewCell.h"
#import "Category.h"
#import "MyDefine.h"

#define HTTP_DOMAIN_PREFIX @"https://workhub.jp/a/"

@interface JapanRegisterModule ()

@property (nonatomic, strong) BaseInputTableViewCell *accountCell;
@property (nonatomic, strong) BaseInputTableViewCell *passwordCell;

@property (nonatomic, strong) BaseInputTableViewCell *teamNameCell;
@property (nonatomic, strong) BaseInputTableViewCell *teamDomainCell;
@property (nonatomic, strong) BaseInputTableViewCell *nameCell;

@end

@implementation JapanRegisterModule

- (instancetype)init {
    self = [super init];
    if (self) {
        self.essentialReason = YES;
    }
    return self;
}

- (void)setStep:(NSInteger)step {
    _step = step;
}

- (void)preStep {
    [self willChangeValueForKey:@"step"];
    _step -= 1;
    [self didChangeValueForKey:@"step"];
}

- (void)nextStep {
    if (_step >= 3) {
        return;
    };
    
    [self willChangeValueForKey:@"step"];
    _step += 1;
    [self didChangeValueForKey:@"step"];
}

@synthesize accountString = _accountString;
- (void)setAccountString:(NSString *)accountString {
    _accountString = accountString;
}

- (NSString *)navigationTitle {
    switch (self.step) {
        case 0:  return LOCAL(REGISTER_ACCOUNT);
        case 1:  return LOCAL(REGISTER_PASSWORD_SET);
        case 2:  return LOCAL(REGISTER_TEAM_CREATE);
        case 3:  return LOCAL(REGISTER_INFO_CONFIRM);
        default: return nil;
    }
}

- (NSString *)accountString { return _accountCell ? _accountCell.txtFd.text : _accountString; }
- (NSString *)password      { return self.passwordCell.txtFd.text; }

- (NSString *)teamName   { return self.teamNameCell.txtFd.text; }
- (NSString *)teamDomain { return self.teamDomainCell.txtFd.text; }
- (NSString *)name       { return self.nameCell.txtFd.text; }

- (NSInteger)tableViewRows {
    switch (self.step) {
        case 0: return 1;
        case 1: return 1;
        case 2: return 3;
        case 3: return 4;
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BaseInputTableViewCell identifier]];
    
    if (self.step == 0) {
        return self.accountCell;
    }
    else if (self.step == 1) {
        return self.passwordCell;
    }
    else if (self.step == 2) {
        switch (indexPath.row) {
            case 0: return self.teamNameCell;
            case 1: return self.teamDomainCell;
            case 2: return self.nameCell;
            default: return nil;
        }
    }
    else if (self.step == 3) {
        static NSString *identifer = @"normalCell";
        UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (!normalCell) {
            normalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifer];
            [normalCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            normalCell.textLabel.textAlignment = NSTextAlignmentLeft;
            normalCell.textLabel.font          = [UIFont mtc_font_26];
            normalCell.textLabel.textColor     = [UIColor mediumFontColor];
            
            normalCell.detailTextLabel.font      = [UIFont mtc_font_26];
            normalCell.detailTextLabel.textColor = [UIColor blackColor];
        }
        
        NSString *title    = @"";
        NSString *subTitle = @"";

        switch (indexPath.row) {
            case 0:
                title    = LOCAL(CONTACTBOOK_EMAIL);
                subTitle = self.accountString;
                break;
            case 1:
                title    = LOCAL(REGISTER_TEAM_ADDRESS);
                subTitle = [LOCAL(HTTP_DOMAIN_PREFIX) stringByAppendingString:self.teamDomain];
                break;
            case 2:
                title    = LOCAL(REGISTER_TEAM_NAME);
                subTitle = self.teamName;
                break;
            case 3:
                title    = LOCAL(ME_NAME);
                subTitle = self.name;
                break;
        }
        
        normalCell.textLabel.text = title;
        normalCell.detailTextLabel.text = subTitle;
        return normalCell;
    }
    
    
    return cell;
}

- (BOOL)checkEmailAccount {
    if (![self.accountString length]) {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.accountString];
}

#pragma mark - Button Click
- (void)clickToShowPassword:(UIButton *)button {
    button.selected ^= 1;
    self.passwordCell.txtFd.secureTextEntry = !button.selected;
}

#pragma mark - Create
- (UIButton *)showPasswordButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    
    [button setImage:[UIImage imageNamed:@"Login_eye_closed"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Login_eye_open"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickToShowPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Initializer
- (BaseInputTableViewCell *)accountCell {
    if (!_accountCell) {
        _accountCell = [[BaseInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _accountCell.textLabel.text = LOCAL(ME_MAIL);
        _accountCell.txtFd.placeholder = LOCAL(REGISTER_EMAIL);
        _accountCell.txtFd.font = [UIFont mtc_font_26];
    }
    return _accountCell;
}

- (BaseInputTableViewCell *)passwordCell {
    if (!_passwordCell) {
        _passwordCell = [[BaseInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _passwordCell.textLabel.text = LOCAL(REGISTER_PASSWORD);
        _passwordCell.txtFd.placeholder = LOCAL(REGISTER_PASSWORD_ERROR);
        _passwordCell.txtFd.secureTextEntry = YES;
        _passwordCell.txtFd.rightView = [self showPasswordButton];
        _passwordCell.txtFd.rightViewMode = UITextFieldViewModeAlways;
        _passwordCell.txtFd.font = [UIFont mtc_font_26];
    }
    return _passwordCell;
}

- (BaseInputTableViewCell *)teamNameCell {
    if (!_teamNameCell) {
        _teamNameCell = [[BaseInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        _teamNameCell.txtFd.placeholder = LOCAL(REGISTER_TEAMNAME_ERROR);
        _teamNameCell.txtFd.font = [UIFont mtc_font_26];
    }
    return _teamNameCell;
}

- (BaseInputTableViewCell *)teamDomainCell {
    if (!_teamDomainCell) {
        _teamDomainCell = [[BaseInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        _teamDomainCell.textLabel.text    = HTTP_DOMAIN_PREFIX;
        _teamDomainCell.txtFd.placeholder = LOCAL(REGISTER_TEAMDOMAIN_ERROR);
        _teamDomainCell.txtFd.font = [UIFont mtc_font_26];
    }
    return _teamDomainCell;
}

- (BaseInputTableViewCell *)nameCell {
    if (!_nameCell) {
        _nameCell = [[BaseInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _nameCell.txtFd.placeholder = LOCAL(REGISTER_NAME_ERROR);
        _nameCell.txtFd.font = [UIFont mtc_font_26];
    }
    return _nameCell;
}

@end
