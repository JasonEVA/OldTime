//
//  MDSDrugDetailViewController.m
//  MintmedicalDrugStore
//
//  Created by jasonwang on 16/7/27.
//  Copyright © 2016年 JasonWang. All rights reserved.
//

#import "MDSDrugDetailViewController.h"
#import <Masonry/Masonry.h>
#import "MDSDrugDetailTableViewCell.h"
#import "CoordinationFilterView.h"
//#import "MDSDrugReciprocityViewController.h"

#define W_MINHEIGHT 75   //最小高度
#define FOKEDATA          @"通用名：头孢\r商品名：优思明\n英文名：ajkdjalkdsjkjaljfk\nasdjklshfjkhakdljfhkjhdaskjhfjkdhasjkhfjh焚枯食淡可结案后付款就好撒大富科技号开始风口浪尖哈市的疯狂就困了就睡打开就分离开就撒旦；fjlkasjdflkjslkajfdlkj\n就付款了撒娇的开发就看见撒谎的付款就好房间看的撒娇风口浪尖啊上到会计法克里斯骄傲的弗兰克就上课了搭建费\n123"
@interface MDSDrugDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CoordinationFilterViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, strong)  CoordinationFilterView  *filterView; // <##>

@end

@implementation MDSDrugDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"药品详情"];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(taskAction)];
//     UIBarButtonItem *taskItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(taskAction)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];;
//    [self.navigationItem setLeftBarButtonItems:@[backBtn,closeBtn]];
    self.dataList = @[@"药品名称",@"适用症",@"用法用量",@"禁忌"];

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -private method
- (void)configElements {
}
- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:9];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    if ([self getRowHeightWithString:attributedString] == W_MINHEIGHT) {
        paragraphStyle.alignment = NSTextAlignmentRight;
    } else {
        paragraphStyle.alignment = NSTextAlignmentLeft;
    }
    
    return attributedString;
}
- (CGFloat)getRowHeightWithString:(NSMutableAttributedString *)content
{
    // 得到输入文字内容长度
    static MDSDrugDetailTableViewCell *templateCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [self.tableView dequeueReusableCellWithIdentifier:[MDSDrugDetailTableViewCell at_identifier]];
        if (!templateCell) {
            templateCell = [[MDSDrugDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MDSDrugDetailTableViewCell at_identifier]];
        }
    });
    templateCell.detailLb.attributedText = content;
    
    CGFloat height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    return MAX(W_MINHEIGHT, height + 10);
}

#pragma mark - event Response
- (void)taskAction {
    if (![self.view.subviews containsObject:self.filterView]) {
        [self.view addSubview:self.filterView];
        [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.filterView removeFromSuperview];
        _filterView = nil;
    }

}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)closeClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Delegate

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return self.dataList.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        MDSDrugDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MDSDrugDetailTableViewCell class])];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        [cell.titelLb setText:[NSString stringWithFormat:@"【%@】",self.dataList[indexPath.row]]];
        [cell.detailLb setAttributedText:[self getAttributedStringWithString:FOKEDATA]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        return cell;
    }
    else {
        //药物相互作用
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defoultCell"];
        [cell.textLabel setText:@"药物相互作用"];
        [cell.imageView setImage:[UIImage imageNamed:@"reciprocityIcon"]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!section) {
        return 0.001;
    }
    else {
        return 10;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return [self getRowHeightWithString:[self getAttributedStringWithString:FOKEDATA]];
    }
    else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section) {
//        MDSDrugReciprocityViewController *VC  = [MDSDrugReciprocityViewController new];
//        [self.navigationController pushViewController:VC animated:YES];
//    }
}
#pragma mark - CoordinationFilterViewDelegate
- (void)CoordinationFilterViewDelegateCallBack_ClickWithTag:(NSInteger)tag
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = 60;
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }

        [_tableView registerClass:[MDSDrugDetailTableViewCell class] forCellReuseIdentifier:[MDSDrugDetailTableViewCell at_identifier]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defoultCell"];
        [_tableView setEstimatedSectionHeaderHeight:0];
        [_tableView setEstimatedSectionFooterHeight:0];
    }
    return _tableView;
}
- (CoordinationFilterView *)filterView {
    if (!_filterView) {
        NSMutableArray *tagArr = [NSMutableArray array];
        for (int i = 0; i < self.dataList.count; i++) {
            [tagArr addObject:@(i)];
        }
        _filterView = [[CoordinationFilterView alloc] initWithImageNames:self.dataList titles:self.dataList tags:tagArr];
        _filterView.delegate = self;
    }
    return _filterView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
