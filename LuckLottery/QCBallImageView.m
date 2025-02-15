//
//  QCBallImageView.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCBallImageView.h"
#import "QCDataStore.h"

@implementation QCBallImageView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) 
    {
        [self removeAllBalls];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)addBall:(Byte)type andValue:(Byte)value
{
    assert(_btCount < 8);
    
    _btTypes[_btCount] = type;
    _btValues[_btCount] = value;
    _btCount ++;
    
    [self setNeedsDisplay];
}

- (void)removeAllBalls
{
    showText = nil;
    _btCount = 0;
    memset(_btTypes, 0, sizeof(_btTypes));
    memset(_btValues, 0, sizeof(_btValues));
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if (showText != nil)
    {
        [[UIColor grayColor] setFill];
        [showText drawAtPoint:CGPointMake(0, 5) withFont:[UIFont systemFontOfSize:14]];
        return ;
    }
    
    // 画号码球
    CGRect rectBall = rect;
    rectBall.size.width = rectBall.size.height;
    rectBall.origin.x = 20;
    for (Byte i=0; i<_btCount; i++)
    {
        UIImage *imageBall = nil;
        UIColor *textColor = nil;
        if (_btTypes[i] & kBallTypeMatch)
        {
            imageBall = [UIImage imageNamed:@"ball_red.png"];
            textColor = [UIColor whiteColor];
        }
        else if (_btTypes[i] & kBallTypeGold)
        {
            imageBall = [UIImage imageNamed:@"ball_orange.png"];
            textColor = [UIColor blackColor];
        }
        else 
        {
            imageBall = [UIImage imageNamed:@"ball_blue.png"];
            textColor = [UIColor blackColor];
        }
        
        [imageBall drawInRect:rectBall];
        
        NSString *strValue = [NSString stringWithFormat:@"%d", _btValues[i]];
        UIFont *font = [UIFont systemFontOfSize:16];
        
        // 计算文字所需矩形大小
        CGSize sizeText = [strValue sizeWithFont:font];
        CGPoint ptOrg = CGPointMake(rectBall.origin.x + (rectBall.size.width - sizeText.width) / 2, rectBall.origin.y + (rectBall.size.height - sizeText.height) / 2);
        
        [textColor setFill];
            
        // 居中显示文字
        [strValue drawAtPoint:ptOrg withFont:font]; 
        
        rectBall.origin.x += 35;
    }
}

- (void)setShowText:(NSString *)text
{
    [self removeAllBalls];
    showText = text;
}

@end
