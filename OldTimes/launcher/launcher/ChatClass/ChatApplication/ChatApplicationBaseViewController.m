//
//  ChatApplicationBaseViewController.m
//  launcher
//
//  Created by williamzhang on 16/5/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatApplicationBaseViewController.h"
#import "NewChatShowDateTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "JSONKitUtil.h"
#import "Category.h"
#import "MyDefine.h"

#define COUNT_MSG 20

@interface ChatApplicationBaseViewController () <UITableViewDelegate, UITableViewDataSource, MessageManagerDelegate>

@property (nonatomic, strong) UIButton    *titleButton;

// Data

/// 当前查看信息条数
@property (nonatomic, assign) NSInteger currentCount;
/// 上一次查看信息条数
@property (nonatomic, assign) NSInteger lastCount;
/// 记录是否第一次打开界面
@property (nonatomic, assign) BOOL isFirstShow;

@end

@implementation ChatApplicationBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentCount = COUNT_MSG;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self buttonTitle];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.titleButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.titleButton.mas_top);
    }];
    
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [[MessageManager share] setDelegate:self];
    [self getHistoryMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[MessageManager share] setDelegate:self];
    
    [self refreshView];
    [self sendReadMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MessageManager share] setDelegate:nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

#pragma mark - Private Method
- (void)getHistoryMessage {
    [[MessageManager share] getHistoryMessageWithUid:self.applicationUid MessageCount:self.currentCount];
}

- (void)refreshView {
    self.lastCount = [self.arrayDisplay count];
    MessageBaseModel *oldModel = [self.arrayDisplay lastObject];
    long long oldMsgId = oldModel._msgId;
    
    if (self.isFirstShow) {
        // 不是第一次打开
        
        BOOL isNewestMsgId = [[MessageManager share] queryMessageIsNewestWithTagert:self.applicationUid msgid:oldMsgId];
        if (!isNewestMsgId) {
            // 不是最新的，容量＋1
            self.currentCount += 1;
        }
    }
    
    [[MessageManager share] queryBatchMessageWithUid:self.applicationUid
                                        MessageCount:self.currentCount
                                          completion:^(NSArray<MessageBaseModel *> *arrayData)
    {
        [arrayData enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.appModel isAppSystemMessage]) {
                obj._type = msg_personal_alert;
            }
        }];
        
        _arrayDisplay = arrayData;
        [self.tableView reloadData];
        
        
        if ([self.arrayDisplay count]) {
            
            // 待滚动到的位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.arrayDisplay count] - 1 inSection:0];
            
            if ([self.tableView.header isRefreshing]) {
                // 下啦刷新，滚到原来的第一条
                indexPath = [NSIndexPath indexPathForRow:[self.arrayDisplay count] - self.lastCount inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
            else {
                if ([self isNeedScroll]) {
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }
        }
        
        [self.tableView.header endRefreshing];
    }];
}

- (BOOL)isNeedScroll {
    if (!self.isFirstShow) {
        self.isFirstShow = YES;
        return YES;
    }
    
    CGSize contentSize = self.tableView.contentSize;
    CGPoint offset = self.tableView.contentOffset;
    
    CGFloat distance = contentSize.height - offset.y - CGRectGetHeight(self.tableView.frame);
//    return distance > 350;     //滑动到最新消息处
    return distance <= 350; //有新消息列表不动
}

- (void)pullRefreshData {
    self.currentCount += COUNT_MSG;
    [self getHistoryMessage];
}

- (void)sendReadMessages {
    [[MessageManager share] sendReadedRequestWithUid:self.applicationUid messages:nil];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [self.arrayDisplay count]; }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = self.arrayDisplay[indexPath.row];
    
    if (model._type != msg_personal_alert) {
        return [self heightForMessageModel:model];
    }
    
    MessageAppModel *appModel = model.appModel;
    NSString *text = [IMApplicationUtil getMsgTextWithModel:appModel];
    
    if ([appModel.msgTransType isEqualToString:@"comment"]) {
        NSString *tmpString = [[appModel.msgInfo mtc_objectFromJSONString] objectForKey:@"comment"] ?: @"";
        if ([tmpString length]) {
            text = tmpString;
        }
    }
    
    NSString *filePath = [model.appModel.msgInfo mtc_objectFromJSONString][@"filePath"] ?: @"";
    
    CGFloat extraFloat = filePath.length > 0 ? 20 : 0;
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(IOS_SCREEN_WIDTH - 12.5 - 40 - 12 - 13 - 20 - extraFloat, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont mtc_font_26]} context:NULL].size;
    return size.height > 20 ? 165 : 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *model = self.arrayDisplay[indexPath.row];
    
    if (![model isEventType]) {
        NewChatShowDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatShowDateTableViewCell identifier]];
        [cell showDateAndEvent:model ifEvent:NO];
        return cell;
    }
    
    return [self cellForMessageModel:model withRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageBaseModel *model = self.arrayDisplay[indexPath.row];
    
    [self didSelectCellForMessageModel:model];
}

#pragma mark - Message Delegate
- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target {
    if (![target isEqualToString:self.applicationUid]) {
        return;
    }
    
    [self refreshView];
    [self sendReadMessages];
}

#pragma mark - 子类实现
- (NSString *)applicationUid { return nil; }
- (NSString *)buttonTitle { return nil; }
- (UIImage *)buttonImage { return nil; }
- (UIImage *)buttonHighlightedImage { return nil; }

- (void)clickedButton {}

- (CGFloat)heightForMessageModel:(MessageBaseModel *)model { return 0; }
- (UITableViewCell *)cellForMessageModel:(MessageBaseModel *)model { return nil; }
- (void)didSelectCellForMessageModel:(MessageBaseModel *)model {}

#pragma mark - 子类使用
- (void)tableViewRegisterClass:(Class)registerClass forCellReuseIdentifier:(NSString *)reuserIdentifier {
    [self.tableView registerClass:registerClass forCellReuseIdentifier:reuserIdentifier];
}

#pragma mark - Initializer
@synthesize tableView = _tableView;
- (UITableView *)tableView {
    if (!_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor grayBackground];
        
        [_tableView registerClass:[NewChatShowDateTableViewCell class] forCellReuseIdentifier:[NewChatShowDateTableViewCell identifier]];
        
        _tableView.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefreshData)];
    }
    return _tableView;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton new];
        
        NSString *title = [NSString stringWithFormat:@"%@%@", [self buttonTitle], LOCAL(LOOK)];
        
        [_titleButton setTitle:title forState:UIControlStateNormal];
        [_titleButton setImage:[self buttonImage] forState:UIControlStateNormal];
        [_titleButton setImage:[self buttonHighlightedImage] forState:UIControlStateHighlighted];
        
        _titleButton.titleLabel.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);
        [_titleButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
        
        [_titleButton.layer setBorderColor:[UIColor themeGray].CGColor];
        [_titleButton.layer setBorderWidth:0.4];
        
        [_titleButton addTarget:self action:@selector(clickedButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _titleButton;
}

@end
