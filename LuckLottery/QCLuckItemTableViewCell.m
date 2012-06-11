//
//  QCLuckItemTableViewCell.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCLuckItemTableViewCell.h"

@implementation QCLuckItemTableViewCell
@synthesize labelName;
@synthesize lableValue;
@synthesize ballImage1;
@synthesize numberArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNumber:(Byte)number AtIndex:(Byte)index
{
    [ballImage1 setType:0 andValue:number];
}
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *imageOrange =  [UIImage imageNamed:@"ball_orange.png"];
    
    CGRect rectBall = CGRectMake(200, 0, 25, 25);
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    CGContextDrawImage(context, rectBall, [imageOrange CGImage]);
 //   CGContextStrokePath(context);
    //[imageOrange drawInRect:rectBall];
    
    [super drawRect:rect];
}
 */
@end