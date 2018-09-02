//
//  SelectContactTabbarView.m
//  launcher
//
//  Created by williamzhang on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "SelectContactTabbarView.h"
#import "ContactDepartmentImformationModel+UserForSelect.h"
#import "ContactPersonDetailInformationModel.h"
#import "SelectContactCollectionViewCell.h"
#import "ContactBookGetDeptListRequest.h"
#import "UnifiedUserInfoManager.h"
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>
#import "ContactDefine.h"
#import "Category.h"
#import "MyDefine.h"


@interface SelectContactTabbarView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BaseRequestDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *buttonDone;

/** 仅供.m使用 */
@property (nonatomic, strong) NSMutableArray *arraySelect;

@property (nonatomic, strong) NSMutableDictionary *dictSelectInter;

@property (nonatomic, strong) ContactBookGetDeptListRequest *getDeptListRequest;

@property (nonatomic, copy) void (^completion)(NSArray *);

@property (nonatomic) NSInteger arraycount;

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

@end

@implementation SelectContactTabbarView

- (instancetype)initWithSelectPeople:(NSArray *)selectPeople unableSelectPeople:(NSArray *)unableSelectPeople completion:(void (^)(NSArray *))completion {
    self = [super init];
    if (self) {
        _arraySelect = [NSMutableArray arrayWithArray:selectPeople];
        _completion = completion;
        [self initData:selectPeople unableSelectPeople:unableSelectPeople];
        [self initComponents];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)initData:(NSArray *)selectPeople unableSelectPeople:(NSArray *)unableSelectPeople {
    self.dictSelectInter = [SelectContactUtil getShowIdDictionaryFromArray:selectPeople];
    _dictUnableSelected = [SelectContactUtil getShowIdDictionaryFromArray:unableSelectPeople];
}

- (void)initComponents {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self addSubview:self.buttonDone];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 12.5, 0, 0));
        make.right.equalTo(self.buttonDone.mas_left).offset(-10);
    }];
    
    [self.buttonDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12.5);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.width.greaterThanOrEqualTo(@70);
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    [line setBackgroundColor:[UIColor mtc_colorWithHex:0xebebeb]];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self setButtonCount];
    [self.getDeptListRequest requestData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Private Method
- (void)setButtonCount {
    NSInteger count = [self.arraySelect count];
    NSString *title = count ? [NSString stringWithFormat:LOCAL(CERTAIN_NUMBER), self.arraySelect.count] : LOCAL(CERTAIN);
    [self.buttonDone setTitle:title forState:UIControlStateNormal];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *keyboardInfo = notification.userInfo;
    
    double animateDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [[keyboardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    BOOL heightRefresh = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetMinY(endFrame) > 0;
    
    if (!self.superview) {
        return;
    }
    
    if (!self.bottomConstraint) {
        for (NSLayoutConstraint *constraint in [self.superview constraints]) {
            if (constraint.firstAttribute == NSLayoutAttributeBottom && constraint.firstItem == self) {
                self.bottomConstraint = constraint;
                break;
            }
        }
    }
    
    if (!self.bottomConstraint) {
        return;
    }
    
    CGFloat heightOffset = 0;
    if (heightRefresh) {
        heightOffset = -CGRectGetHeight(endFrame);
    }
    
    self.bottomConstraint.constant = heightOffset;
    [UIView animateWithDuration:animateDuration animations:^{
        [self.superview layoutIfNeeded];
        [self layoutIfNeeded];
    }];
}

- (void)addPeople:(NSArray *)people {
    if (![people count]) {
        return;
    }
    NSInteger originalCount = [self.arraySelect count];
    [self.arraySelect addObjectsFromArray:people];
    NSMutableArray *arrayIndexPathInsert = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [people count]; i ++) {
        [arrayIndexPathInsert addObject:[NSIndexPath indexPathForItem:i + originalCount inSection:0]];
        ContactPersonDetailInformationModel *model = [people objectAtIndex:i];
        [self.dictSelectInter setObject:@1 forKey:model.show_id];
    }
    
    [self.collectionView insertItemsAtIndexPaths:arrayIndexPathInsert];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.arraySelect count] - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    [self setButtonCount];
}

- (NSString *)modelShowId:(id)model {
    if ([model isKindOfClass:[ContactPersonDetailInformationModel class]]) {
        return [model show_id];
    }
    else if ([model isKindOfClass:[UserProfileModel class]]) {
        return [model userName];
    }
    else if ([model isKindOfClass:[MessageRelationInfoModel class]]) {
        return [model relationName];
    }
    
    return nil;
}

#pragma mark - Button Click

- (void)clickToDone {
    if (self.completion) {
        self.completion(self.arraySelect);
    }
}

#pragma mark - Interface Method 
- (void)addOrDeletePerson:(id)person {
    NSString *showId = [self modelShowId:person];
    NSAssert(showId, @"请使用正确的数据类型");
    
    if ([self.dictSelectInter objectForKey:showId]) {
        // 移除
        [self.arraySelect enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *tmpShowId = [self modelShowId:obj];
            
            if ([showId isEqualToString:tmpShowId]) {
                *stop = YES;
                
                [self.dictSelectInter removeObjectForKey:showId];
                [self.arraySelect removeObjectAtIndex:idx];
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
                [self setButtonCount];
            }
        }];
        return;
    }
    
    if (self.singleSelectable) {
        [self.dictSelectInter removeAllObjects];
        [self.arraySelect removeAllObjects];
        [self.dictSelectInter setObject:@1 forKey:showId];
        [self.arraySelect addObject:person];
        [self.collectionView reloadData];
        return;
    }
    
    [self.dictSelectInter setObject:@1 forKey:showId];
    [self.arraySelect addObject:person];
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:[self.arraySelect count] - 1 inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[insertIndexPath]];
    [self.collectionView scrollToItemAtIndexPath:insertIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    [self setButtonCount];
}

