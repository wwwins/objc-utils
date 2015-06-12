//
//  BaseLabel.m
//
//  Created by wwwins on 2015/5/27.
//  Copyright (c) 2015年 isobar. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel

- (void)setMyLineSpacing:(CGFloat)myLineSpacing
{
  _myLineSpacing = myLineSpacing;
  self.text = self.text;
}

- (void)setText:(NSString *)text
{
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = _myLineSpacing;
  paragraphStyle.alignment = self.textAlignment;
  NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
  NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                       attributes:attributes];
  self.attributedText = attributedText;
}

- (void)highlightSubstring:(NSString*)substring
{
  if (![self respondsToSelector:@selector(setAttributedText:)])
  {
    return;
  }
  
  if (substring.length < 1)
    return;
  
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: substring options:NSRegularExpressionCaseInsensitive error:&error];
  
  if (!error)
  {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self text]];
    NSArray *allMatches = [regex matchesInString:[self text] options:0 range:NSMakeRange(0, [[self text] length])];
    for (NSTextCheckingResult *aMatch in allMatches)
    {
      NSRange matchRange = [aMatch range];
      [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range: matchRange];
    }
    [self setAttributedText:attributedString];
  }
}

- (void)boldSubstring:(NSString*)substring
{
  if (![self respondsToSelector:@selector(setAttributedText:)])
  {
    return;
  }
  
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: substring options:NSRegularExpressionCaseInsensitive error:&error];
  
  if (!error)
  {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self text]];
    NSArray *allMatches = [regex matchesInString:[self text] options:0 range:NSMakeRange(0, [[self text] length])];
    for (NSTextCheckingResult *aMatch in allMatches)
    {
      NSRange matchRange = [aMatch range];
      [attributedString setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range: matchRange];
    }
    [self setAttributedText:attributedString];
  }
}

@end
