//
//  QCDataStore.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCDataStore.h"
#import "QCDataItem.h"

static QCDataStore *defaultStore = nil;

@implementation QCDataStore
@synthesize numberCount, dataItemArray;

+ (QCDataStore *)defaultStore
{
    if (defaultStore == nil)
    {
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// 组织创建额外的实例
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init
{
    if (defaultStore != nil)
    {
        return defaultStore;
    }
    
    if (self = [super init])
    {
        dataItemArray = [[NSMutableArray alloc] init];
        numberCount = 3;
        downloadDataItemLen = 21;   // 3D
    }
    
    return self;
}

#pragma mark -
- (BOOL)updateNums:(char *)downloadDataBuf bufSize:(int)bufSize
{
    if ((bufSize % downloadDataItemLen) != 2)
	{
        return NO;       // 下载失败，数据长度不正确
	}
    
    if (memcmp(downloadDataBuf, "1|", 2))
    {
        return NO;         // 下载失败
    }
    
    int nCount = (bufSize - 2) / downloadDataItemLen;
    int nIndex = 2, nDate = 0, nIssue = 0;
    char szTemp[16] = {0};
    Byte btNumbers[8] = {0}, btRecmdNums[3] = {0}, btTestRelatedNums[3] = {0};
    
    [dataItemArray removeLastObject];   // 删除最后一个数据，因为这个每次都会更新
    // 循环添加其他的数据
    for (int i=0; i<nCount; i++)
    {
        QCDataItem *newItem = [[QCDataItem alloc] init];
        memcpy(szTemp, &downloadDataBuf[nIndex], 6);
        nIndex += 6;
        szTemp[6] = 0;
        nDate = atoi(szTemp) + 20000000;
        memcpy(szTemp, &downloadDataBuf[nIndex], 3);
        nIndex += 3;
        szTemp[3] = 0;
        nIssue = atoi(szTemp) + (nDate / 10000) * 1000;
        for (int j=0; j<6; j++)
        {
            btNumbers[j] = downloadDataBuf[nIndex++] - '0';
        }
        [newItem setNumbers:btNumbers withDate:nDate andIssue:nIssue];
        for (int j=0; j<3; j++)
        {
            btRecmdNums[j] = downloadDataBuf[nIndex++] - '0';
        }
        for (int j=0; j<3; j++)
        {
            btTestRelatedNums[j] = downloadDataBuf[nIndex++] - '0';
        }
        [newItem set3DRecmdNums:btRecmdNums andTestRelatedNums:btTestRelatedNums];
        [dataItemArray addObject:newItem];
    }
    
    // 只保留最后30期数据
    if ([dataItemArray count] > kHistoryDataItemCount)
    {
        NSRange range = {0, [dataItemArray count] - kHistoryDataItemCount};
        [dataItemArray removeObjectsInRange:range];
    }
    
    return YES;
}

- (int)lastIssue
{
    QCDataItem *lastDataItem = [self lastDataItem];
    if (lastDataItem == nil)
    {
        return 2012100;
    }
    
    return [lastDataItem issue];
}

- (QCDataItem *)lastDataItem
{
    if ([dataItemArray count] == 0)
    {
        return nil;
    }
    
    QCDataItem *lastDataItem = [dataItemArray objectAtIndex:[dataItemArray count] - 1];
    return lastDataItem;
}
@end
