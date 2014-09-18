//
//  ApiManager.h
//
//  Created by wwwins on 2014/7/24.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AppConstants.h"


@interface ApiManager : AFHTTPRequestOperationManager

@property (nonatomic) BOOL enableMgm;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *sharedMessage;
@property (nonatomic, strong) NSString *accountLevel;

+ (ApiManager *)sharedManager;
+ (BOOL)isNetworkAvailable;
+ (BOOL)isNetworkAvailableWithAlart;
+ (BOOL)isMember;

- (BOOL)isLogin;

- (NSString *)getZipCode:(NSString *)address;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)apiLogout;

- (void)apiRegisterWithEmail:(NSString *)email withPhone:(NSString *)phone andComplete:(void (^)(NSError *error))aBlock;

- (void)apiLoginWithEmail:(NSString *)email withPassword:(NSString *)password withEventType:(NSString *)eventType andComplete:(void (^)(NSError *error))aBlock;

- (void)apiLoginWithEmail:(NSString *)email withPassword:(NSString *)password andComplete:(void (^)(NSError *error))aBlock;

- (void)apiGetVersionComplete;

@end
