//
//  CalendarEventRemindTimeCell.m
//  launcher
//
//  Created by Simon on 16/6/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "CalendarEventRemindTimeCell.h"
#import "UIFont+Util.h"

@implementation CalendarEventRemindTimeCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
	}
	
	return self;
	
}

- (void)setRemindTimeText:(NSString *)remindTime {
	NSAssert((![remindTime isEqualToString:@""]), @"setRemindTimeText never be nil or empty");
	
	self.textLabel.font = [UIFont mtc_font_28];
	self.textLabel.text = [NSString stringWithFormat:@"提醒时间: %@", remindTime];
}

@end
