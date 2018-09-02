//
//  ServiceTeamSystemReminderView.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceTeamSystemReminderView.h"
#import "ServiceTeamMemberInfoView.h"

@interface ServiceTeamSystemReminderView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  ServiceTeamMemberInfoView  *teamView; // <##>
@property (nonatomic, strong)  UIView  *reminderTextBG; // <##>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  NSMutableArray  *dataSource; // <##>
@property (nonatomic)  NSInteger  oldDataCount; // <##>
@end
@implementation ServiceTeamSystemReminderView


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"dataSource"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dataSource"]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    self.backgroundColor = [UIColor mainThemeColor];
    [self addSubview:self.teamView];
    [self addSubview:self.reminderTextBG];
    [self.reminderTextBG addSubview:self.tableView];
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
    
    [self test];
}

// 设置约束
- (void)configConstraints {
    [self.teamView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(125);
    }];
    
    [self.reminderTextBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
        make.right.equalTo(self).offset(-24);
        make.bottom.equalTo(self).offset(-8);
        make.top.equalTo(self.teamView.mas_bottom);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.centerY.left.right.equalTo(self.reminderTextBG);
    }];
}

// 设置数据
- (void)configData {
    self.oldDataCount = 0;
    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (NSAttributedString *)configAttributedStringWithName:(NSString *)name content:(NSString *)content {

    
    NSDictionary *dictName = @{NSFontAttributeName : [UIFont font_30],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]};
    NSAttributedString *attName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：",name] attributes:dictName];
    
    NSDictionary *dictContent = @{NSFontAttributeName : [UIFont font_34],NSForegroundColorAttributeName : [UIColor mainThemeColor]};
    NSAttributedString *attContent = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",content] attributes:dictContent];

    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] init];
    [attriString appendAttributedString:attName];
    [attriString appendAttributedString:attContent];
    return attriString;
}

// setter
- (void)setMessage:(NSString *)message {
    _message = [message copy];
    [[self mutableArrayValueForKey:@"dataSource"] addObject:_message];
}


// 测试
- (void)test {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshTest) userInfo:nil repeats:YES];
    
}
// 测试
- (void)refreshTest {
    self.message = [NSDate date].description;
}

#pragma mark - Delegate

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.numberOfLines = 2;
        [cell.textLabel setTextColor:[UIColor mainThemeColor]];
        [cell.textLabel setFont:[UIFont font_34]];
        [cell.textLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.textLabel setAttributedText:[self configAttributedStringWithName:@"李大海" content:@"中午好！下午也要按时监测和吃药哦！有问题随时联系我，中午好！下午也要按时监测和吃药哦！有问题随时联系我"]];
    return cell;
}


#pragma mark - Init
- (ServiceTeamMemberInfoView *)teamView {
    if (!_teamView) {
        _teamView = [[ServiceTeamMemberInfoView alloc] initWithFlowLayout:nil itemSize:CGSizeMake(75, 110)];
    }
    return _teamView;
}

- (UIView *)reminderTextBG {
    if (!_reminderTextBG) {
        _reminderTextBG = [UIView new];
        _reminderTextBG.backgroundColor = [UIColor whiteColor];
        _reminderTextBG.layer.cornerRadius = 10.0;
        _reminderTextBG.clipsToBounds = YES;

    }
    return _reminderTextBG;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.pagingEnabled = YES;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
