//
//  PatientListLetterOrderAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientListLetterOrderAdapter.h"
#import "PatientListTableViewCell.h"
#import "NewPatientListInfoModel.h"
#import "DAOFactory.h"

static NSInteger kRloadTimes = 0; // 标记点击刷新次数，为1时筛选刷新

@interface PatientListLetterOrderAdapter ()

@property (nonatomic, strong)  NSMutableArray<NSString *>  *arrayIndexTitles; // <##>
@property (nonatomic, strong)  NSMutableArray  *arrayOriginData; // <##>
@property (nonatomic, copy)  void (^reloadCompletion)(); // <##>
@end

@implementation PatientListLetterOrderAdapter

- (void)reloadTableViewWithOriginData:(NSArray<NewPatientListInfoModel *> *)originData completion:(void (^)())completion {
    _reloadCompletion = completion;
    [self.arrayOriginData removeAllObjects];
    [self.arrayOriginData addObjectsFromArray:originData];
    [self p_configOrderDataWithSourceData:originData];
}

#pragma mark - Private Method

- (void)p_configOrderDataWithSourceData:(NSArray<NewPatientListInfoModel *> *)patients {
    kRloadTimes ++;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (kRloadTimes == 1) {
            [self.adapterArray removeAllObjects];
            [self.arrayIndexTitles removeAllObjects];
            UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
            // 得出collation索引的数量，这里是27个（26个字母和1个#）
            NSInteger sectionTitlesCount = [[collation sectionTitles] count];
            
            // 初始化一个数组newSectionsArray用来存放最终的数据
            NSMutableArray<NSMutableArray *> *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
            
            // 初始化27个空数组加入newSectionsArray
            for (NSInteger index = 0; index < sectionTitlesCount; index++) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [newSectionsArray addObject:array];
            }
            
            // 将每个人按name分到某个section下
            [patients enumerateObjectsUsingBlock:^(NewPatientListInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                // 获取name属性的值所在的位置// 系统方法很耗时
                NSInteger sectionNumber = [collation sectionForObject:obj collationStringSelector:@selector(userName)];
                NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
                [sectionNames addObject:obj];
                
            }];
            // 对每个section中的数组按照name属性排序,得到有数据的section，和title
            __weak typeof(self) weakSelf = self;
            [newSectionsArray enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:obj collationStringSelector:@selector(userName)];
                if (sortedPersonArrayForSection.count > 0) {
                    [strongSelf.adapterArray addObject:sortedPersonArrayForSection];
                    [strongSelf.arrayIndexTitles addObject:collation.sectionTitles[idx]];
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (kRloadTimes == 1) {
                [self.tableView reloadData];
                if (self.reloadCompletion) {
                    self.reloadCompletion();
                    _reloadCompletion = nil;
                }
            }
            kRloadTimes --;
        });
    });
}

- (void)p_postFollowDelegate:(BOOL)follow {
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(patientListLetterOrderAdapterDelegateCallBack_followStatus:)]) {
        [self.customDelegate patientListLetterOrderAdapterDelegateCallBack_followStatus:follow];
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientListTableViewCell class]) forIndexPath:indexPath];
    
    // Configure the cell...
    [cell configCellDataWithNewPatientListInfoModel:self.adapterArray[indexPath.section][indexPath.row]];
    return cell;
}

// Index

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.arrayIndexTitles.count > 0) {
        return self.arrayIndexTitles[section];
    }
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.arrayIndexTitles.count > 0) {
        return self.arrayIndexTitles;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.textLabel.font = [UIFont font_24];
    headerView.textLabel.textColor = [UIColor commonDarkGrayColor_666666];
}

// 为兼容iOS 8上侧滑效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewPatientListInfoModel *model = self.adapterArray[indexPath.section][indexPath.row];
__weak typeof(self) weakSelf = self;
    UITableViewRowAction *follow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 关注
        [_DAO.patientInfoListDAO updatePatientFollowStatus:YES patientID:model.userId completion:^(BOOL requestSuccess, NSString *errorMsg) {
            if (requestSuccess) {
                [strongSelf p_postFollowDelegate:YES];

                model.attentionStatus = 1;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }];
    follow.backgroundColor = [UIColor commonOrangeColor_ff8636];
    UITableViewRowAction *cancelFollow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 取消关注
        [_DAO.patientInfoListDAO updatePatientFollowStatus:NO patientID:model.userId completion:^(BOOL requestSuccess, NSString *errorMsg) {
            if (requestSuccess) {

                model.attentionStatus = 2;
                if (strongSelf.filterFollow) {
                    [strongSelf.arrayOriginData removeObject:model];
                    [strongSelf p_configOrderDataWithSourceData:strongSelf.arrayOriginData];
                }
                else {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                [strongSelf p_postFollowDelegate:NO];
            }
        }];
    }];
    cancelFollow.backgroundColor = [UIColor commonLightGrayColor_999999];
    return model.attentionStatus == 1 ? @[cancelFollow] : @[follow];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat tableViewOffsetY = scrollView.contentOffset.y;
    if ([self.customDelegate respondsToSelector:@selector(patientListLetterOrderAdapterDelegateCallBack_scrollViewDidScroll:)]) {
        [self.customDelegate patientListLetterOrderAdapterDelegateCallBack_scrollViewDidScroll:tableViewOffsetY];
    }
}

#pragma mark - Init

- (NSMutableArray<NSString *> *)arrayIndexTitles {
    if (!_arrayIndexTitles) {
        _arrayIndexTitles = [NSMutableArray array];
    }
    return _arrayIndexTitles;
}

- (NSMutableArray *)arrayOriginData {
    if (!_arrayOriginData) {
        _arrayOriginData = [NSMutableArray array];
    }
    return _arrayOriginData;
}
@end
