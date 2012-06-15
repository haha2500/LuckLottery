//
//  QCLuckItemDateSetViewController.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCLuckItem.h"

@interface QCLuckItemDateSetViewController : UIViewController
@property (strong, nonatomic) QCLuckItem *luckItem;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end
