//
//  SearchListTableViewCell.h
//  launcher
//
//  Created by TabLiu on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageRelationInfoModel;

@protocol SearchListTableViewCellDelegate <NSObject>

- (void)SearchListTableViewCell_SelectButtonClick:(NSIndexPath *)indexPath;

@end

@interface SearchListTableViewCell : UITableViewCell

@property (nonatomic,strong) NSIndexPath * path;
@property (nonatomic,assign) id<SearchListTableViewCellDelegate> delegate;

- (void)setCellData:(MessageRelationInfoModel *)model serchText:(NSString *)searchText;

@end
