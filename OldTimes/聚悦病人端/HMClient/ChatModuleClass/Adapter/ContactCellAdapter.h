//
//  ContactCellAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  联系人CellAapter

#import "ATTableViewAdapter.h"

@interface ContactCellAdapter : ATTableViewAdapter

@property (nonatomic)  BOOL  selectable; // <##>
@property (nonatomic)  BOOL  singleSelect; // <##>
@property (nonatomic, copy)  NSArray  *sectionTitles; // <##>
@end
