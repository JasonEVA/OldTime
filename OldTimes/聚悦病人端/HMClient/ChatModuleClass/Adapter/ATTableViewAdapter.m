//
//  ATTableViewAdapter.m
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import "ATTableViewAdapter.h"

@implementation ATTableViewAdapter

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
        return self.adapterArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
        return ((NSArray *)self.adapterArray[section]).count;
    }
    return self.adapterArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorColor:[UIColor colorWithHexString:@"c8c7cc"]];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    [UIView performWithoutAnimation:^{
        [cell layoutIfNeeded];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cellData = nil;
    if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
        cellData = self.adapterArray[indexPath.section][indexPath.row];
    }
    else {
        cellData = [self.adapterArray objectAtIndex:indexPath.row];
    }
    
    UITableViewCell* cell = NULL;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"tableView:cellFor%@:", [cellData class]]);
    if ([self respondsToSelector:selector]) {
        cell = [self performSelector:selector withObject:tableView withObject:cellData];
    }
    else {
        selector = NSSelectorFromString([NSString stringWithFormat:@"tableView:cellForRowAtIndexPath:with%@:", [cellData class]]);
        NSMethodSignature *signature = [self methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        
        [invocation setSelector: selector];
        
        [invocation setTarget: self];
        //前两个参数为self与selector，其它参数要从2开始
        [invocation setArgument: &tableView  atIndex: 2];
        
        [invocation setArgument: &indexPath atIndex: 3];
        
        [invocation setArgument: &cellData  atIndex: 4];
        
        [invocation invoke];
        
        void *cellTemp;
        [invocation getReturnValue:&cellTemp];
        cell =  (__bridge UITableViewCell*)cellTemp;
    }
    
#pragma clang diagnostic pop
    
    return cell;
}

#pragma mark    UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    id cellData;
    if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
        cellData = self.adapterArray[indexPath.section][indexPath.row];
    }
    else {
        cellData = self.adapterArray[indexPath.row];
    }
    if (self.adapterDelegate) {
        if ([_adapterDelegate respondsToSelector:@selector(didSelectCellData:index:)]) {
            [_adapterDelegate didSelectCellData:cellData index:indexPath];
        }
    }
}

#pragma mark - private method
//将indexPath为转化为配合枚举的方法
- (NSUInteger)realIndexAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

//将枚举转回indexPath
- (NSIndexPath *)indexPathForRealIndex:(NSInteger)realIndex {
    return [NSIndexPath indexPathForItem:realIndex % 10 inSection:realIndex / 10];
}

//刷新某一行
- (void)reloadRealIndex:(NSInteger)realIndex {
    NSIndexPath *indexPathNeedReload = [self indexPathForRealIndex:realIndex];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathNeedReload] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Init

- (NSMutableArray *)adapterArray {
    if (!_adapterArray) {
        _adapterArray = [NSMutableArray array];
    }
    return _adapterArray;
}
@end
