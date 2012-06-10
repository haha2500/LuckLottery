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
@synthesize labelNumbers;
@synthesize lableValue;

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

@end