//
//  QCDataItem.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCDataItem.h"

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
@end
