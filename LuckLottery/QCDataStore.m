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
@synthesize numberCount, dateItemArray;

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
        dateItemArray = nil;
    }
    return self;
}

#pragma mark -
- (BOOL)updateNums:(char *)downloadDataBuf bufSize:(int)bufSize
{
    if (bufSize < 2)
	{
        return NO;       // 下载失败，数据长度不够
	}
    
    if (downloadDataBuf[0] != '1')
    {
        return NO;         // 下载失败
    }

    return YES;
}

@end
