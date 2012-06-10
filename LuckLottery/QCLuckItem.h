//
//  QCLuckItem.h
//  LuckLottery
//
//  Created by 武 孙 on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义项目类型
#define kLuckItemTypeDate               1    // 幸运日
#define kLuckItemTypeNumber             10   // 幸运数字
#define kLuckItemTypePerson             20   // 贵人
#define kLuckItemTypeAddress            30   // 贵地
#define kLuckItemTypeCarNumber          40   // 车牌号
#define kLuckItemTypeCST                100  // 彩神通关注码

@interface QCLuckItem : NSObject
{
    Byte btType;                // 类型，见宏定义，如：kLuckItemTypeCST
    NSString *strName;          // 名称
    NSString *strValue;         // 值文本串
    NSInteger nValue;           // 整型值，为负数则表示未设置
}

@property (readonly, nonatomic) Byte btType;
@property (strong, nonatomic) NSString *strName;
@property (readonly, nonatomic) NSString *strValue;
@property (readonly, nonatomic) NSInteger nValue;

+ (id)luckItemWithType:(Byte)type andName:(NSString *)name;
- (id)initWithType:(Byte)type andName:(NSString *)name;

@end
