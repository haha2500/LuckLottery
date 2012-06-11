//
//  QCHistoryViewController.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCLuckItem.h"
#import "QCLuckItemDateSetViewController.h"

@interface QCHistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) QCLuckItem *luckItem;
@end
