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

#define kLoadADNeedFirstLoad        1           // 第一次加载广告
#define kLoadADLoadSuccess          2           // 加载广告成功
#define kLoadADLoadFailure          3           // 加载广告失败

@interface QCMainViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DMAdViewDelegate>
{
    DMAdView *_dmAdView;
    Byte _btLoadADFlag;
    NSURLConnection *connection;
    NSMutableData *downloadData;
    UIAlertView *waitingDialog;
    BOOL bPromptNoNewData;
}

@property (strong, nonatomic) NSMutableArray *luckItemArray;
@end
