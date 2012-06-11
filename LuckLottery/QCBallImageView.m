//
//  QCBallImageView.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCBallImageView.h"

@implementation QCBallImageView

- (void)setType:(Byte)type andValue:(Byte)value
{
    _imageBall = [UIImage imageNamed:(type == 0) ? @"ball_orange.png" : @"ball_red.png"];
    
    _btValue = value;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [_imageBall drawInRect:rect];
    
    NSString *strValue = [NSString stringWithFormat:@"%d", _btValue];
    UIFont *font = [UIFont systemFontOfSize:16];
    
    // 计算文字所需矩形大小
    CGSize sizeText = [strValue sizeWithFont:font];
    CGPoint ptOrg = CGPointMake(rect.origin.x + (rect.size.width - sizeText.width) / 2, rect.origin.y + (rect.size.height - sizeText.height) / 2);
        
    // 居中显示文字
    [strValue drawAtPoint:ptOrg withFont:font]; 
}


@end
