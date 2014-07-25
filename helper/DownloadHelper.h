//
//  DownloadHelper.h
//  MyLayoutViewDemo
//
//  Created by wwwins on 2014/7/25.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadHelper : NSObject

+ (void)fetchAll:(NSArray *)fileNames complete:(void(^)())complete;
+ (void)fetch:(NSString *)fileName;

@end
