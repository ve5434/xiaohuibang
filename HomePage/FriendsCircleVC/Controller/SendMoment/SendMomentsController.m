//
//  SendMomentsController.m
//  XiaoHuiBang
//
//  Created by mac on 16/11/8.
//  Copyright © 2016年 消汇邦. All rights reserved.
//

// 发表动态编辑界面



#import "SendMomentsController.h"
#import "NSString+Extension.h"
#import "FromCameraController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height  // 屏高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width    // 屏宽


@interface SendMomentsController () <UITextViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource> {

    UITableView *_tableView;
    UITextView *_textView;  // 输入框
    
}

@end

@implementation SendMomentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建子视图
    [self _createSubView];
    [self _setNavigationBar];
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    _scrollView.delegate = self;

}

#pragma mark - 设置导航栏
- (void)_setNavigationBar {
    
    self.navigationController.navigationBar.translucent = NO;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.text = @"记录生活";
    title.font = [UIFont boldSystemFontOfSize:19];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelAction:)];
    cancelButton.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(sendAction:)];
    sendButton.tintColor = [UIColor colorWithRed:29/255.0 green:161/255.0 blue:243/255.0 alpha:1];
    sendButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:sendButton];

}

#pragma mark - 创建子视图
- (void)_createSubView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*.48)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [_backgroundView addSubview:_tableView];

}

#pragma mark - 导航栏按钮响应
// 取消按钮
- (void)cancelAction:(UIBarButtonItem *)button {
    
    // 先隐藏键盘，再dismiss
    [_textView endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        // 缓存动态编辑的状态
    }];
    
}
// 发布按钮
- (void)sendAction:(UIBarButtonItem *)button {
    if (button.enabled == NO) {
        return;
    }
    
    // 先隐藏键盘，再dismiss
    [_textView endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        // 开辟一个线程，并发布动态
    }];
    
}

#pragma mark - textView代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    // 先判断本地是否存有已经编辑过的状态
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    
    return YES;

}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEmpty]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

#pragma mark - scrollView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [_textView endEditing:YES];

}

#pragma mark - 表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:@"cellID"];
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*.3)];
        _textView.text = @"记录我的生活";
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.textColor = [UIColor lightGrayColor];
        _textView.delegate = self;
        [cell.contentView addSubview:_textView];
    } else if (indexPath.row == 1) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        cell.imageView.image = [UIImage imageNamed:@"icon_open"];
        cell.textLabel.text = @"谁可以看";
        cell.detailTextLabel.text = @"公开";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 2) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        cell.imageView.image = [UIImage imageNamed:@"icon_@"];
        cell.textLabel.text = @"提醒谁看";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 3) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        NSArray *array = @[@"icon_emoj", @"icon_album", @"icon_camera_b", @"icon_position"];
        float buttonWidth = kScreenWidth/4;
        for (int i = 0; i < 4; i++) {
            UIImage *image = [UIImage imageNamed:array[i]];
            float imageHeight = image.size.height;
            float imageWidth = image.size.width;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth*i + (buttonWidth - imageWidth)/2.0, (kScreenHeight*.06 - imageHeight)/2.0, imageWidth, imageHeight)];
            button.tag = 989 + i;
            [button addTarget:self action:@selector(moreOptionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:image forState:UIControlStateNormal];
            [cell.contentView addSubview:button];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return kScreenHeight*.3;
    } else {
        return kScreenHeight*.06;
    }

}

#pragma mark - 输入框下面按钮的点击响应
- (void)moreOptionButtonAction:(UIButton *)button {

    NSInteger num = button.tag - 989;
    if (num == 0) {
        NSLog(@"表情");
    } else if (num == 1) {
        NSLog(@"相册");
    } else if (num == 2) {
        [self presentViewController:[[FromCameraController alloc] init]
                           animated:YES
                         completion:nil];
    } else if (num == 3) {
        NSLog(@"定位");
    }

}






















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
