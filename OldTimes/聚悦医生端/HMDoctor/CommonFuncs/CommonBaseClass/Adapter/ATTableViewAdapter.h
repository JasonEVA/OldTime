//
//  ATTableViewAdapter.h
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ATTableViewAdapterDelegate <NSObject>

@optional
- (void)didSelectCellData:(id)cellData index:(NSIndexPath *)indexPath;
- (void)deleteCellData:(id)cellData indexPath:(NSIndexPath *)indexPath;
@end

@interface ATTableViewAdapter : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)  UITableView  *tableView; // <##>
@property (nonatomic, strong)  NSMutableArray  *adapterArray; // 数据源
@property (nonatomic, weak)  id<ATTableViewAdapterDelegate>  adapterDelegate; // <##>
//将indexPath为转化为配合枚举的方法
- (NSUInteger)realIndexAtIndexPath:(NSIndexPath *)indexPath;
//将枚举转回indexPath
- (NSIndexPath *)indexPathForRealIndex:(NSInteger)realIndex;
//刷新某一行
- (void)reloadRealIndex:(NSInteger)realIndex;
@end
