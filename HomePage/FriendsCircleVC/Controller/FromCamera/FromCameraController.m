//
//  FromCameraController.m
//  XiaoHuiBang
//
//  Created by mac on 16/11/8.
//  Copyright © 2016年 消汇邦. All rights reserved.
//

#import "FromCameraController.h"

@interface FromCameraController ()
@property (weak, nonatomic) IBOutlet UILabel *picLabel;   // 拍照标签
@property (weak, nonatomic) IBOutlet UILabel *movLabel; // 摄像标签

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
// 打开闪光灯
- (IBAction)openFlash:(UIButton *)sender {
    
    _isFlash = !_isFlash;
    if (_isFlash == YES) {
        [sender setImage:[UIImage imageNamed:@"icon_flash_open"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_flash_close"] forState:UIControlStateNormal];
    }
    
    
}

#pragma mark - 轻扫切换摄像跟拍照
- (void)swipeRightAction:(UISwipeGestureRecognizer *)swipe {

    [UIView animateWithDuration:.35
                     animations:^{
                         _picLabel.transform = CGAffineTransformIdentity;
                         _movLabel.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         _picLabel.textColor = [UIColor colorWithRed:29/255.0 green:161/255.0 blue:243/255.0 alpha:1];
                         _movLabel.textColor = [UIColor whiteColor];
                     }];

}

- (void)swipeLeftAction:(UISwipeGestureRecognizer *)swipe {
    
    [UIView animateWithDuration:.35
                     animations:^{
                         _picLabel.transform = CGAffineTransformMakeTranslation(-40, 0);
                         _movLabel.transform = CGAffineTransformMakeTranslation(-40, 0);
                     } completion:^(BOOL finished) {
                         _picLabel.textColor = [UIColor whiteColor];
                         _movLabel.textColor = [UIColor colorWithRed:29/255.0 green:161/255.0 blue:243/255.0 alpha:1];
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
