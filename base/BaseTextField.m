//
//  BaseTextField.m
//
//  Created by wwwins on 2015/4/22.
//  Copyright (c) 2015年 isobar. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

//
//  Set padding for UITextField with UITextBorderStyleNone.
//
- (void)setMyPadding:(CGFloat)myPadding
{
  _myPadding = myPadding;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
  return CGRectInset(bounds, _myPadding, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
  return [self textRectForBounds:bounds];
}

@end
