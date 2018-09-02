//
//  PersonServiceComplainHistoryTableViewCell.h
//  HMClient
//
//  Created by Dee on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonServiceComplainListModel;
@interface PersonServiceComplainHistoryTableViewCell : UITableViewCell

+ (NSString *)identifier;

- (void)setDataWithModel:(PersonServiceComplainListModel *)model;

@end
