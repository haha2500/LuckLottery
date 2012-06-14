//
//  QCDataItem.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCDataItem.h"
#import "QCDataStore.h"

@implementation QCDataItem
- (void)setNumbers:(Byte *)numbers withDate:(NSInteger)date andIssue:(NSInteger)issue
{
    memcpy(btNumbers, numbers, sizeof(btNumbers));
    nIssue = issue;
    nDate = date;
}

- (void)set3DRecmdNums:(Byte *)recmdNums andTestRelatedNums:(Byte *)trNums
{
    memcpy(btRecmdNums, recmdNums, sizeof(btRecmdNums));
    memcpy(btTestRelatedNums, trNums, sizeof(btTestRelatedNums));
}

- (int)issue
{
    return nIssue;
}

- (NSString *)dateString
{
    return [NSString stringWithFormat:@"%04d-%02d-%02d", nDate / 10000, (nDate / 100) % 100, nDate % 100];
}

- (NSString *)issueString
{
    return [NSString stringWithFormat:@"%d", nIssue];
}

- (NSString *)numbersString
{
    int nNumberCount = [[QCDataStore defaultStore] numberCount];
    char szNumbers[8] = {0};
    for (int i=0; i<nNumberCount; i++)
    {
        szNumbers[i] = btNumbers[i] + '0';
    }
    return [NSString stringWithUTF8String:szNumbers];
}

- (NSString *)testNumbersString
{
    return [NSString stringWithFormat:@"%d%d%d", btNumbers[3], btNumbers[4], btNumbers[5]];
}

@end