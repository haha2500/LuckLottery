//
//  QCHistoryTableViewCell.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCHistoryTableViewCell.h"

@implementation QCHistoryTableViewCell
@synthesize lableIssue;
@synthesize lableNums;
@synthesize lableMatchCount;
@synthesize imageBallView;

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

- (void)setMatchCount:(int)nCount
{
    if (nCount < 0)
    {
        lableMatchCount.text = @"未开奖";
        lableMatchCount.textColor = [UIColor redColor];
        self.backgroundColor = [UIColor greenColor];

        return;
    }
    
    lableMatchCount.text = [NSString stringWithFormat:@"中 %d 个", nCount];
    
    switch (nCount)
    {
        case 0:
            lableMatchCount.textColor = [UIColor grayColor];
            break;
        case 1:
            lableMatchCount.textColor = [UIColor blackColor];
            break;
        case 2:
            lableMatchCount.textColor = [UIColor blueColor];
            break;
        case 3:
            lableMatchCount.textColor = [UIColor magentaColor];
            break;    
        default:
            lableMatchCount.textColor = [UIColor orangeColor];
            break;
    }
}

@end
