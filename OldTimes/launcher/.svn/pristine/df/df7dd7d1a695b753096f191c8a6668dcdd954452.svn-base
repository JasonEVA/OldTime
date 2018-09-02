//
//  CalendarNewEventRemindViewController.m
//  launcher
//
//  Created by William Zhang on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CalendarNewEventRemindViewController.h"
#import "CalendarLaunchrModel.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface CalendarNewEventRemindViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) void (^remindBlock) (NSInteger);
@property (nonatomic, assign) BOOL wholeDay;

@end

@implementation CalendarNewEventRemindViewController

- (instancetype)initWithWholeDayMode:(BOOL)wholeDay RemindType:(void (^)(NSInteger))typeBlock {
    self = [super init];
    if (self) {
        self.remindBlock = typeBlock;
        self.wholeDay = wholeDay;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableView Delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.mySelectType) {
        if ([self.mySelectType isEqualToString:self.array[indexPath.row]]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    
    [cell textLabel].text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.remindBlock) {
        NSNumber *number = [[CalendarLaunchrModel remindNumbersIsWholeDay:self.wholeDay] objectAtIndex:indexPath.row];
        self.remindBlock([number integerValue]);
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)array {
    if (!_array) {
        _array = [CalendarLaunchrModel remindArrayWholeDay:self.wholeDay];
    }
    return _array;
}

@end
