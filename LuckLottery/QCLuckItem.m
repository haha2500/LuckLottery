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
@synthesize btType, strName, strValue, nValue, bModified;

+ (id)luckItemWithType:(Byte)type andName:(NSString *)name
{
    QCLuckItem *luckItem = [[self alloc] initWithType:type andName:name];
        
    return luckItem;
}

- (id)initWithType:(Byte)type andName:(NSString *)name
{
    if (self = [super init])
    {
        btType = type;
        strName = name;
        bModified = YES;
    
        switch (type)
        {
        case kLuckItemTypeCST:
            strValue = @"拼搏在线官方网站提供";
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

- (id)initWithCoder:(NSCoder *)decoder 
{ 
    if((self = [super init])) 
    { 
        //decode properties, other class vars 
        self.btType = [decoder decodeIntForKey:@"type"]; 
        self.strName = [decoder decodeObjectForKey:@"name"]; 
        self.strValue = [decoder decodeObjectForKey:@"valuetext"]; 
        self.nValue = [decoder decodeIntForKey:@"value"];
        self.bModified = NO; // [decoder decodeIntForKey:@"modify"];
    } 
    return self; 
} 

- (void)encodeWithCoder:(NSCoder *)encoder 
{ 
    //Encode properties, other class variables, etc 
    [encoder encodeInt:self.btType forKey:@"type"]; 
    [encoder encodeObject:self.strName forKey:@"name"]; 
    [encoder encodeObject:self.strValue forKey:@"valuetext"]; 
    [encoder encodeInt:self.nValue forKey:@"value"];
   // [encoder encodeInt:self.bModified forKey:@"modify"];
} 


- (int)getRecmdNums:(Byte *)recmdNumsOut atIndex:(int)issueIndex matchCount:(int *)countOut
{
    switch (btType)
    {
        case kLuckItemTypeCST:
            return [self getRecmdNums_CST:recmdNumsOut atIndex:issueIndex matchCount:countOut];
            break;
        case kLuckItemTypeDate:
        case kLuckItemTypeNumber:
            return [self getRecmdNums_Random:recmdNumsOut withSeed:nValue atIndex:issueIndex matchCount:countOut];
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
    strValue = [NSString stringWithFormat:@"当前设置：%d年%02d月%02d日", dateComponents.year, dateComponents.month, dateComponents.day];
}

- (void)getCurrentTime
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger flag = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:flag fromDate:[NSDate date]];
    
    nValue = dateComponents.hour * 10000 + dateComponents.minute * 100 + dateComponents.second;
    strValue = [NSString stringWithFormat:@"当前设置：%d", nValue];
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
    [self getMatchCount:recmdNumsOut matchCount:countOut withDataItem:dataItem andNumberCount:3];
    
    return 3;
}

- (int)getRecmdNums_Random:(Byte *)recmdNumsOut withSeed:(int)randseed atIndex:(int)issueIndex matchCount:(int *)countOut
{
    NSArray *dataItemArray = [[QCDataStore defaultStore] dataItemArray];
    int nDataItemCount = [dataItemArray count];
    int nNumberCount = [[QCDataStore defaultStore] numberCount];
    
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
    }
    else 
    {
        dataItem = [dataItemArray objectAtIndex:issueIndex];
    }
    
    srand(randseed);
    srand(rand() + dataItem.nIssue);
    
    // 获取推荐值信息
    Byte btFlags[100] = {0}, btRecmdValue = 0;
    
    for (int i=0; i<nNumberCount; i++)
    {
        btRecmdValue = rand() % 10;
        
        while(btFlags[btRecmdValue] == 1)
        {
            btRecmdValue ++;
            if (btRecmdValue == 10)
            {
                btRecmdValue = 0;
            }
        }
        recmdNumsOut[i] = btRecmdValue;
        btFlags[btRecmdValue] = 1;
    }
    
    // 获取中出信息
    [self getMatchCount:recmdNumsOut matchCount:countOut withDataItem:dataItem andNumberCount:nNumberCount];
    
    return nNumberCount; 
}
    
- (void)getMatchCount:(Byte *)recmdNumsOut matchCount:(int *)countOut withDataItem:(QCDataItem *)dataItem andNumberCount:(int)numberCount
{
    if (countOut != NULL)
    {
        (*countOut) = 0;
    }
    
    Byte *pNums = [dataItem numbers];
    for (int i=0; i<numberCount; i++)
    {
        for (int j=0; j<numberCount; j++)
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
}

@end
