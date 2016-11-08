//
//  SecondViewController.m
//  RongCloud
//
//  Created by Liv on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCDGroupViewController.h"
#import "AFHttpTool.h"
#import "DefaultPortraitView.h"
//#import "MBProgressHUD.h"
#import "MyChatConversationViewController.h"
#import "RCDGroupInfo.h"
#import "RCDGroupSettingsTableViewController.h"
#import "RCDGroupTableViewCell.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "UIColor+RCColor.h"
#import <UIImageView+WebCache.h>
#import <RongIMKit/RongIMKit.h>

#define DEFAULTS [NSUserDefaults standardUserDefaults]
#define ShareApplicationDelegate [[UIApplication sharedApplication] delegate]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface RCDGroupViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *groups;
//@property(nonatomic, strong) UILabel *noGroup;

@end

@implementation RCDGroupViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //设置为不用默认渲染方式
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_group"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_group_hover"]
                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置tableView样式
        self.tableView.separatorColor =
        [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
        self.tableView.tableFooterView = [UIView new];
        
        __weak RCDGroupViewController *weakSelf = self;
        
        _groups = [NSMutableArray
                   arrayWithArray:[[RCDataBaseManager shareInstance] getAllGroup]];
        if ([_groups count] > 0) {
            [weakSelf.tableView reloadData];
        }
        [RCDHTTPTOOL getMyGroupsListWithUserId:[USER_D objectForKey:@"user_id"]
                                         block:^(NSMutableArray *result) {
                                             dispatch_async(
                                                            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                                                NSMutableArray *tempGroups = [NSMutableArray
                                                                                              arrayWithArray:[[RCDataBaseManager shareInstance] getAllGroup]];
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    _groups = tempGroups;
                                                                    [weakSelf.tableView reloadData];
                                                                });
                                                            });
                                         }];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置为不用默认渲染方式
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_group"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_group_hover"]
                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UILabel *titleView = [[UILabel alloc]
                          initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:19];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"群组";
    self.tabBarController.navigationItem.titleView = titleView;
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groups.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDGroupInfo *groupInfo = _groups[indexPath.row];
    
    MyChatConversationViewController *temp = [[MyChatConversationViewController alloc] init];
    temp.targetId = groupInfo.groupId;
    
    NSLog(@"%@",groupInfo.groupId);
    
    temp.conversationType = ConversationType_GROUP;
//    temp.userName = groupInfo.groupName;
    temp.title = groupInfo.groupName;
    [self.navigationController pushViewController:temp animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *isDisplayID = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDisplayID"];
    static NSString *CellIdentifier = @"RCDGroupCell";
    RCDGroupTableViewCell *cell = (RCDGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[RCDGroupTableViewCell alloc]init];
    }
    RCDGroupInfo *group = _groups[indexPath.row];
    if ([isDisplayID isEqualToString:@"YES"]) {
        cell.lblGroupId.text = group.groupId;
    }
    [cell setModel:group];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RCDGroupTableViewCell cellHeight];
}

@end
