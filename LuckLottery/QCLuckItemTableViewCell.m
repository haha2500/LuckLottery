//
//  QCLuckItemTableViewCell.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCLuckItemTableViewCell.h"
#import "QCDataStore.h"

@implementation QCLuckItemTableViewCell
@synthesize labelName;
@synthesize lableValue;
@synthesize imageBallView;
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

- (void)setLuckItem:(QCLuckItem *)luckItem
{
    labelName.text = luckItem.strName;
    lableValue.text = (luckItem.strValue == nil) ?  @"（未设置）" : luckItem.strValue;
    
    Byte btRecmdNums[8] = {0};
    int nNumCount = [luckItem getRecmdNums:btRecmdNums atIndex:-1 matchCount:NULL];
    if(nNumCount == -1) // 没有开奖数据
    {
        [imageBallView setShowText:@"请刷新开奖数据"];
    }
    else if(nNumCount == 0) // 没有推荐码
    {
        [imageBallView setShowText:@"请在试机号发布后刷新"];
    }
    else
    {
        [imageBallView removeAllBalls];
        
        for (int i=0; i<nNumCount; i++)
        {
            [imageBallView addBall:(i == 0 ? kBallTypeGold : kBallTypeNormal) andValue:btRecmdNums[i]];
        }
    }
    
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