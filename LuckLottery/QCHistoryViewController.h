//
//  QCHistoryViewController.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMAdView.h"
#import "QCLuckItem.h"

@class QCMainViewController;
@class QCBuyViewController;

@interface QCHistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DMAdViewDelegate, UISplitViewControllerDelegate, UIPopoverControllerDelegate>
{
    DMAdView *_dmAdView;
    BOOL _bADLoadOK;
    UIPopoverController *popoverControllerForIPad;
    QCBuyViewController *buyVC;
}
@property (strong, nonatomic) QCLuckItem *luckItem;
@property (assign, nonatomic) QCMainViewController *mainVCForIPad;

- (void)resetLuckItemForIPad;

@end
