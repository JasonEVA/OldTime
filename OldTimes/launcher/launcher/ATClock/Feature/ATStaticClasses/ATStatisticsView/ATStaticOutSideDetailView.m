//
//  ATStaticOutSideDetailView.m
//  Clock
//
//  Created by Dariel on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATStaticOutSideDetailView.h"
#import "ATStaticOutSideNoLocCell.h"
#import "ATStaticOutSideCell.h"

@interface ATStaticOutSideDetailView()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation ATStaticOutSideDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        self.detailTableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.detailTableView.dataSource = self;
        self.detailTableView.delegate = self;
        
        
        [self.detailTableView registerClass:[ATStaticOutSideNoLocCell class] forCellReuseIdentifier:@"ATStaticOutSideNoLocCell"];
        [self.detailTableView registerClass:[ATStaticOutSideCell class] forCellReuseIdentifier:@"ATStaticOutSideCell"];

        
        self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        [self addSubview:self.detailTableView];
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.staticOutSideModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (![self.staticOutSideModels[indexPath.row].Remark isEqualToString:@""]) {
        
        ATStaticOutSideCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATStaticOutSideCell"];
        cell.staticOutsideModel = self.staticOutSideModels[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else {
        ATStaticOutSideNoLocCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATStaticOutSideNoLocCell"];
        cell.staticOutsideModel = self.staticOutSideModels[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.staticOutSideModels[indexPath.row].cellHeight;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 判断是否要隐藏 topLineView
    if ([cell isKindOfClass:[ATStaticOutSideCell class]]) {
        ATStaticOutSideCell *celll = (ATStaticOutSideCell *)cell;
        indexPath.row == 0 ? celll.topLineView.hidden = YES : NO;

    }else {
        ATStaticOutSideNoLocCell *celll = (ATStaticOutSideNoLocCell *)cell;
        indexPath.row == 0 ? celll.topLineView.hidden = YES : NO;

    }
}




@end
