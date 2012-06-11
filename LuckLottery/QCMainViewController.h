//
//  QCViewController.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAdView.h"
#import "QCLuckItem.h"

@interface QCMainViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DMAdViewDelegate>
{
    DMAdView *_dmAdView;
    BOOL _bADLoadOK;
}

@property (strong, nonatomic) NSMutableArray *luckItemArray;
@end
