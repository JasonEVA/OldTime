//
//  ChatRelationViewController.m
//  launcher
//
//  Created by williamzhang on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatRelationViewController.h"
#import "ChatRelationLeftTableViewCell.h"
#import <MintcodeIM/MintcodeIM.h>
#import <Masonry/Masonry.h>
#import "Category.h"
#import "UnifiedUserInfoManager.h"
#import "NewUserDetailViewController.h"
#import "ChatSingleViewController.h"
#import "ContactPersonDetailInformationModel.h"
@interface ChatRelationViewController () <UITableViewDataSource, UITableViewDelegate,ChatRelationLeftTableViewCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *relationVerifyArray;

@property(nonatomic, strong) MessageRelationValidateModel  *currentFriendInfoModel;

@end

@implementation ChatRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCAL(FRIEND_VERIFY);

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
    [[MessageManager share] sendReadedRequestWithUid:MTRelationSessionName messages:nil];
}

#pragma mark - override Method
- (void)changeLeftNumber {
    [[MessageManager share] queryUnreadMessageCountWithoutUid:MTRelationSessionName completion:^(NSInteger unreadCount) {
        [self leftItemNumber:unreadCount];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField * textField = [alertView textFieldAtIndex:0];
    NSString * str = textField.text;
    
    MessageRelationValidateModel *model = [self.relationVerifyArray objectAtIndex:alertView.tag];
    [self passRelationWithRemark:str MessageRelationValidateModel:model];
}
#pragma mark - ChatRelationLeftTableViewCellDelegate
- (void)ChatRelationLeftTableViewCell_SelectPassButtonWithCellPath:(NSIndexPath *)path
{
    MessageRelationValidateModel *model = self.relationVerifyArray[path.row];
    //数据库中查看是否存在好友
    if(![[MessageManager share] queryRelationInfoWithRelationGroup:0 userID:model.from])
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:LOCAL(MISSION_REMARK) message:nil delegate:self cancelButtonTitle:LOCAL(CONFIRM) otherButtonTitles:nil, nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * textField = [alertView textFieldAtIndex:0];
        textField.placeholder = LOCAL(FRIEND_REMARK_PLEASE);
        alertView.tag = path.row;
        [alertView show];
    }
}

//拒绝好友请求
- (void)ChatRelationLeftTableViewCell_SelectRefusedButtonWithCellPath:(NSIndexPath *)path
{
    
    __block MessageRelationValidateModel *model = [self.relationVerifyArray objectAtIndex:path.row];
    
    [self postLoading];
    [[MessageManager share] dealRelationWithModel:model validateState:3 relationGroupId:-1 remark:nil content:nil completion:^(BOOL isSuccess) {
        if (isSuccess) {
            // 返回列表页
            model.validateState = mt_relation_validateState_reject;
            [self.tableView reloadData];
        }
        
        else {
            [self postError:LOCAL(ERROROTHER)];
        }
    }];
}

//通过好友关系
- (void)passRelationWithRemark:(NSString *)remark MessageRelationValidateModel:(MessageRelationValidateModel *)model
{
    self.currentFriendInfoModel = model;
    [[MessageManager share] dealRelationWithModel:model validateState:2 relationGroupId:-1 remark:remark content:model.content completion:^(BOOL success) {
        if (success) {
            [self loadData];
            //将新天际的好友加到数据库里
            MessageRelationInfoModel *frinedModel = [[MessageRelationInfoModel alloc] init];
            frinedModel.remark = remark;
            frinedModel.relationName  = model.from;
            frinedModel.relationAvatar = model.fromAvatar;
            frinedModel.nickName = model.fromNickName;
            [[MessageManager share] insertRelationInfoWithArray:@[frinedModel]];
            // 跳转到聊天界面
            [self sendNotifyWithRemark:(NSString *)remark];
        }
    }];
}

- (void)sendNotifyWithRemark:(NSString *)remark {
    NSDictionary *dictContact = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.currentFriendInfoModel.from, personDetail_show_id,
                                 ![remark isEqualToString:@""]?remark:self.currentFriendInfoModel.fromNickName, personDetail_u_true_name,
                                 self.currentFriendInfoModel.fromAvatar, personDetail_headPic,
                                 nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWillShowSingleChatNotification object:nil userInfo:dictContact];
}


#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.relationVerifyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 0.01; }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 210; };

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatRelationLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChatRelationLeftTableViewCell identifier]];
    MessageRelationValidateModel *model = [self.relationVerifyArray objectAtIndex:indexPath.row];
    cell.deleagte = self;
    cell.indexPath = indexPath;
    MessageRelationInfoModel *friendModel = [[MessageManager share] queryRelationInfoWithUserID:model.from];
    if (friendModel)
    {
        model.fromNickName =  friendModel.remark;
    }
    
    [cell setCellDate:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    __weak typeof(self) weakSelf = self;
    [cell headViewClickBloc:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        MessageRelationInfoModel *infoModel = [MessageRelationInfoModel new];
        infoModel.relationName = model.from;
        
        MessageRelationInfoModel *tmpModel = [[MessageManager share] queryRelationInfoWithUserID:model.from];
        
        if (tmpModel) { infoModel = tmpModel; }
        NewUserDetailViewController *vc = [[NewUserDetailViewController alloc] initWithUserModel:infoModel];        
        [strongSelf.navigationController pushViewController:vc animated:YES];
    }];

    return cell;
}

#pragma mark - privateMethod
- (void)loadData
{
    [[MessageManager share] loadServerRelationValidateListCompletion:^(NSArray<MessageRelationValidateModel *> *validlist, BOOL success) {
        
        self.relationVerifyArray = [[validlist reverseObjectEnumerator] allObjects];
        [self.tableView reloadData];
        
        if ([self.relationVerifyArray count] == 0) {
            return;
        }
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.relationVerifyArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

#pragma mark - Initializer
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor grayBackground];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_tableView registerClass:[ChatRelationLeftTableViewCell class] forCellReuseIdentifier:[ChatRelationLeftTableViewCell identifier]];
    }
    return _tableView;
}

@end
