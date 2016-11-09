//
//  FromCameraController.m
//  XiaoHuiBang
//
//  Created by mac on 16/11/8.
//  Copyright © 2016年 消汇邦. All rights reserved.
//

#import "FromCameraController.h"

@interface FromCameraController ()
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;   // 视频标签
@property (weak, nonatomic) IBOutlet UILabel *pictureLabel; // 照片标签

@end

@implementation FromCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(swipeRightAction:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(swipeLeftAction:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeLeft];
}



























#pragma mark - 按钮响应
// 取消
- (IBAction)cancelButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 摄像头翻转
- (IBAction)switchCameraButton:(UIButton *)sender {
}
// 拍照
- (IBAction)cameraTouch:(UIButton *)sender {
    NSLog(@"拍照");
}
// 摄像

#pragma mark - 轻扫切换摄像跟拍照
- (void)swipeRightAction:(UISwipeGestureRecognizer *)swipe {

    [UIView animateWithDuration:.35
                     animations:^{
                         _movieLabel.transform = CGAffineTransformIdentity;
                         _pictureLabel.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         _movieLabel.textColor = [UIColor colorWithRed:29/255.0 green:161/255.0 blue:243/255.0 alpha:1];
                         _pictureLabel.textColor = [UIColor whiteColor];
                     }];

}

- (void)swipeLeftAction:(UISwipeGestureRecognizer *)swipe {
    
    [UIView animateWithDuration:.35
                     animations:^{
                         _movieLabel.transform = CGAffineTransformMakeTranslation(-40, 0);
                         _pictureLabel.transform = CGAffineTransformMakeTranslation(-40, 0);
                     } completion:^(BOOL finished) {
                         _movieLabel.textColor = [UIColor whiteColor];
                         _pictureLabel.textColor = [UIColor colorWithRed:29/255.0 green:161/255.0 blue:243/255.0 alpha:1];
                     }];
    
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
