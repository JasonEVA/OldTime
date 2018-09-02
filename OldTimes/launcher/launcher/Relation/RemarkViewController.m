//
//  RemarkViewController.m
//  launcher
//
//  Created by TabLiu on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RemarkViewController.h"
#import "MyDefine.h"

@interface RemarkViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITextField * textFiled;
@property (nonatomic,strong) RemarkViewControllerBlock block;
@property (nonatomic,strong) NSString * defineStr;
@end

@implementation RemarkViewController

- (instancetype)initWithBlock:(RemarkViewControllerBlock)block define:(NSString *)str
{
    self = [super init];
    if (self) {
        self.block = block;
        self.defineStr = str;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.title = LOCAL(FRIEND_ADDREMARK);
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:LOCAL(FINISH) style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)saveBtnClick
{
    [self.textFiled endEditing:YES];
    if (self.block) {
        self.block(self.textFiled.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ return 1; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string= @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        [cell.contentView addSubview:self.textFiled];
        self.textFiled.frame = CGRectMake(20, 0, IOS_SCREEN_WIDTH - 40, 50);
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; };
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 50; };
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 50; };


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UITextField *)textFiled
{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.placeholder = LOCAL(FRIEND_REMARK_PLEASE);
        _textFiled.text = self.defineStr;
    }
    return _textFiled;
}


@end
