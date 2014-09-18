//
//  ApiManager.m
//
//  Created by wwwins on 2014/7/24.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import "ApiManager.h"
#import "AppConstants.h"

@interface ApiManager ()

@end

@implementation ApiManager

@synthesize enableMgm = _enableMgm;
@synthesize token = _token;
@synthesize sharedMessage = _sharedMessage;
@synthesize accountLevel = _accountLevel;

+ (id)sharedManager {
  static dispatch_once_t once;
  static id instance;
  dispatch_once(&once, ^{
    instance = [self new];
  });

  return instance;
}

+ (BOOL)isNetworkAvailableWithAlart
{
  if (![ApiManager isNetworkAvailable]) {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:TEXT_WITHOUT_NETWORK delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
    [alertview show];
    
    return NO;
  }
  return YES;
}

+ (BOOL)isNetworkAvailable
{
  char *hostname;
  struct hostent *hostinfo;
  hostname = "google.com";
  hostinfo = gethostbyname (hostname);
  if (hostinfo == NULL){
    return NO;
  }
  else{
    return YES;
  }
}

+ (BOOL)isMember
{
  return NO;
}

- (id)init
{
  if ((self = [super init])) {
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"Token"];
    NSString *level = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccountLevel"];
    if (token.length > 0) {
      _token = token;
      _accountLevel = level;
    }
    else {
      _token = @"";
      _accountLevel = @"Guest";
    }
  }
  return  self;
}

- (BOOL)isLogin
{
  if (_token.length > 0) {
    return YES;
  }
  return NO;
}

#pragma mark - URL encode

-(NSString *)encodeUrlString:(NSString *)string {
  return CFBridgingRelease(
                           CFURLCreateStringByAddingPercentEscapes(
                                                                   kCFAllocatorDefault,
                                                                   (__bridge CFStringRef)string,
                                                                   NULL,
                                                                   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                   kCFStringEncodingUTF8)
                           );
}

#pragma mark - lookup zip code for taiwan

- (NSString *)getZipCode:(NSString *)address
{
  NSString *zipCode = @"";
  
  if (address.length>0) {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",[self encodeUrlString:address]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];

    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    NSArray *arr = [result valueForKeyPath:@"results.address_components"];
    
    zipCode = [arr[0][3] valueForKeyPath:@"short_name"];
  }
  return zipCode;
  
}

#pragma mark - api

- (void)apiLogout
{
  if (![ApiManager isNetworkAvailableWithAlart])
    return;

  // for json
  self.responseSerializer = [AFJSONResponseSerializer serializer];
  
  [self POST:APPEND(VPASS_API_URL, @"logout.ashx") parameters:@{@"Token":_token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if ([[responseObject valueForKeyPath:@"Success"] boolValue]){
      _token = @"";
      _accountLevel = @"Guest";
      
      [[NSUserDefaults standardUserDefaults] setObject:_token forKey:@"Token"];
      [[NSUserDefaults standardUserDefaults] setObject:@"Guest" forKey:@"AccountLevel"];
      [[NSUserDefaults standardUserDefaults] synchronize];

      dispatchEvent(@"apiLogoutSuccess", nil);
      
    }
    else {
      UIAlertView *uialertview = [[UIAlertView alloc] initWithTitle:@"系統訊息" message:[responseObject valueForKeyPath:@"Message"] delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
      [uialertview show];
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
  }];

}

- (void)apiRegisterWithEmail:(NSString *)email withPhone:(NSString *)phone andComplete:(void (^)(NSError *error))aBlock
{
  // for json
  self.responseSerializer = [AFJSONResponseSerializer serializer];
  
  [self POST:APPEND(VPASS_API_URL, @"register.ashx") parameters:@{@"Email":email, @"Mobile":phone} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    trace(@"register:%@",responseObject);
    if ([[responseObject valueForKeyPath:@"Success"] boolValue]){
      dispatchEvent(@"NextPageForStartRegistration", nil);
      [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"Email"];
      [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"Phone"];
      [[NSUserDefaults standardUserDefaults] synchronize];

    }
    else {
      UIAlertView *uialertview = [[UIAlertView alloc] initWithTitle:@"系統訊息" message:[responseObject valueForKeyPath:@"Message"] delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
      [uialertview show];
      if (aBlock) {
        aBlock(nil);
      }
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    trace(@"register.ashx error:%@",error);
    if (aBlock) {
      aBlock(error);
    }
    
  }];
  
}

- (void)apiLoginWithEmail:(NSString *)email withPassword:(NSString *)password andComplete:(void (^)(NSError *error))aBlock
{
  [self apiLoginWithEmail:email withPassword:password withEventType:@"apiLoginSuccess" andComplete:aBlock];
}

- (void)apiLoginWithEmail:(NSString *)email withPassword:(NSString *)password withEventType:(NSString *)eventType andComplete:(void (^)(NSError *error))aBlock
{
  // for json
  self.responseSerializer = [AFJSONResponseSerializer serializer];
  
  [self POST:APPEND(VPASS_API_URL, @"login.ashx") parameters:@{@"Email":email, @"Password":password, @"DeviceID":[UIDevice currentDevice].identifierForVendor.UUIDString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    trace(@"login:%@",responseObject);
    if ([[responseObject valueForKeyPath:@"Success"] boolValue]){
      _accountLevel = [responseObject valueForKeyPath:@"Level"];
      _token = [responseObject valueForKeyPath:@"Token"];

      [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"Email"];
      [[NSUserDefaults standardUserDefaults] setObject:_accountLevel forKey:@"AccountLevel"];
      [[NSUserDefaults standardUserDefaults] setObject:_token forKey:@"Token"];
      [[NSUserDefaults standardUserDefaults] synchronize];

      trace(@"apiLogin eventType:%@",eventType);
      if ([eventType isEqualToString:@"ModalSegueFromWebViewToLoginCallBack"]) {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
          dispatchEventWithData(@"ModalSegueFromWebViewToLoginCallBack", nil, (@{@"Token":_token, @"Success":@1}));

        });
      }
      else {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
          dispatchEvent(eventType, nil);
        });
      }
    }
    else {
      
      UIAlertView *uialertview = [[UIAlertView alloc] initWithTitle:@"系統訊息" message:[responseObject valueForKeyPath:@"Message"] delegate:nil cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
      [uialertview show];
    }
    if (aBlock)
      aBlock(nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    trace(@"login.ashx error:%@",error);
    if (aBlock) {
      aBlock(error);
    }
    
  }];
}

- (void)apiGetVersionComplete
{
  // for text
  self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
  
  // for json
  //self.responseSerializer = [AFJSONResponseSerializer serializer];

  [self GET:APPEND(VPASS_API_URL, @"version.ashx") parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    trace(@"version:%@, url:%@",responseObject[@"iOS"][@"Version"], responseObject[@"iOS"][@"Url"]);
    _accountLevel = [responseObject valueForKeyPath:@"Level"];
    [[NSUserDefaults standardUserDefaults] setObject:_accountLevel forKey:@"AccountLevel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatchEventWithData(@"apiGetVersionComplete", nil, responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    trace(@"apiGetVersionComplete error:%@",error);
    
  }];
}

@end
