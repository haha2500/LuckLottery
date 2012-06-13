//
//  QCDataStore.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCDataStore : NSObject
{
    NSArray *dateItemArray;
    Byte numberCount;
} 
@property (readonly, nonatomic) NSArray *dateItemArray;
@property (readonly, nonatomic) Byte numberCount;

+ (QCDataStore *)defaultStore;
- (BOOL)updateNums:(char *)downloadDataBuf bufSize:(int)bufSize;
@end
