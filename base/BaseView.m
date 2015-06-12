//
//  BaseView.m
//
//  Created by wwwins on 2015/5/13.
//  Copyright (c) 2015年 isobar. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

#pragma mark - fixed a bug of top constraint

//https://github.com/andreamazz/AMScrollingNavbar/issues/87
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
//  NSLog(@"pointInside:%f,%f",point.x,point.y);
  CGRect viewRect = self.bounds;
  viewRect.origin.y = self.topLayoutConstraint.constant;
  viewRect.size.height += -self.topLayoutConstraint.constant;
  return CGRectContainsPoint(viewRect, point);
}


@end
