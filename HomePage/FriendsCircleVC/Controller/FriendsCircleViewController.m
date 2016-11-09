//
//  FriendsCircleViewController.m
//  XiaoHuiBang
//
//  Created by 消汇邦 on 2016/11/4.
//  Copyright © 2016年 消汇邦. All rights reserved.
//

#import "FriendsCircleViewController.h"
#import "SendMomentsController.h"
#import "FromCameraController.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height  // 屏高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width    // 屏宽

@interface FriendsCircleViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>



@end

@implementation FriendsCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    title.text = @"邦友圈";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
    
    // 发布动态按钮
    UIBarButtonItem *sendMomentsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_camera"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(sendMomentsAction:)];
    [self.navigationItem setRightBarButtonItem:sendMomentsButton];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 创建内容滑动视图
    [self _createContent];
    
}

#pragma mark - 发布动态
- (void)sendMomentsAction:(UIBarButtonItem *)button {
    
    UIView *virtualView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    virtualView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
    [self.view.window addSubview:virtualView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [virtualView addGestureRecognizer:tap];
    

    // 创建选项view，提供功能选着
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight , kScreenWidth, kScreenHeight*.3)];
    alertView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    alertView.tag = 1001;
    [virtualView addSubview:alertView];
    
    [UIView animateWithDuration:.35
                     animations:^{
                         alertView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight*.3);
                     }];
    
    float buttonHeight = (kScreenHeight*.3 - 10)/4.0;
    NSArray *titleArr = @[@"记录生活", @"视频/拍照", @"从手机相册选择", @"取消"];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 1500 + i;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1]] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
                     forState:UIControlStateNormal];
//        button.layer.borderWidth = 0.5;
//        button.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
        if (i == 0) {
            button.frame = CGRectMake(0, 0, kScreenWidth, buttonHeight);
        } else if (i == 1) {
            button.frame = CGRectMake(0, buttonHeight + 1, kScreenWidth, buttonHeight);
        } else if (i == 2) {
            button.frame = CGRectMake(0, buttonHeight*2 + 2, kScreenWidth, buttonHeight);
        } else {
            button.frame = CGRectMake(0, kScreenHeight*.3 - buttonHeight, kScreenWidth, buttonHeight);
        }
        [alertView addSubview:button];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }

}

// alert背景点击手势，移除alert
- (void)tapAction:(UITapGestureRecognizer *)tap {

    [UIView animateWithDuration:.35
                     animations:^{
                         [tap.view viewWithTag:1001].transform = CGAffineTransformMakeTranslation(0, kScreenHeight*.3);
                     } completion:^(BOOL finished) {
                         [tap.view removeFromSuperview];
                     }];
    

}

// alert按钮响应
- (void)buttonAction:(UIButton *)button {

    NSInteger buttonTag = button.tag - 1500;
    if (buttonTag == 0) {
        // push到编辑界面
        SendMomentsController *momentsController = [[SendMomentsController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:momentsController];
        nav.navigationBar.barTintColor = [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:48.0/255.0 alpha:1.0];
        [self presentViewController:nav animated:YES completion:nil];
        
        // 移除alert
        [UIView animateWithDuration:.35
                         animations:^{
                             [button.superview.superview viewWithTag:1001].transform = CGAffineTransformMakeTranslation(0, kScreenHeight*.3);
                         } completion:^(BOOL finished) {
                             [button.superview.superview removeFromSuperview];
                         }];
        
    } else if (buttonTag == 1) {
        // 通过摄像头
        [self presentViewController:[[FromCameraController alloc] init]
                           animated:YES
                         completion:nil];
        // 移除alert
        [UIView animateWithDuration:.35
                         animations:^{
                             [button.superview.superview viewWithTag:1001].transform = CGAffineTransformMakeTranslation(0, kScreenHeight*.3);
                         } completion:^(BOOL finished) {
                             [button.superview.superview removeFromSuperview];
                         }];

    } else if (buttonTag == 2) {
        // 从手机相册获取
        [self sendFromSystemPicture];
        // 移除alert
        [UIView animateWithDuration:.35
                         animations:^{
                             [button.superview.superview viewWithTag:1001].transform = CGAffineTransformMakeTranslation(0, kScreenHeight*.3);
                         } completion:^(BOOL finished) {
                             [button.superview.superview removeFromSuperview];
                         }];
    } else {
        // 移除alert
        [UIView animateWithDuration:.35
                         animations:^{
                             [button.superview.superview viewWithTag:1001].transform = CGAffineTransformMakeTranslation(0, kScreenHeight*.3);
                         } completion:^(BOOL finished) {
                             [button.superview.superview removeFromSuperview];
                         }];
    }

}

// 颜色转换成image
-(UIImage *)createImageWithColor:(UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 创建内容视图
- (void)_createContent {

    NSLog(@"在这里继续");

}

// 从手机相册选择
- (void)sendFromSystemPicture {

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - imagePicker代理方法
//已经选好照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //判断资源的来源 相册||摄像头
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        //取出照片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        // 返回照片
        
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //取出照片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        // 返回照片

    }
    
    //关闭,返回
    [picker dismissViewControllerAnimated:YES completion:nil];
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
