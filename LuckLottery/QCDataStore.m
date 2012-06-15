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
@synthesize numberCount, dataItemArray, dataItemForecast;

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
        // 获取数据文件路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        strDataFilename = [documentsDirectory stringByAppendingPathComponent:@"FC3D"];
        
        // 装载数据文件
        dataItemArray = [[NSMutableArray alloc] initWithContentsOfFile:strDataFilename];
        if (dataItemArray == nil)
        {
            dataItemArray = [[NSMutableArray alloc] init];
        }
        
        numberCount = 3;
        downloadDataItemLen = 21;   // 3D
        
    }
    
    return self;
}

#pragma mark -
- (int)updateNums:(char *)downloadDataBuf bufSize:(int)bufSize
{
    if ((bufSize % downloadDataItemLen) != 2)
	{
        return -1;       // 下载失败，数据长度不正确
	}
    
    if (memcmp(downloadDataBuf, "1|", 2))
    {
        return -1;      // 下载失败
    }
    
    int nCount = (bufSize - 2) / downloadDataItemLen;
    if (nCount == 0)
    {
        return 0;      // 没有最新数据
    }
    
    int nIndex = 2, nDate = 0, nIssue = 0;
    char szTemp[16] = {0};
    Byte btNumbers[8] = {0}, btRecmdNums[3] = {0}, btTestRelatedNums[3] = {0};
    BOOL bHasOnlyTestNums = NO;
    
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
            if (downloadDataBuf[nIndex] == 'A')
            {
                btNumbers[j] =  0xff;
                bHasOnlyTestNums = YES;
            }
            else 
            {
                btNumbers[j] = downloadDataBuf[nIndex] - '0';
            }
            
            nIndex++;
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
        
        if (bHasOnlyTestNums)
        {
            if (i == 0)
            {
                if ([dataItemForecast isEqual:newItem])
                {
                    return 0;
                }
            }
            dataItemForecast = newItem;
        }
        else
        {
            if (i == 0)
            {
                [dataItemArray removeLastObject];   // 删除最后一个数据，因为这个每次都会更新
            }
            [dataItemArray addObject:newItem];
        }
    }
    
    // 只保留最后30期数据
    if ([dataItemArray count] > kHistoryDataItemCount)
    {
        NSRange range = {0, [dataItemArray count] - kHistoryDataItemCount};
        [dataItemArray removeObjectsInRange:range];
    }
    if (!bHasOnlyTestNums)  // 增加预测期数据
    {
        dataItemForecast = [[QCDataItem alloc] init];
        int nNextIssue = nIssue;
        int nNextDate = [self getNextDate:nDate andIssue:&nNextIssue];
        [dataItemForecast setNumbers:NULL withDate:nNextDate andIssue:nNextIssue];
    }
    
    // 保存到数据文件
    if([dataItemArray writeToFile:strDataFilename atomically:YES])
    {
        return 1;
    }

    return 1;
}

- (int)lastIssue
{
    if (dataItemForecast == nil)
    {
        return 2012100;
    }
    
    return [dataItemForecast issue];
}

#pragma mark -
- (int)getNextDate:(int)date andIssue:(int *)issue
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:(date % 100)];
    [comps setMonth:((date / 100) % 100)];
    [comps setYear:(date / 10000)];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *curdate = [gregorian dateFromComponents:comps];
    
    NSDate *newDate = [curdate dateByAddingTimeInterval:1 * 24 * 3600];
    
    comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:newDate];
    
    if ([comps year] != date / 10000)   // 跨年
    {
        (*issue) = [comps year] * 1000 + 1;
    }
    else
    {
        (*issue) ++;
    }
    
    return [comps year] * 10000 + [comps month] * 100 + [comps day];
}
@end
