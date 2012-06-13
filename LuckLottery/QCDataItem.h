//
//  QCDataItem.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCDataItem : NSObject
{
    NSInteger nIssue;               // 开奖期号
    NSInteger nDate;                // 开奖日期
    Byte  btNumbers[8];             // 开奖号码（对于3D，则前3位为开奖号码，紧跟着3位为试机号）
    Byte  btRecmdNums[3];           // 彩神通关注码（仅用于3D）
    Byte  btTestRelatedNums[3];     // 试机号相关码（仅用于3D）
}

- (void)setNumbers:(Byte *)numbers withDate:(NSInteger)date andIssue:(NSInteger)issue;
- (void)set3DRecmdNums:(Byte *)recmdNums andTestRelatedNums:(Byte *)trNums;
- (int)issue;
- (NSString *)dateString;
- (NSString *)issueString;
- (NSString *)numbersString;
- (NSString *)testNumbersString;

@end
