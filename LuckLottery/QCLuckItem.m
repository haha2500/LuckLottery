//
//  QCLuckItem.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCLuckItem.h"
#import "QCDataStore.h"

@implementation QCLuckItem
@synthesize btType, strName, strValue, nValue;

+ (id)luckItemWithType:(Byte)type andName:(NSString *)name
{
    QCLuckItem *luckItem = [[self alloc] initWithType:type andName:name];
        
    return luckItem;
}

- (id)initWithType:(Byte)type andName:(NSString *)name
{
    if (self == [super init])
    {
        btType = type;
        strName = name;
    
        switch (type)
        {
        case kLuckItemTypeCST:
            strValue = @"拼搏在线官网提供";
            break;
        case kLuckItemTypeDate:
            [self getCurrentDate];
            break; 
        case kLuckItemTypeNumber:
            [self getCurrentTime];
            break; 
        default:
            strValue = nil;
            break;
        }
    }
    
    return self;
}

- (int)getRecmdNums:(Byte *)recmdNumsOut atIndex:(int)issueIndex matchCount:(int *)countOut
{
    switch (btType)
    {
        case kLuckItemTypeCST:
            return [self getRecmdNums_CST:recmdNumsOut atIndex:issueIndex matchCount:countOut];
            break;
        case kLuckItemTypeDate:
  //          [self getCurrentDate];
            break; 
        case kLuckItemTypeNumber:
   //         [self getCurrentTime];
            break;
    }

    return 0;
}

#pragma mark - 
- (void)getCurrentDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger flag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:flag fromDate:[NSDate date]];
    
    nValue = dateComponents.year * 10000 + dateComponents.month * 100 + dateComponents.day;
    strValue = [NSString stringWithFormat:@"%d年%02d月%02d日", dateComponents.year, dateComponents.month, dateComponents.day];
}

- (void)getCurrentTime
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger flag = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:flag fromDate:[NSDate date]];
    
    strValue = [NSString stringWithFormat:@"%d%d%d", dateComponents.hour, dateComponents.minute, dateComponents.second];
    nValue = [strValue intValue];
}

- (int)getRecmdNums_CST:(Byte *)recmdNumsOut atIndex:(int)issueIndex matchCount:(int *)countOut
{
    NSArray *dataItemArray = [[QCDataStore defaultStore] dataItemArray];
    int nDataItemCount = [dataItemArray count];
    
    if (nDataItemCount == 0)
    {
        return -1;      // 没有开奖数据
    }
    
    if (issueIndex >= nDataItemCount)
    {
        issueIndex = nDataItemCount - 1;
    }
    
    QCDataItem *dataItem = nil;
    if (issueIndex < 0)  // 获取最新推荐码
    {
        dataItem = [[QCDataStore defaultStore] dataItemForecast];
        if ([dataItem numbers][3] == 0xff)
        {
            return 0;   // 当前不是只含试机号的一期，则没有推荐值
        }
    }
    else 
    {
        dataItem = [dataItemArray objectAtIndex:issueIndex];
    }
    
    // 获取推荐值信息
    for (int i=0; i<3; i++)
    {
        recmdNumsOut[i] = [dataItem RecmdNums][i];
    }
    
    // 获取中出信息
    if (countOut != NULL)
    {
        (*countOut) = 0;
    }

    Byte *pNums = [dataItem numbers];
    for (int i=0; i<3; i++)
    {
        for (int j=0; j<3; j++)
        {
            if (recmdNumsOut[i] == pNums[j])
            {
                if (countOut != NULL)
                {
                    (*countOut) ++;
                }
                recmdNumsOut[i] |= 0X80;
                break;
            }
        }
    }
    
    return 3;
}
@end
