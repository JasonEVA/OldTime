//
//  MissionSelectTagViewController.m
//  launcher
//
//  Created by William Zhang on 15/9/9.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionSelectTagViewController.h"
#import <Masonry/Masonry.h>
#import "ProjectModel.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface MissionSelectTagViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, copy) MissionSelectTagBlock selectBlock;


@property (nonatomic, strong) NSMutableDictionary *dictSelect;

@end

@implementation MissionSelectTagViewController

- (instancetype)initWithSelectTag:(MissionSelectTagBlock)selectBlock {
    self = [super init];
    if (self) {
        self.selectBlock = selectBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(SAVE) style:UIBarButtonItemStyleBordered target:self action:@selector(clickToSelect)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self testData];
}



- (void)testData {
//    self.tagArray = [VirtualManager tagArray];
    [self.tableView reloadData];
}



#pragma mark - Button Click
- (void)clickToSelect {
    if (self.selectBlock) {
        self.selectBlock([self.dictSelect allValues]);
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Interface Method
- (void)selectedTags:(NSArray *)tags {
    [self testData];
    
    if (!tags) {
        return;
    }
    for (ProjectModel *selectedTag in tags) {
        for (NSInteger i = 0; i < self.tagArray.count; i ++) {
            ProjectModel *tagTmp = [self.tagArray objectAtIndex:i];
            if (![selectedTag isEqual:tagTmp]) {
                continue;
            }
            
            [self.dictSelect setObject:tagTmp forKey:[NSIndexPath indexPathForItem:i inSection:1]];
            break;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return [self.tagArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if ([self.dictSelect objectForKey:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    NSString *text = LOCAL(NONE);
    
    if (indexPath.section != 0) {
        ProjectModel *project = [self.tagArray objectAtIndex:indexPath.row];
        text = project.name;
    }
    
    [cell textLabel].text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock && !indexPath.section) {
        self.selectBlock(nil);
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    // 多选模式
    if ([self.dictSelect objectForKey:indexPath]) {
        // 已存在，取消
        [self.dictSelect removeObjectForKey:indexPath];
    } else {
        ProjectModel *tagModel = [self.tagArray objectAtIndex:indexPath.row];
        [self.dictSelect setObject:tagModel forKey:indexPath];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (NSMutableArray *)tagArray {
    if (!_tableView) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

- (NSMutableDictionary *)dictSelect {
    if (!_dictSelect) {
        _dictSelect = [NSMutableDictionary dictionary];
    }
    return _dictSelect;
}

@end
