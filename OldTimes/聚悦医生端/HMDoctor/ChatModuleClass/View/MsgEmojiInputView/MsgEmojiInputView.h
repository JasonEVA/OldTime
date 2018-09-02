//
//  MsgEmojiInputView.h
//  Titans
//
//  Created by Wythe Zhou on 1/21/15.
//  Copyright (c) 2015 Remon Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MsgEmojiInputViewDelegate <NSObject>

- (void)MsgEmojiInputViewDelegate_SendMessage;

@end

@interface MsgEmojiInputView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id <UIKeyInput> delegateKeyInput;                   // 键盘的 delegate
@property (nonatomic, weak) id <MsgEmojiInputViewDelegate> delegateMsgSend;     // 发送消息的 delegate
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;    // PageControl
@property (nonatomic, strong) NSMutableArray *arrCollectionViews;   // Collection View 的数组
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;    // Collection View 的 FlowLayout
@property (nonatomic) NSInteger pageCount;           // 表情总页数
@property (nonatomic) NSInteger cellPerPageCount;    // 每页 cell 的个数
@property (nonatomic) NSInteger cellRow;             // cell 的行数
@property (nonatomic) NSInteger cellCol;             // cell 的列数
@property (nonatomic, copy) NSArray *emojiArray;
@end
