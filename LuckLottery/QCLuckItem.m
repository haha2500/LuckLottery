//
//  QCLuckItem.m
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QCLuckItem.h"

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

- (BOOL)getRecmdNums:(Byte *)recmdNumsOut atIndex:(int)issueIndex
{
    return YES;
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

@end
