//
//  QCLuckItemTableViewCell.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCLuckItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelNumbers;
@property (weak, nonatomic) IBOutlet UILabel *lableValue;
@end
