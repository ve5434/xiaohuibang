//
//  QRCodeViewController.m
//  Food
//
//  Created by hisi on 15/10/22.
//  Copyright © 2015年 hisi. All rights reserved.
//

#import "QRCodeViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "AddFridensDataViewController.h"

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *sanFrameView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *lightButton;

@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResut;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.alpha = .7f;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_button setTitle:@"开始" forState:UIControlStateNormal];
    [_lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
    _lastResut = YES;
}

- (void)dealloc
{
    [self stopReading];
}


- (BOOL)startReading
{
    [_button setTitle:@"停止" forState:UIControlStateNormal];
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_sanFrameView.layer.bounds];
    [_sanFrameView.layer addSublayer:_videoPreviewLayer];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading
{
    [_button setTitle:@"开始" forState:UIControlStateNormal];
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResut) {
        return;
    }
    _lastResut = NO;
    
    NSDictionary *diccc = [MyTool toArrayOrNSDictionary:[result dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",XBaseURL,XUserQueryFriendsURL];
    
    NSDictionary *dic = @{
                          @"mobile":[diccc objectForKey:@"mobile"],
                          };
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    session.requestSerializer.timeoutInterval = 5.0;
    [session POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success:%@",responseObject);
        
        KMLog(@"%@",[MyTool dictionaryToJson:responseObject]);
        
        NSString *msgStr = [responseObject objectForKey:@"msg"];
        NSNumber *msg = (NSNumber *)msgStr;
        if ([msg isEqualToNumber:@1]) {
            
            AddFridensDataViewController *addFriendsDataVC = [[AddFridensDataViewController alloc] initWithUserData:[responseObject objectForKey:@"data"]];
            [self.navigationController pushViewController:addFriendsDataVC animated:YES];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"data"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        KMLog(@"Error:%@",error);
    }];
    
    // 以及处理了结果，下次扫描
    _lastResut = YES;
}

- (void)systemLightSwitch:(BOOL)open {
    if (open) {
        [_lightButton setTitle:@"关闭照明" forState:UIControlStateNormal];
    } else {
        [_lightButton setTitle:@"打开照明" forState:UIControlStateNormal];
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

#pragma AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
            NSLog(@"~~~:%@",result);
            
//            NSRange range = [result rangeOfString:@"{"];
//            NSString *subStr = [result substringFromIndex:range.location];
//            NSLog(@"jsonStr:%@",subStr);
//            
//            NSString *strUrl = [subStr stringByReplacingOccurrencesOfString:@";" withString:@","];
//            
//            NSDictionary *dic = [MyTool toArrayOrNSDictionary:[strUrl dataUsingEncoding:NSASCIIStringEncoding]];
//            NSLog(@"%@",dic);
//            
//            DishMenuViewController *dishMenuVC = [[DishMenuViewController alloc] initWithStoreDic:[dic objectForKey:@"s"]];
//            [self.navigationController pushViewController:dishMenuVC animated:YES];
        } else {
            NSLog(@"不是二维码");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (IBAction)startScanner:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"开始"]) {
        [self startReading];
    } else {
        [self stopReading];
    }
}

- (IBAction)openSystemLight:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"打开照明"]) {
        [self systemLightSwitch:YES];
    } else {
        [self systemLightSwitch:NO];
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
