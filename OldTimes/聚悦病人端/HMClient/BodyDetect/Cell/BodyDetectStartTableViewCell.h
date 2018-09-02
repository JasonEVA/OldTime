//
//  BodyDetectStartTableViewCell.h
//  HMClient
//
//  Created by lkl on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyDetectStartTableViewCell : UITableViewCell

- (void)setDetectName:(NSString *)name;
- (void)setDetectRecord:(NSString *)record;
- (void)setImageCode:(NSString *)code;

@end

@interface BodyDetectOtherStartTableViewCell : UITableViewCell

- (void)setDetectName:(NSString *)name;
- (void)setImageCode:(NSString *)code;

@end