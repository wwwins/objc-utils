//
//  BarcodeManager.h
//  ios7-qrcode
//
//  Created by wwwins on 2015/7/30.
//  Copyright © 2015年 wwwins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface BarcodeManager : NSObject <AVCaptureMetadataOutputObjectsDelegate>

@property BOOL isPaused;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, weak) UIView *previewView;

@property (nonatomic, copy) void (^completeBlock)(NSArray *result);

+ (BarcodeManager *)sharedManager;

- (void)startCapture:(UIView *)withView andComplete:(void (^)(NSArray *result))completeBlock;
//- (void)startCapture;
- (void)stopCapture;

@end
