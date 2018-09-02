//
//  ApplicationCreateScheduleViewController.m
//  launcher
//
//  Created by williamzhang on 15/12/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCreateScheduleViewController.h"
#import "CalendarNewTimeDateSelectTableViewCell.h"
#import "CalendarNewTimeDaySelectTableViewCell.h"
#import "CalendarNewEventRemindViewController.h"
#import "NewCalendarAddNewEventViewController.h"
#import "CalendarTextFieldTableViewCell.h"
#import "CalendarLaunchrModel.h"
#import <DateTools/DateTools.h>
#import "CalendarNewRequest.h"
#import <Masonry/Masonry.h>
#import "UIView+Util.h"
#import "Category.h"
#import "MyDefine.h"
#import "NSString+HandleEmoji.h"
@interface ApplicationCreateScheduleViewController () <UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate>

@property (nonatomic, strong) UINavigationController *navigationVC;

@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) CalendarNewTimeDaySelectTableViewCell  *dayCell;
@property (nonatomic, strong) CalendarNewTimeDateSelectTableViewCell *dateCell;

@property (nonatomic, strong) NSString *placeTitle;
@property (nonatomic, assign) BOOL allDayMode;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) calendar_remindType remindType;

@end

@implementation ApplicationCreateNavigationController
@synthesize rootVC = _rootVC;
- (instancetype)init {
    ApplicationCreateScheduleViewController *rootViewController = [[ApplicationCreateScheduleViewController alloc] init];
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        _rootVC = rootViewController;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
}

@end

@implementation ApplicationCreateScheduleViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _startDate = [[NSDate date] mtc_calculatorMinuteIntervalDidChange:nil];
        _endDate = [self.startDate dateByAddingHours:1];
        _remindType = calendar_remindTypeEventNo;
        self.allDayMode = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *dissmissView = [UIView new];
    dissmissView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [dissmissView addGestureRecognizer:tap];

    [self.view addSubview:dissmissView];
    [dissmissView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(56, 5.5, 50, 5.5));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.doneButton];
	[self.contentView addSubview:self.cancelButton];
	
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(9);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-9.5);
        make.width.height.equalTo(@40);
    }];
	
	[self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.contentView).offset(9.5);
		make.centerY.equalTo(self.titleLabel);
		make.height.equalTo(@40);
	}];
	
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - Private Method
/// 合并model
- (CalendarLaunchrModel *)makeUpModel {
    CalendarLaunchrModel *model = [[CalendarLaunchrModel alloc] init];
    model.try_title = self.placeTitle;
    model.try_wholeDay = self.allDayMode;
    model.try_time = [NSMutableArray arrayWithObjects:self.startDate, self.endDate, nil];
    model.try_remindType = self.remindType;
	model.try_isVisible = YES;
    return model;
}

#pragma mark - Interface Method
- (void)handleDataWithNavigationController:(UINavigationController *)navigationController title:(NSString *)title completion:(void (^)())completion {
    //去除Emoji表情
	self.placeTitle = [title stringByRemovingEmoji];
    self.navigationVC = navigationController;
}

