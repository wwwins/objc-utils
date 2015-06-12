//
//  BaseLabel.h
//
//  Created by wwwins on 2015/5/27.
//  Copyright (c) 2015年 isobar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseLabel : UILabel

@property (assign, nonatomic) CGFloat myLineSpacing;

- (void)highlightSubstring:(NSString*)substring;

- (void)boldSubstring:(NSString*)substring;

@end
