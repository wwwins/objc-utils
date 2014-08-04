//
//  LayoutHelper.m
//
//  Created by wwwins on 2014/7/18.
//  Copyright (c) 2014年 isobar. All rights reserved.
//

#import "LayoutHelper.h"

@implementation LayoutHelper

+ (UILabel *)addLabel:(NSString *)text fontSize:(float)fontSize fontColor:(UIColor*)fontColor width:(float)width alignment:(NSTextAlignment)alignment
{
  UILabel *label = [[UILabel alloc] init];
  label.numberOfLines = 0;
  label.font = [UIFont systemFontOfSize:fontSize];
  label.textColor = fontColor;
  label.text = text;
  if (alignment) {
    label.textAlignment = alignment;
  }
  
  if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize] }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    label.frame = CGRectMake(0.0, 0.0, width, ceilf(rect.size.height));
  }
  else {
    CGSize size = [label.text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    label.frame = CGRectMake(0.0, 0.0, width, size.height);
  }
  
  return label;
}

+ (UILabel *)addLabel:(NSString *)text
{
  return [self addLabel:text fontSize:17 fontColor:nil width:300 alignment:NSTextAlignmentLeft];
}

+ (UILabel *)addTitleLabel:(NSString *)text
{
  return [self addLabel:text fontSize:19 fontColor:nil width:300 alignment:NSTextAlignmentLeft];
}

+ (UILabel *)addTitleLabelAlignCenter:(NSString *)text
{
  return [self addLabel:text fontSize:19 fontColor:nil width:300 alignment:NSTextAlignmentCenter];
}

+ (UILabel *)addSubTitleLabel:(NSString *)text
{
  return [self addLabel:text fontSize:18 fontColor:[UIColor colorWithRed:0.000 green:0.200 blue:0.400 alpha:1.000] width:300]; width:300 alignment:NSTextAlignmentLeft];
}

+ (UIImageView *)addImage:(UIImage *)image
{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
  imageView.contentMode = UIViewContentModeTopLeft;
  imageView.clipsToBounds = YES;
  return imageView;
}

@end
