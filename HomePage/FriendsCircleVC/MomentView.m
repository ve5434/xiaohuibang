//
//  MomentView.m
//  XiaoHuiBang
//
//  Created by mac on 16/11/7.
//  Copyright © 2016年 消汇邦. All rights reserved.
//

#import "MomentView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height  // 屏高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width    // 屏宽

@implementation MomentView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        // 设置灰度背景
        [self _setBackground];
        // 创建按钮
        [self _createButton];
    }
    return self;
    
}

- (void)_setBackground {
    
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    backView.alpha = 0;
    [self addSubview:backView];
    
    [UIView animateWithDuration:.35
                     animations:^{
                         backView.alpha = 1;
                     }];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [backView addGestureRecognizer:tap];
    
}

// 点击背景视图，移除本视图
- (void)tapAction:(UITapGestureRecognizer *)tap {

    [UIView animateWithDuration:.35 animations:^{
        tap.view.alpha = 0;
    }];
    [self removeFromSuperview];

}

- (void)_createButton {



}


@end