#pragma mark - Button Click
- (void)clickToDone {
    [self.view endEditing:YES];
    
    if (![self.placeTitle length]) {
        [self postError:LOCAL(MEETING_INPUT_TITLE)];
        return;
    }
    
    [self postLoading];
    CalendarNewRequest *newReuqest = [[CalendarNewRequest alloc] initWithDelegate:self];
    [newReuqest newCalendarModel:[self makeUpModel]];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickToMore {
    [self dismissViewControllerAnimated:YES completion:^{
        NewCalendarAddNewEventViewController *VC = [[NewCalendarAddNewEventViewController alloc] init];
        VC.noDeleteTryAction = YES;
        VC.modelCalendar = [self makeUpModel];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationVC pushViewController:VC animated:YES];
    }];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 1;}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 15;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [CalendarNewTimeDateSelectTableViewCell height];
    }
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    NSInteger section = indexPath.section;
    if (section == 0) {
        // 文字
        cell = [tableView dequeueReusableCellWithIdentifier:[CalendarTextFieldTableViewCell identifier]];
        [cell setTitle:self.placeTitle];
        __weak typeof(self) weakSelf = self;
        [cell textEndEditingBlock:^(NSString *text) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.placeTitle = text;
        }];
    } else if (section == 1) {
        cell = self.allDayMode ? self.dayCell : self.dateCell;
        [cell showAllDaySwitch];
        [cell setStartDate:self.startDate endData:self.endDate];
        __weak typeof(self) weakSelf = self;
        [cell setDeleteBlock:nil didChange:^(id cell, NSDate *firstDate, NSDate *lastDate) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.startDate = firstDate;
            strongSelf.endDate = lastDate;
			[weakSelf.view endEditing:YES];
			
        }];
        
    } else if (section == 2) {
        static NSString *identifier = @"disclosureIndicator";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell detailTextLabel].textColor = [UIColor minorFontColor];
            [cell detailTextLabel].font      = [UIFont mtc_font_30];
            [cell textLabel].textColor       = [UIColor blackColor];
            [cell textLabel].font            = [UIFont mtc_font_30];
            
            [cell textLabel].text = LOCAL(CALENDAR_ADD_NOTIFICATION);
        }
        
        [cell detailTextLabel].text = [CalendarLaunchrModel remindTypeStringAtIndex:self.remindType wholeDay:self.allDayMode];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section != 2) {
        return;
    }
    
    CalendarNewEventRemindViewController *VC = [[CalendarNewEventRemindViewController alloc] initWithWholeDayMode:self.allDayMode RemindType:^(NSInteger selectType) {
        self.remindType = selectType;
        [self.tableView reloadData];
    }];
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    [self postSuccess:@"" overTime:1.0];
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:1.0];
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
}

#pragma mark - Create
- (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *moreButton = [UIButton new];
    moreButton.titleLabel.font = [UIFont mtc_font_30];
    
    [moreButton setTitle:LOCAL(MISSION_MORE_CHOOSE) forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
    
    moreButton.expandSize = CGSizeMake(30, 5);
    
    [moreButton addTarget:self action:@selector(clickToMore) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
    }];
    
    return footerView;
}

#pragma mark - Initializer
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor buttonHighlightColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor mediumFontColor]];
        [_titleLabel setFont:[UIFont mtc_font_30]];
        [_titleLabel setText:LOCAL(CALENDAR_ADD_ADDORDER)];
    }
    return _titleLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton new];
		[_doneButton setTitle:LOCAL(CONFIRM) forState:UIControlStateNormal];
		[_doneButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
		 _doneButton.titleLabel.font = [UIFont mtc_font_30];
        [_doneButton addTarget:self action:@selector(clickToDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
	
}

- (UIButton *)cancelButton {
	if (!_cancelButton) {
		_cancelButton = [[UIButton alloc] init];
		[_cancelButton setTitle:LOCAL(CANCEL) forState:UIControlStateNormal];
		[_cancelButton setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
		_cancelButton.titleLabel.font = [UIFont mtc_font_30];
		[_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
		
	}
	
	return _cancelButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [self tableFooterView];
        
        [_tableView registerClass:[CalendarTextFieldTableViewCell class] forCellReuseIdentifier:[CalendarTextFieldTableViewCell identifier]];
    }
    return _tableView;
}

- (CalendarNewTimeDaySelectTableViewCell *)dayCell {
    if (!_dayCell) {
        _dayCell = [[CalendarNewTimeDaySelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_dayCell setTitle:LOCAL(CALENDAR_ADD_CHOOSETIME) showTrash:NO];
        [_dayCell showAllDaySwitch];
        __weak typeof(self) weakSelf = self;
        [_dayCell switchDay:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.allDayMode ^= 1;
            NSArray *arrayRemind = [CalendarLaunchrModel remindNumbersIsWholeDay:strongSelf.allDayMode];
            strongSelf.remindType = [[arrayRemind firstObject] integerValue];
            
            [strongSelf.tableView reloadData];
        }];
    }
    return _dayCell;
}

- (CalendarNewTimeDateSelectTableViewCell *)dateCell {
    if (!_dateCell) {
        _dateCell = [[CalendarNewTimeDateSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_dateCell setTitle:LOCAL(CALENDAR_ADD_CHOOSETIME) showTrash:NO];
        [_dateCell showAllDaySwitch];
        __weak typeof(self) weakSelf = self;
        [_dateCell switchDay:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.allDayMode ^= 1;
            NSArray *arrayRemind = [CalendarLaunchrModel remindNumbersIsWholeDay:strongSelf.allDayMode];
            strongSelf.remindType = [[arrayRemind firstObject] integerValue];
            
            [strongSelf.tableView reloadData];
        }];
    }
    return _dateCell;
}

@end