//
//  BarcodeManager.m
//  ios7-qrcode
//
//  Created by wwwins on 2015/7/30.
//  Copyright © 2015年 wwwins. All rights reserved.
//

#import "BarcodeManager.h"

@implementation BarcodeManager

+ (id)sharedManager {
  static dispatch_once_t once;
  static id instance;
  dispatch_once(&once, ^{
    instance = [self new];
  });
  return instance;
}

- (id)init {
  if (self = [super init]) {
    NSError *error = nil;
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]){
      if([_device lockForConfiguration:&error]) {
        [_device setFocusPointOfInterest:CGPointMake(0.5f, 0.5f)];
        [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [_device unlockForConfiguration];
      }
      else{
        NSLog(@"configuration error");
      }
    }
    
  }
  return self;
}

- (void)startCapture:(UIView *)withView andComplete:(void (^)(NSArray *result))completeBlock {
  _previewView = withView;
  _completeBlock = completeBlock;
  [self startCapture];
}

- (void)startCapture {
  NSError *error = nil;
  _session = [[AVCaptureSession alloc] init];
  
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
  if ([_session canAddInput:input]) {
    [_session addInput:input];
  }
  else {
    NSLog(@"can not add input");
  }
  
  AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
  if([_session canAddOutput:output]){
    [_session addOutput:output];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // setMetadataObjectTypes must be call after addOutput
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
  }
  
  _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
  _captureVideoPreviewLayer.frame = _previewView.frame;
  _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  [_previewView.layer addSublayer:_captureVideoPreviewLayer];
  
  [_session startRunning];
  
}

- (void)stopCapture {
  [_captureVideoPreviewLayer removeFromSuperlayer];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    for (AVCaptureInput *input in _session.inputs) {
      [_session removeInput:input];
    }
    for (AVCaptureOutput *output in _session.outputs) {
      [_session removeOutput:output];
    }
    [_session stopRunning];
    _isPaused = NO;
    _completeBlock = nil;
    _session = nil;
    _captureVideoPreviewLayer = nil;
    
  });
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
  
  if(_isPaused)
    return;
  
  NSMutableArray *result = [[NSMutableArray alloc] init];
  NSString *qrcode = nil;
  for (AVMetadataObject *metadata in metadataObjects) {
    if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
      qrcode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
      NSLog(@"qrcode:%@",qrcode);
      [result addObject:qrcode];
      _isPaused = YES;
      _completeBlock(result);
      break;
    }
  }
  
}

@end
