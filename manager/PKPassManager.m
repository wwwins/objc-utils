//
//  PKPassManager.m
//
//  Created by wwwins on 2014/8/7.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import "PKPassManager.h"

@implementation PKPassManager

@synthesize passLib = _passLib;

+ (id)sharedManager {
  static dispatch_once_t once;
  static id instance;
  dispatch_once(&once, ^{
    instance = [self new];
  });
  return instance;
}

- (id)init
{
  if (self = [super init])
  {
    _passLib = [[PKPassLibrary alloc] init];
    
    //check if pass library is available
    if (![PKPassLibrary isPassLibraryAvailable])
    {
      NSLog(@"The Pass Library is not available.");
    }
  }
  
  return self;
}


- (void)showPassByIndex:(int)index
{
  NSArray *passArray = [_passLib passes];
  PKPass *pass;
#if DEBUG
  if (passArray.count>0) {
    for (int i=0; i<passArray.count; i++) {
      pass = [passArray objectAtIndex:i];
      // passID:pass.com.isobar.HennessyVPass2014, passSN:b4oLIeN4CoeI
      NSLog(@"passID:%@, passSN:%@",pass.passTypeIdentifier,pass.serialNumber);
    }
#endif
    pass = [passArray objectAtIndex:index];
    [[UIApplication sharedApplication] openURL:pass.passURL];
  }
}

- (void)showPassBySerialNumber:(NSString *)sn
{
  NSArray *passArray = [_passLib passes];
  PKPass *pass;
  for (pass in passArray) {
    if ([pass.serialNumber isEqualToString:sn]) {
      NSLog(@"passID:%@, passSN:%@",pass.passTypeIdentifier,pass.serialNumber);
      break;
    }
  }
  [[UIApplication sharedApplication] openURL:pass.passURL];
  
}


@end
