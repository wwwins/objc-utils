//
//  LayoutHelper.h
//
//  Created by wwwins on 2014/7/18.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayoutHelper : NSObject

+ (UILabel *)addLabel:(NSString *)text fontSize:(float)fontSize fontColor:(UIColor*)fontColor width:(float)width;
+ (UILabel *)addLabel:(NSString *)text;
+ (UILabel *)addTitleLabel:(NSString *)text;
+ (UILabel *)addSubTitleLabel:(NSString *)text;
+ (UIImageView *)addImage:(UIImage *)image;

@end
