//
//  FriendValidationViewController.m
//  launcher
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "FriendValidationViewController.h"
#import <Masonry/Masonry.h>
#import "TextViewTableViewCell.h"
#import "MyDefine.h"
#import <MintcodeIM/MintcodeIM.h>
#import "RelationListTableViewCell.h"
#import "RemarkViewController.h"
#import "UnifiedUserInfoManager.h"
#import "FriendValidRemarkCell.h"
#import "Category.h"

#define LoadFriendDataNotification @"loadFriendListDataNotification"
typedef NS_ENUM(NSInteger, CellType) {
    CellType_Name = 0,
    CellType_NoteName = 1,
    CellType_ValidationInfo = 10
};

@interface FriendValidationViewController ()<UITableViewDataSource,UITableViewDelegate,TextViewTableViewCellDelegate>


@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong)  MessageRelationInfoModel* model;
@property (nonatomic,strong) NSString * content ;// 验证信息
@property (nonatomic,strong) NSString * remark;// 备注
@property (nonatomic,copy) FriendValidationViewControllerBlock block;
@property(nonatomic, strong) TextViewTableViewCell*  Textcell;
@property(nonatomic, strong) UITableViewCell  *remarkCell;

@end

@implementation FriendValidationViewController

- (instancetype)initWithBlock:(FriendValidationViewControllerBlock)block
{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (_tableView)  {[self.remarkCell.detailTextLabel setText:self.remark];}
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LOCAL(FRIEND_VERIFY);
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem * liftBtnItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = liftBtnItem;
    UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(SEND) style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    [self.tableView reloadData];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sendClick
{
    [self.tableView endEditing:YES];
    
    [self postLoading];
    
    [[MessageManager share] addRelationValidateToUser:self.model.relationName
                                               remark:self.remark
                                              content:self.Textcell.textView.text
                                      relationGroupId:-1
                                           completion:^(BOOL success)
     {
         if (!success) {
             [self postError:LOCAL(ERROROTHER)];
             return;
         }
         
         !self.block ?: self.block(self.remark);
         
         [self postSuccess];
         [self performSelector:@selector(popAction) withObject:nil afterDelay:0.4];
    }];
}

- (void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setDataWithModel:(MessageRelationInfoModel *)model
{
    self.model = model;
    [self.tableView reloadData];
}

#pragma mark - TextViewTableViewCellDelegate
- (void)cellEndEditingWithStr:(NSString *)string
{
    self.content = string;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger path = indexPath.section *10 + indexPath.row;
    if (path == CellType_NoteName) {
        RemarkViewController * remarkVC = [[RemarkViewController alloc] initWithBlock:^(NSString *remark) {
            if (![remark isEqualToString:self.model.remark]) {
                self.remark = remark;
                [tableView reloadData];
            }
        } define:self.remark];
        [self.navigationController pushViewController:remarkVC animated:YES];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else {
        CGSize size = [LOCAL(FRIEND_VERIFY_WAIT) boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_26]} context:NULL].size;
        return MAX(55, size.height);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 73;
        }else {
            return 46;
        }
    }else {
        return 170;
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }else {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * name_identifier = @"name_identifier";
    static NSString * noteName_identifier = @"noteName_identifier";
    static NSString * ValidationInfo_identifier = @"ValidationInfo_identifier";
    
    UITableViewCell * cell;
    NSInteger path = indexPath.section *10 + indexPath.row;
    
    switch (path) {
        case CellType_Name:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:name_identifier];
            if (!cell) {
                cell = [[RelationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name_identifier cellType:CellType_userinfo_phone];
            }
            [(RelationListTableViewCell*)cell setCellDate:self.model];
        }
            break;
        case CellType_NoteName:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:noteName_identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:noteName_identifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = LOCAL(FRIEND_ADDREMARK);
            [cell.detailTextLabel setText:self.remark];
        }
            break;
            
        case CellType_ValidationInfo:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:ValidationInfo_identifier];
            if (!cell) {
                cell = [[TextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ValidationInfo_identifier];
                [(TextViewTableViewCell*)cell setDelegate:self];
            }
            self.Textcell = (TextViewTableViewCell *)cell;
            
            [(TextViewTableViewCell *)cell setPlaceholder:LOCAL(FRIEND_VERIFY_MESSAGE)];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont mtc_font_26];
    label.textColor = [UIColor cellTitleGray];
    label.text = LOCAL(FRIEND_VERIFY_WAIT);
    label.numberOfLines = 0;
    
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    return view;
}
#pragma mark - UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



@end
