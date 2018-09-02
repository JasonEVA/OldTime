//
//  SESessionListSelectTypeView.m
//  HMDoctor
//
//  Created by jasonwang on 2017/9/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SESessionListSelectTypeView.h"
#import "SESessionSelectTypeTableViewCell.h"
#import "SESessionListEnmu.h"


@interface SESessionListSelectTypeView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) configClickBlock block;
@property (nonatomic, copy) cellClickBlock cellBlock;
@end


@implementation SESessionListSelectTypeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setClipsToBounds:YES];
        [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.2]];
        self.dataList = [SESessionListEnmu sessionTypeList];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark -private method
- (void)configElements {
}
#pragma mark - event Response
- (void)configClick {
    
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    [[NSUserDefaults standardUserDefaults] setValue:self.selectedArr forKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPELIST,user.userId]];
    
    if (self.block) {
        self.block(self.selectedArr);
    }
}
#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SESessionSelectTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SESessionSelectTypeTableViewCell at_identifier]];
    
    UserInfo* user = [[UserInfoHelper defaultHelper] currentUserInfo];
    NSArray *typeList = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"%@-%ld",SESESSIONTYPELIST,user.userId]];
    
    [cell fillDataWithTitelName:self.dataList[indexPath.row] unReadCount:[self.unReadArr[indexPath.row] integerValue] isSelected:[typeList containsObject:@(indexPath.row)]];
    
    [cell selectedClickBlock:^(BOOL selected) {
        if (selected) {
            [self.selectedArr addObject:@(indexPath.row)];
        }
        else {
            [self.selectedArr removeObject:@(indexPath.row)];
        }
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.cellBlock) {
        self.cellBlock(indexPath.row);
    }
}
#pragma mark - request Delegate

#pragma mark - Interface
- (void)selectedEndBlock:(configClickBlock)block {
    self.block = block;
}

- (void)clickCellBlock:(cellClickBlock)block {
    self.cellBlock = block;
}
#pragma mark - init UI
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setRowHeight:45];
        [_tableView setScrollEnabled:NO];
        [_tableView registerClass:[SESessionSelectTypeTableViewCell class] forCellReuseIdentifier:[SESessionSelectTypeTableViewCell at_identifier]];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        [footView setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *configBtn = [UIButton new];
        [configBtn setTitle:@"确定" forState:UIControlStateNormal];
        [configBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [configBtn.layer setCornerRadius:3];
        [configBtn setClipsToBounds:YES];
        
        [configBtn setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [configBtn addTarget:self action:@selector(configClick) forControlEvents:UIControlEventTouchUpInside];
        
        [footView addSubview:configBtn];
        [configBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footView);
            make.height.equalTo(@40);
            make.left.equalTo(footView).offset(15);
            make.right.equalTo(footView).offset(-15);
        }];
        
        [_tableView setTableFooterView:footView];
    }
    return _tableView;
}

- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}
@end
