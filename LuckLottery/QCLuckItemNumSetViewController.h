//
//  QCLuckItemNumSetViewController.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCLuckItem.h"

@interface QCLuckItemNumSetViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *numbersArray;
}
@property (strong, nonatomic) QCLuckItem *luckItem;
@property (weak, nonatomic) IBOutlet UIPickerView *numPicker;

@end
