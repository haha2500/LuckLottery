//
//  QCHistoryTableViewCell.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCBallImageView.h"

@interface QCHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lableIssue;
@property (weak, nonatomic) IBOutlet UILabel *lableNums;
@property (weak, nonatomic) IBOutlet UILabel *lableMatchCount;
@property (weak, nonatomic) IBOutlet QCBallImageView *imageBallView;

- (void)setMatchCount:(int)nCount;
@end
