//
//  DownloadHelper.m
//  MyLayoutViewDemo
//
//  Created by wwwins on 2014/7/25.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import "DownloadHelper.h"

@implementation DownloadHelper

+ (void)fetchAll:(NSArray *)fileNames complete:(void(^)())complete
{
  // create a dispatch group
  dispatch_group_t group = dispatch_group_create();
  
  for (NSString *fileName in fileNames) {
    // enter the group
    dispatch_group_enter(group);
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_URL, fileName]];
    NSURL *url = [NSURL URLWithString:fileName];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                         completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error) {
                                if (data) {
                                  NSString *fileName = [[response URL] lastPathComponent];
                                  NSArray *downloadPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                  NSString *downloadPath = [[downloadPaths objectAtIndex:0] stringByAppendingPathComponent:fileName];
#ifdef DEBUG
                                  NSLog(@"success length=%d",data.length);
                                  NSLog(@"downloadPath=%@",downloadPath);
#endif
                                  NSFileManager *fileManager = [NSFileManager defaultManager];
                                  if ([fileManager fileExistsAtPath:downloadPath]) {
                                    [fileManager removeItemAtPath:downloadPath error:nil];
                                  }
                                  [data writeToFile:downloadPath atomically:YES];
                                  
                                  // leave the group
                                  dispatch_group_leave(group);
                                } else {
                                  NSLog(@"Failed to fetch %@: %@", url, error);
                                  
                                  // leave the group
                                  dispatch_group_leave(group);
                                }
                              }];
    [task resume];
    
  }
  
  // Here we wait for all the requests to finish
  dispatch_group_notify(group, dispatch_get_main_queue(), complete);
}

+ (void)fetch:(NSString *)fileName
{
  //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_URL, fileName]];
  NSURL *url = [NSURL URLWithString:fileName];
  NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                       completionHandler:
                            ^(NSData *data, NSURLResponse *response, NSError *error) {
                              if (data) {
                                NSString *fileName = [[response URL] lastPathComponent];
                                NSArray *downloadPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                NSString *downloadPath = [[downloadPaths objectAtIndex:0] stringByAppendingPathComponent:fileName];
#ifdef DEBUG
                                NSLog(@"success length=%d",data.length);
                                NSLog(@"downloadPath=%@",downloadPath);
#endif
                                NSFileManager *fileManager = [NSFileManager defaultManager];
                                if ([fileManager fileExistsAtPath:downloadPath]) {
                                  [fileManager removeItemAtPath:downloadPath error:nil];
                                }
                                [data writeToFile:downloadPath atomically:YES];
                              } else {
                                NSLog(@"Failed to fetch %@: %@", url, error);
                              }
                            }];
  [task resume];
}

@end
