//
//  ContactsMainTableViewCell.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//  联系人主cell

#import <UIKit/UIKit.h>

@protocol ContactsMainTableViewCellDelegate <NSObject>

- (void)ContactsMainTableViewCellDelegateCallBack_clickedWithInnerCellData:(id)cellData indexPath:(NSIndexPath *)indexPath;

@end

typedef void (^selectContactBlock)(id contactData,NSInteger tag);

@interface ContactsMainTableViewCell : UITableViewCell

@property (nonatomic)  BOOL  selectable; // <##>
@property (nonatomic, weak)  id<ContactsMainTableViewCellDelegate>  delegate; // <##>

- (void)configContactCellData:(NSArray *)contactsData selectable:(BOOL)selectable singleSelect:(BOOL)singleSelect tag:(NSInteger)tag selectedContact:(selectContactBlock)block;

@end
