//
//  TaskAddNewTagViewController.m
//  launcher
//
//  Created by 马晓波 on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskAddNewTagViewController.h"
#import "TaskOnlyTextFieldTableViewCell.h"
#import "ProjectModel.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "Masonry.h"

@interface TaskAddNewTagViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation TaskAddNewTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建tag";
    
    UIBarButtonItem *btnLeft = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *btnRight = [[UIBarButtonItem alloc] initWithTitle:LOCAL(SAVE) style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    [self.navigationItem setLeftBarButtonItem:btnLeft];
    [self.navigationItem setRightBarButtonItem:btnRight];
    
    [self createFrames];

}

- (void)createFrames
{
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Button Click
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    if (![self checkInformation]) {
        return;
    }
    
    [self postLoading];
//    [VirtualManager createTag:[[ProjectModel alloc] initWithName:self.textField.text count:0]];
    [self performSelector:@selector(postSuccess) withObject:nil afterDelay:2.0];
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@NO afterDelay:2.5];
}

#pragma mark - Private Method
- (BOOL)checkInformation {
    if (![self.textField.text length]) {
        [self postError:LOCAL(MEETING_INPUT_TITLE)];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableView Delgate & DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskOnlyTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
    if (!cell) {
        cell = [[TaskOnlyTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[TaskOnlyTextFieldTableViewCell identifier]];
        cell.texfFieldTitle.delegate = self;
        self.textField = cell.texfFieldTitle;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - textfieldDelegate
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
