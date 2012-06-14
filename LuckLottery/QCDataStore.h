//
//  QCDataStore.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCDataItem.h"

#define kHistoryDataItemCount           30          // 历史号码个数

@interface QCDataStore : NSObject
{
    NSMutableArray *dataItemArray;  // 彩票数据数组
    QCDataItem *dataItemForecast;   // 预测期数据
    Byte numberCount;               // 彩票数据的号码个数
    Byte downloadDataItemLen;       // 下载数据单元长度
} 
@property (readonly, nonatomic) NSMutableArray *dataItemArray;
@property (readonly, nonatomic) Byte numberCount;
@property (readonly, nonatomic) QCDataItem *dataItemForecast;

+ (QCDataStore *)defaultStore;
- (BOOL)updateNums:(char *)downloadDataBuf bufSize:(int)bufSize;
- (int)lastIssue;
- (QCDataItem *)lastDataItem;

@end
