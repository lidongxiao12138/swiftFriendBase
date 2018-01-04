//
//  UIView+storyboard.m
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/21.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

#import "UIView+storyboard.h"

@implementation UIView (storyboard)

@dynamic borderColor,borderWidth,cornerRadius;

-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
    
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
    self.layer.masksToBounds = YES;
    
}

@end
