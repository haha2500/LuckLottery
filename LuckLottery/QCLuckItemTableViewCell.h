//
//  QCLuckItemTableViewCell.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCBallImageView.h"

@interface QCLuckItemTableViewCell : UITableViewCell
@property (strong, nonatomic) NSArray *numberArray;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *lableValue;
@property (weak, nonatomic) IBOutlet QCBallImageView *imageBallView;

- (void)setRecmdNums:(Byte *)numbers;

@end
