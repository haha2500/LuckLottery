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
@synthesize nIssue, nDate;

- (void)setNumbers:(Byte *)numbers withDate:(NSInteger)date andIssue:(NSInteger)issue
{
    if (numbers == NULL)
    {
        memset(btNumbers, 0XFF, sizeof(btNumbers));
    }
    else
    {
        memcpy(btNumbers, numbers, sizeof(btNumbers));
    }
    
    nIssue = issue;
    nDate = date;
}

- (void)set3DRecmdNums:(Byte *)recmdNums andTestRelatedNums:(Byte *)trNums
{
    memcpy(btRecmdNums, recmdNums, sizeof(btRecmdNums));
    memcpy(btTestRelatedNums, trNums, sizeof(btTestRelatedNums));
}

- (Byte *)numbers
{
    return btNumbers;
}

- (Byte *)RecmdNums
{
    return btRecmdNums;
}

- (Byte *)TestRelatedNums
{
    return btTestRelatedNums;
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
    if (btNumbers[0] == 0xff)
    {
        return nil;
    }
    
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
    if (btNumbers[3] == 0xff)
    {
        return @"（未发布）";
    }
    
    return [NSString stringWithFormat:@"%d%d%d", btNumbers[3], btNumbers[4], btNumbers[5]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) 
    {
        nIssue = [aDecoder decodeIntegerForKey:@"issue"]; 
        nDate = [aDecoder decodeIntegerForKey:@"date"]; 
        NSUInteger nLen = 0;
        memcpy(btNumbers, [aDecoder decodeBytesForKey:@"numbers" returnedLength:&nLen], sizeof(btNumbers));
        memcpy(btRecmdNums, [aDecoder decodeBytesForKey:@"recmdNums" returnedLength:&nLen], sizeof(btRecmdNums));
        memcpy(btTestRelatedNums, [aDecoder decodeBytesForKey:@"testRelatedNums" returnedLength:&nLen], sizeof(btTestRelatedNums));
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:nIssue forKey:@"issue"];
    [aCoder encodeInteger:nDate forKey:@"date"];
    [aCoder encodeBytes:btNumbers length:sizeof(btNumbers) forKey:@"numbers"];
    [aCoder encodeBytes:btRecmdNums length:sizeof(btRecmdNums) forKey:@"recmdNums"];
    [aCoder encodeBytes:btTestRelatedNums length:sizeof(btTestRelatedNums) forKey:@"testRelatedNums"];
}

- (BOOL)isEqual:(QCDataItem *)srcItem
{
    if (nIssue != srcItem.nIssue)
    {
        return NO;
    }
    
    if (memcmp(self.numbers, srcItem.numbers, sizeof(btNumbers)))
    {
        return NO;
    }
    if (memcmp(self.RecmdNums, srcItem.RecmdNums, sizeof(btRecmdNums)))
    {
        return NO;
    }
    if (memcmp(self.TestRelatedNums, srcItem.TestRelatedNums, sizeof(btTestRelatedNums)))
    {
        return NO;
    }
    
    return YES;
}
@end
