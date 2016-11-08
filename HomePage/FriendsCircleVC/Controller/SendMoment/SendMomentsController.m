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

#define kScreenHeight [UIScreen mainScreen].bounds.size.height  // 屏高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width    // 屏宽


@interface SendMomentsController () <UITextViewDelegate, UIScrollViewDelegate> {


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
    
    _inputView.delegate = self;
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

    

}

#pragma mark - 导航栏按钮响应
// 取消按钮
- (void)cancelAction:(UIBarButtonItem *)button {
    
    // 先隐藏键盘，再dismiss
    [_inputView endEditing:YES];
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
    [_inputView endEditing:YES];
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

    [_inputView endEditing:YES];

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