- (void)deletePeople:(NSArray *)people {
    NSMutableArray *arrayIndexPathDelete = [NSMutableArray array];
    
    NSMutableArray *arraySelectedNeedChanged = [NSMutableArray arrayWithArray:self.arraySelect];
    NSDictionary *dictSelect = [SelectContactUtil getShowIdDictionaryFromArray:people];
    for (NSInteger i = 0; i < [self.arraySelect count]; i ++) {
        ContactPersonDetailInformationModel *userModel = [self.arraySelect objectAtIndex:i];
        if (![dictSelect objectForKey:userModel.show_id]) {
            continue;
        }
        
        [arraySelectedNeedChanged removeObject:userModel];
        [self.dictSelectInter removeObjectForKey:userModel.show_id];
        [arrayIndexPathDelete addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    if (![arrayIndexPathDelete count]) {
        return;
    }
    
    self.arraySelect = arraySelectedNeedChanged;
    [self.collectionView deleteItemsAtIndexPaths:arrayIndexPathDelete];
    [self setButtonCount];
}

- (void)addOrDeleteDepartment:(ContactDepartmentImformationModel *)departmentModel contactsArray:(NSArray *)contactsArray{
    NSString *selectedDeptName = departmentModel.D_NAME;
     NSMutableArray *arrayChanged = [NSMutableArray array];
    if (departmentModel.isSelect) {
        // 添加人员组
        for (ContactPersonDetailInformationModel *userModel in contactsArray) {
            NSString *userShowID = userModel.show_id;
            if ([self.dictUnableSelected valueForKey:userShowID] || [self.dictSelected valueForKey:userShowID]) {
                continue;
            }
            
            if (![userModel.d_name containsObject:selectedDeptName]) {
                continue;
            }
            
            if ([userModel.show_id isEqualToString:[UnifiedUserInfoManager share].userShowID]) {
                continue;
            }
            
            
            // 没加入的人员需要加入
            [arrayChanged addObject:userModel];
        }
        [self addPeople:arrayChanged];
    }
    else {
        // 删除人员组
        for (ContactPersonDetailInformationModel *userModel in contactsArray) {
            NSString *userShowID = userModel.show_id;
            if (![self.dictSelected valueForKey:userShowID]) {
                continue;
            }
            
            if (![userModel.d_path_name containsObject:selectedDeptName]) {
                continue;
            }
            
            // 要删除的人员
            [arrayChanged addObject:userModel];
        }
        
        [self deletePeople:arrayChanged];
    }

}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arraySelect count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectContactCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SelectContactCollectionViewCell identifier] forIndexPath:indexPath];
   
    [cell setData:[self.arraySelect objectAtIndex:indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dictSelectInter removeObjectForKey:[self modelShowId:[self.arraySelect objectAtIndex:indexPath.row]]];
    [self.arraySelect removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    [self setButtonCount];
    self.arraycount = self.arraySelect.count;
}

#pragma mark - BaseRequest Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[ContactBookGetDeptListRequest class]]) {
        _arrayDepartments = [(id)response arrResult];
    }
}

#pragma mark - Getter
- (NSArray *)arraySelected {
    return self.arraySelect;
}

- (NSDictionary *)dictSelected {
    return self.dictSelectInter;
}

#pragma mark - Initializer
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(30, 30);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[SelectContactCollectionViewCell class] forCellWithReuseIdentifier:[SelectContactCollectionViewCell identifier]];
    }
    return _collectionView;
}

- (UIButton *)buttonDone {
    if (!_buttonDone) {
        _buttonDone = [UIButton new];
        [_buttonDone setTitle:LOCAL(CERTAIN) forState:UIControlStateNormal];
        [_buttonDone titleLabel].font = [UIFont systemFontOfSize:12];
        [_buttonDone setBackgroundImage:[UIImage mtc_imageColor:[UIColor themeBlue]] forState:UIControlStateNormal];
        _buttonDone.layer.cornerRadius = 3;
        _buttonDone.layer.masksToBounds = YES;
        [_buttonDone addTarget:self action:@selector(clickToDone) forControlEvents:UIControlEventTouchUpInside];
        [_buttonDone setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _buttonDone;
}

@synthesize arrayDepartments = _arrayDepartments;
- (NSArray *)arrayDepartments {
    if (![_arrayDepartments count]) {
        _arrayDepartments = @[];
        [self.getDeptListRequest requestData];
    }
    return _arrayDepartments;
}

- (ContactBookGetDeptListRequest *)getDeptListRequest {
    if (!_getDeptListRequest) {
        _getDeptListRequest = [[ContactBookGetDeptListRequest alloc] initWithDelegate:self];
    }
    return _getDeptListRequest;
}

@end
